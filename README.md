# Tochki - A Portable Nix Configuration

> [!WARNING]
> This repository is live and may change at any time. It is not guaranteed to work on all systems. It is recommended to use it as a reference and adapt it to your needs.

The configuration is written in a functional language called [Nix](https://nix.dev/tutorials/nix-language#reading-nix-language). It looks like JSON with functions and allows us to manage various parts of our Operating System, including the installation of packages, the management of system settings, configuration files, and more. It supports host-based configurations for macOS and NixOS.

> [!NOTE]
> A video on [YouTube](https://www.youtube.com/watch?v=Z8BL8mdzWHI&list=PLpolRIvVVWRCS-X0-3q2hrWrbrsWJl51J&index=7) piqued my interest initially. If you're new to Nix, I recommend watching it first to get a basic understanding of what Nix is and how to configure it. It's your responsibility to learn more about Nix and adapt what's said in the video to your taste and requirements.

## Getting Started

### Step 1 - Install Nix Package Manager

```sh
sh <(curl -L https://nixos.org/nix/install)
```

### Step 2 - Get the configuration (tochki)

This is ideally stored on a remote server/service that is going to be available at all times. GitHub is a good place as you've used it so far to store your dotfiles there anyway.

###### From the root `~` directory run:

```sh
nix-shell -p git --run 'git clone git@github.com:simeonoff/tochki.git'
```

This will launch a custom nix shell with git in it and git clone the configuration.

### Step 3 - Enable Flakes

Before you can use the configuration, you need to enable flakes in your Nix installation:

```sh
mkdir -p ~/.config/nix
echo 'experimental-features = ["nix-command" "flakes"]' >> ~/.config/nix/nix.conf
```

### Step 4 - Install the configuration

###### Apply the system configuration using nix

```sh
nix run nix-darwin -- switch --flake ~/tochki#hostname
```

###### Apply the home manager configuration

```bash
nix-shell -p home-manager --run home-manager switch --flake ~/tochki#user@hostname
```

### Step 5 - Verify Installation

Verify that the system configuration was installed correctly:

```sh
# Verify nix-darwin installation
darwin-rebuild --version
```

## How it all works?

This setup depends on the [nix package manager](https://nixos.org/download/) being installed with the [nix flakes](https://wiki.nixos.org/wiki/Flakes) feature enabled.

```nix
experimental-features = ["nix-command" "flakes"];
```

After that, you can execute the following command while in the folder where your configuration will be stored:

```sh
nix flake init -t nix-darwin
```

This assumes that the host operating system is macOS.

After running the command, a new file `flake.nix` will be created. This file is essentially the entry point of the config that will be used when restoring the settings for packages, apps, and system settings to be applied.

To apply the config stored in this `flake.nix` file for the first time, all we have to do is the following (this command assumes you've initialized your config in `~/nix-config`):

```sh
nix run nix-darwin -- switch --flake ~/nix-config#hostname
```

## How to use this configuration?

> [!NOTE]
> For this configuration, I followed [this](https://github.com/AlexNabokikh/nix-config) approach for splitting my config into manageable parts. This means that home packages are managed independently of system packages installed using nix.

Here's a high-level overview (cheatsheet) of what needs to be run to update configs:

On macOS:
```sh
darwin-rebuild switch --flake ~/tochki#hostname
```

On NixOS:
```sh
sudo nixos-rebuild switch --flake ~/tochki#hostname
```

On both platforms:
```sh
home-manager switch --flake ~/tochki#username@hostname
```

To learn more about flakes, visit the [official wiki](https://wiki.nixos.org/wiki/Flakes).
This is a simplified overview of the `flake.nix` file and the overall folder structure.

### Structure

- `flake.nix` - the entry point. Defining inputs for NixOS, [nix-darwin](https://github.com/nix-darwin/nix-darwin), [nix-homebrew](https://github.com/zhaofengli/nix-homebrew), [flake-parts](https://flake.parts), and [Home Manager](https://github.com/nix-community/home-manager).
- `flake.lock` - Lock file ensuring reproducible builds.
- `devshells` - Nix shells for various development environments (`node`, `python`, `go`, etc.).
- `hosts/` - system configurations for each machine.
- `home/` - home manager configurations for each machine.
- `files/` - various files and scripts used across packages and modules.
- `modules/` - Reusable platform-specific modules:
	- `nixos/` - NixOS-specific configuration modules.
	- `darwin/` - macOS-specific configuration modules.
	- `home-manager/` - Home Manager specific modules. Shared across systems.
	- `homebrew/` - Homebrew related modules. Usually for macOS GUI applications.
- `overlays/` - Custom Nix overlays for package modification or addition.

#### Key Inputs

- `nixpkgs` - Points to `nixos-unstable` channel to access the latest packages.
- `home-manager` - Manages user-specific configurations. Follows latest stable input.
- `nix-darwin` - Enables `nix-darwin` for macOS specific configuration.
- `nix-homebrew` - Manages Homebrew installations on macOS via `nix-darwin`.
- `flake-parts` - Enables easy creation of `system` specific flakes.

### Usage

#### Adding new hosts

##### Update the `flake.nix` file
1. Add a new user to the `users` attribute set:

    ```nix
    users = {
        # Existing users...
        newuser = {
            email = "newuser@example.com";
            fullName = "Jon Snow";
            sshKey = "YOUR PUBLIC SSH KEY";
            name = "username";
        };
    };
    ```

2. Add the new host to the appropriate configuration set:

    For `macOS`:

    ```nix
    darwinConfigurations = {
        newhost = mkDarwinConfiguration "hostname" "username"
    };
    ```

    For `NixOS`:

    ```nix
    nixosConfigurations = {
        newhost = mkDarwinConfiguration "hostname" "username"
    };
    ```

3. Add the new home configuration:

    ```nix
    homeConfigurations = {
        "newuser@newhost" = mkHomeConfiguration "arch" "newuser" "newhost";
    };
    ```

#### Adding System Configurations

##### Create the directory structure

1.  Add a folder under `hosts/` named after your host:

    ```sh
    mkdir -p hosts/newhost
    ```

2.  Create `default.nix` for your new host. This will be the entry point for all system-related configurations:

    ```sh
    touch hosts/newhost/default.nix
    ```

3. Add some basic configuration in `default.nix`:

    For `NixOS` hosts:

    ```nix
    { hostname, nixosModules, ... }:

    {
        imports = [
            ./hardware-configuration.nix,
            "${nixosModules}/common"
        ];

        networking.hostName = hostname;

        system.stateVersion = "24.11";
    }
    ```

    For `macOS` hosts:

    ```nix
    { darwinModules, homebrewModules, ... }:

    {
      imports = [
        "${darwinModules}/common"
        "${homebrewModules}/common"
      ];

      system.stateVersion = 6;
    }
    ```

For `NixOS` hosts, generate the `hardware-configuration.nix` by running:

```sh
sudo nixos-generate-config --show-hardware-config > hosts/newhost/hardware-configuration.nix
```

#### Adding Home Configurations

##### Create the directory structure

1. Create a couple of folders under `home/`. The first should match the username (`newuser`), the second your hostname (`newhost`):

    ```sh
    mkdir -p home/newuser/newhost
    ```

2.  Create `default.nix` for your new user under this host. This will be the entry point for all user home-related configurations:

    ```sh
    touch home/newuser/newhost/default.nix
    ```

3. Add some basic configuration in `default.nix`:

    ```nix
    { homeModules, ... }:
    {
      imports = [
        "${homeModules}/common"
      ];

      programs.home-manager.enable = true;

      home.stateVersion = "24.11";
    }
    ```

#### Applying the Configuration

##### Make sure to stage all newly created nix modules first:

From `~/tochki` run:

```sh
git add .
```

On macOS, run:

```sh
darwin-rebuild switch --flake ~/tochki#newhost
```

On NixOS, run:

```sh
sudo nixos-rebuild switch --flake ~/tochki#newhost
```

> [!IMPORTANT]
> On new systems, to ensure home-manager is available in your `$PATH`, run:
> ```sh
> nix-shell -p home-manager --run home-manager switch --flake ~/tochki#newuser@newhost
> ```

This will execute home-manager in a nix shell and make it available to your host system.

After that you can simply run the following when changing your home configuration:

```sh
home-manager switch --flake ~/tochki#newuser@newhost
```

### Updating

The following command updates all flakes and the respective packages:

```sh
nix flake update
```

> [!NOTE]
> All homebrew packages will be automatically updated upon configuration updates.

### Rollback Procedure

If you encounter issues after updating or making changes to your configuration, you can roll back to a previous working state:

```sh
# Roll back to previous system generation
darwin-rebuild switch --flake ~/tochki#hostname --rollback

# Roll back home configuration
home-manager switch --flake ~/tochki#username@hostname --rollback
```

### Modules and Configurations

> [!NOTE]
Some modules have specific configurations that are not handled by home-manager. `Neovim` is a notable example. While `home-manager` still manages the package and extra-packages (only available in the `Neovim` environment) like LSPs, linters, formatters, etc., the `Neovim` configuration files are a part of the [nix store](https://nixos.org/guides/how-nix-works/). This allows us to manage plugins and editor configurations "live" without needing to rebuild the `home-manager` configuration after each change.

To change the configuration of `Neovim`, edit the files located directly under:

```sh
cd modules/home-manager/programs/neovim/config/nvim/
```


To learn more about what packages are available, and what their respective options are:

- Visit [search.nixos.org](https://search.nixos.org)
- See [home-manager options](https://home-manager-options.extranix.com/?query=&release=master)

## Node.js with the Nix Package Manager

> [!WARNING]
Since nix package installations are read-only, we cannot simply do `npm install -g package-name` as it violates the Nix principles. You can read more about it [here](https://nixos.wiki/wiki/Node.js).

To work around this limitation, we create an `~/.npm-global` folder where global packages will be stored. A global environment variable `$NPM_CONFIG_PREFIX` is set to this location.

This directory also needs to be added to the global `$PATH`.

In `.zshrc` add:

```sh
# Modifications for nodejs with nix
export PATH=${PATH}:${HOME}/.npm-global/bin
```

This configuration automatically adds the path for `Nushell`, which is the default shell.

## Development Environments

This configuration creates nix shells that can be used to quickly switch between [Node.js](https://nodejs.org/en) versions. New nix shells [can be added](https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell-usage) by creating a shell module and appending it to `devshells/default.nix`.

### Using a development shell

In the root of a project, create a `.envrc` file:

```sh
touch .envrc
```

Edit the file and add the following line to it noting the development key in the attribute set of shells you've created.

The following line instructs [direnv](https://direnv.net)  to use Node.js version 22 from our nix shells.

```sh
use flake ~/tochki#nodejs22
```

To allow `direnv` to use the shell, run:

```sh
direnv allow .
```

### Basic Troubleshooting

Common issues you might encounter:

1. **Flakes not enabled**: If you get errors about flakes not being supported, ensure you've enabled experimental features as described in Step 3.

2. **Permission denied errors**: Ensure you have the correct permissions for the directories you're modifying.

3. **Home-manager unavailable**: Always use the nix-shell approach on a fresh system before using the regular home-manager command.
