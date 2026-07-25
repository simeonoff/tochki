# Node.js development shells
{ pkgs }:

{
  # Node.js 22.x environment
  nodejs22 = pkgs.mkShell {
    buildInputs = with pkgs; [ nodejs_22 ];
  };

  # Node.js 24.x environment
  nodejs24 = pkgs.mkShell {
    buildInputs = with pkgs; [ nodejs_24 ];
  };

  # Node.js 26.x environment
  nodejs26 = pkgs.mkShell {
    buildInputs = with pkgs; [ nodejs_26 ];
  };
}
