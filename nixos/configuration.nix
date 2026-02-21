{ config, lib, pkgs, ... }:
# welcome to my one file nixOS config!
# it's meant to be minimal, understandable, and modifiable
######################################
### sections are denoted like this ###
######################################

{
############
### MAIN ###
############


	imports = [ ./hardware-configuration.nix # => ./and/also.nix ./your/files/go.nix ./here.nix <=
		];

	boot.initrd.kernelModules = [ "amdgpu" ];
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	nixpkgs.config.allowUnfree = true;

	nix.gc = {
		automatic = true;
		dates = "15:00";
		options = "-d";
	};

	networking.hostName = "thinkpad"; # Define your hostname.
	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
	time.timeZone = "America/Argentina"; # didn't work anyway lol
	i18n.defaultLocale = "en_US.UTF-8"; # locales

	users.users.ookami = {
		isNormalUser = true;
		extraGroups = [ "wheel" ];
	};



################
### PROGRAMS ###
################

	environment.systemPackages = with pkgs; [
		# essentials
		wget curl git mpv tmux feh stow btop 7zip tree

 		# bling
		fastfetch fortune cowsay lolcat
		# cava cmatrix pastel astroterm pfetch

		# user
		krita libreoffice lmms mangohud obs-studio obsidian scrcpy ungoogled-chromium ytfzf

		# programming
		elixir ffmpeg gcc gdb love lua python3 zig

		# rice
		hyprpaper hyprland kitty wofi waybar

		# gaming
		prismlauncher osu-lazer steam
		protonup-ng gamemode

		# testing
		kdePackages.kdenlive moonlight-qt sunshine
	];

	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		dedicatedServer.openFirewall = true;
		localNetworkGameTransfers.openFirewall = true;
	};

	programs.neovim = {
		defaultEditor = true;
		viAlias = true;
	};

	programs.bash = {
		shellAliases = {
			wifi = "nmtui-connect";
			vi = "nvim";
			fcl = "fortune | cowsay | lolcat";
		};
	};



##############
### RICING ###
##############

	programs.hyprland.enable = true;
	programs.hyprland.withUWSM = true;
	programs.hyprland.xwayland.enable = true;

	fonts.packages = with pkgs; [
		nerd-fonts.space-mono
	];



################
### SERVICES ###
################

	services.openssh.enable = true; # SSH
	services.printing.enable = true; # CUPS
	services.libinput.enable = true; # touchpad
	services.xserver.videoDrivers = ["amdgpu"]; # for steam

	services.flatpak.enable = true;

		services.pipewire = {
			enable = true;
		pulse.enable = true;
	};



######################
### TO DO AND MISC ###
######################

# verb	(tag)	: task  # how I organize this part; they must be aligned for better readability.

# check			(functionality)	: SUID wrappers
# do			(flatpaks)		: declare flathub in-config
# investigae	(chromium)		: plugin declaration	(ublock, decentraleyes, vimium, stylus, violentmonkey/greasemonkey)
# investigae	(chromium)		: userscript declaration
# investigate	(alternatives)	: flakes as nix modules


	system.copySystemConfiguration = true; # jic; don't delete this.
	system.stateVersion = "25.05"; # -DO NOT- change this. (unless you HAVE to)
}
