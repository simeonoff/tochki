-- Rex config. Rex doesn't watch this file: run `rex config reload` after editing.
-- Pane splits, tabs and session switching use Rex's default shortcuts.

-- Ctrl+arrows move between Rex panes. In Neovim the key passes through, and
-- Neovim hands focus back to Rex at the edge of its own windows
-- (see utils.navigate in the Neovim config).
local terminal = 'com.superlogical.terminal'
local passthrough = { nvim = true, vim = true, view = true, fzf = true, tmux = true }

local function navigate(direction)
  return function(ctx)
    local process = rex.block.call(terminal, 'process', { block_id = ctx.block_id })
    local foreground = process and process.foreground and process.foreground.name

    if passthrough[foreground] then return false end

    rex.session.focus_direction({ session_id = ctx.session_id, direction = direction })
    return true
  end
end

rex.bind('ctrl+left', navigate('left'))
rex.bind('ctrl+right', navigate('right'))
rex.bind('ctrl+up', navigate('up'))
rex.bind('ctrl+down', navigate('down'))

-- Lazygit for the focused pane's directory, in a floating pane. Quitting lazygit closes it.
local function block_cwd(block_id)
  local result = rex.block.call(terminal, 'pwd', { block_id = block_id })
  if not (result and result.pwd) then return nil end

  -- pwd is a file:// URL with a host, e.g. file://host/Users/me/My%20Project
  local path = result.pwd:gsub('^file://[^/]*', '')
  return (path:gsub('%%(%x%x)', function(hex) return string.char(tonumber(hex, 16)) end))
end

rex.action({
  name = 'lazygit',
  title = 'Open Lazygit',
  description = "Open lazygit for the focused pane's directory in a floating pane",
  category = 'Git',
  keywords = 'git lazygit float popup',
  run = function(ctx)
    return rex.session.new_layer({
      session_id = ctx.session_id,
      bounds = { 0.05, 0.05, 0.9, 0.9 },
      focus = true,
      layout = rex.layout.block({
        flavor = 'com.superlogical.terminal.shell',
        options = { command = { 'lazygit' }, cwd = block_cwd(ctx.block_id) },
      }),
    })
  end,
})

-- Replaces Rex's default cmd+g (find next)
rex.bind('cmd+g', 'lazygit')

-- Move the focused pane. Rex's own pane.move.* only swaps with a pane that already
-- lies in that direction, so with nothing there, re-split the pane's neighbour instead:
-- moving down from side-by-side panes stacks the pane below its neighbour.
local eps = 1e-6
local axis = {
  left = { split = 'horizontal', side = 'before' },
  right = { split = 'horizontal', side = 'after' },
  up = { split = 'vertical', side = 'before' },
  down = { split = 'vertical', side = 'after' },
}

local function leaves(node, out)
  out = out or {}
  if node.block_id then
    table.insert(out, node)
  elseif node.split then
    leaves(node.split.before, out)
    leaves(node.split.after, out)
  end
  return out
end

-- The sibling subtree of the leaf holding block_id, or nil when the pane is alone
local function sibling_of(node, block_id)
  if not node.split then return nil end
  local before, after = node.split.before, node.split.after
  if before.block_id == block_id then return after end
  if after.block_id == block_id then return before end
  return sibling_of(before, block_id) or sibling_of(after, block_id)
end

local function overlaps(a0, a1, b0, b1) return a0 < b1 - eps and b0 < a1 - eps end

local function has_neighbour(me, others, direction)
  local x, y, w, h = me.rect[1], me.rect[2], me.rect[3], me.rect[4]
  for _, o in ipairs(others) do
    local ox, oy, ow, oh = o.rect[1], o.rect[2], o.rect[3], o.rect[4]
    if (direction == 'left' and ox + ow <= x + eps and overlaps(y, y + h, oy, oy + oh))
      or (direction == 'right' and ox >= x + w - eps and overlaps(y, y + h, oy, oy + oh))
      or (direction == 'up' and oy + oh <= y + eps and overlaps(x, x + w, ox, ox + ow))
      or (direction == 'down' and oy >= y + h - eps and overlaps(x, x + w, ox, ox + ow)) then
      return true
    end
  end
  return false
end

local function center_distance(a, b)
  local dx = (a.rect[1] + a.rect[3] / 2) - (b.rect[1] + b.rect[3] / 2)
  local dy = (a.rect[2] + a.rect[4] / 2) - (b.rect[2] + b.rect[4] / 2)
  return dx * dx + dy * dy
end

rex.action({
  name = 'move_pane',
  title = 'Move Pane (restack)',
  description = 'Move the focused pane, stacking it beside its neighbour when no pane lies that way',
  category = 'Panes',
  args = { direction = 'string' },
  run = function(ctx, args)
    local direction = args.direction
    local view = rex.session.view({ session_id = ctx.session_id })
    if not view then return end

    for _, window in ipairs(view.windows or {}) do
      for _, layer in ipairs(window.layers or {}) do
        if layer.kind == 'tiled' then
          local all = leaves(layer.layout)
          local me, others = nil, {}
          for _, leaf in ipairs(all) do
            if leaf.block_id == ctx.block_id then me = leaf else table.insert(others, leaf) end
          end

          if me then
            if has_neighbour(me, others, direction) then
              rex.client.queue('pane.move.' .. direction)
              return
            end

            local sibling = sibling_of(layer.layout, me.block_id)
            if not sibling then return end

            local anchor = nil
            for _, leaf in ipairs(leaves(sibling)) do
              if not anchor or center_distance(me, leaf) < center_distance(me, anchor) then anchor = leaf end
            end

            return rex.session.move_block({
              session_id = ctx.session_id,
              block_id = me.block_id,
              anchor_block_id = anchor.block_id,
              direction = axis[direction].split,
              side = axis[direction].side,
            })
          end
        end
      end
    end
  end,
})

-- Pane mode: cmd+m, then arrows move the focused pane and shift+arrows resize it.
-- Escape or enter leaves the mode; other keys are ignored while it's active.
rex.mode('pane', { exclusive = true })
rex.bind('cmd+m', 'client.mode.enter', { name = 'pane' })
rex.bind('pane/enter', 'client.mode.exit')

for _, direction in ipairs({ 'left', 'right', 'up', 'down' }) do
  rex.bind('pane/' .. direction, 'move_pane', { direction = direction })
  rex.bind('pane/shift+' .. direction, 'pane.resize', { direction = direction })
end
