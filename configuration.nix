{
  inputs,
  pkgs,
  self,
  ...
}:

let
  ax = inputs.ax.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Pin the vendor's stable Apple Silicon release and verify the published
  # archive checksum. AdGuard Home's own updater is disabled because upgrades
  # belong in a reviewed flake change.
  adguardHome = pkgs.stdenvNoCC.mkDerivation {
    pname = "adguardhome";
    version = "0.107.78";

    src = pkgs.fetchurl {
      url = "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.107.78/AdGuardHome_darwin_arm64.zip";
      hash = "sha256-nMv1HlXXoeoT7knsjli7GriKosqTYe7RFmDFZejYogI=";
    };

    nativeBuildInputs = [ pkgs.unzip ];

    unpackPhase = ''
      unzip "$src"
    '';

    installPhase = ''
      mkdir -p "$out/bin"
      cp AdGuardHome/AdGuardHome "$out/bin/AdGuardHome"
      chmod 0555 "$out/bin/AdGuardHome"
    '';
  };
in
{
  imports = [ ./zsh.nix ];

  # Determinate Nix owns the Nix daemon and Nix configuration. Enabling this
  # module prevents nix-darwin from trying to manage the same settings.
  determinateNix = {
    enable = true;

    # Nix defaults to unsandboxed builds on macOS. This host runs code from
    # repositories and package build scripts, so require the supported macOS
    # build sandbox explicitly.
    customSettings.sandbox = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  system = {
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;

    activationScripts.postActivation.text = ''
      /usr/bin/install -d -o root -g wheel -m 0700 /var/lib/AdGuardHome
    '';
  };

  environment.systemPackages = with pkgs; [
    age
    adguardHome
    ax
    bat
    bottom
    delta
    dua
    dust
    eza
    fd
    fzf
    gh
    ghq
    git
    hyperfine
    jq
    just
    lazygit
    procs
    restic
    ripgrep
    sd
    shellcheck
    sops
    tealdeer
    tmux
    tree
    watch
    yq-go
    zoxide
  ];

  programs.direnv.enable = true;

  # Keep the built-in macOS SSH daemon reachable only from Tailscale.
  # User accounts and authorized_keys remain outside Nix management.
  services.openssh = {
    enable = true;
    extraConfig = ''
      AllowUsers *@100.64.0.0/10 *@fd7a:115c:a1e0::/48
      PasswordAuthentication no
      KbdInteractiveAuthentication no
      PermitEmptyPasswords no
      PermitRootLogin no
      X11Forwarding no
    '';
  };

  # AdGuard Home starts as a root launch daemon because DNS uses privileged
  # port 53. The setup UI is forced onto the stable Tailscale address so the
  # initial wizard is never exposed on Ethernet or Wi-Fi.
  launchd.daemons.adguardhome.serviceConfig = {
    ProgramArguments = [
      "${adguardHome}/bin/AdGuardHome"
      "--config"
      "/var/lib/AdGuardHome/AdGuardHome.yaml"
      "--work-dir"
      "/var/lib/AdGuardHome"
      "--web-addr"
      "100.120.189.89:3000"
      "--no-check-update"
    ];
    RunAtLoad = true;
    KeepAlive = true;
    ThrottleInterval = 10;
    ProcessType = "Background";
    UserName = "root";
    GroupName = "wheel";
    WorkingDirectory = "/var/lib/AdGuardHome";
    StandardOutPath = "/var/log/adguardhome.log";
    StandardErrorPath = "/var/log/adguardhome.error.log";
  };

  networking = {
    applicationFirewall = {
      enable = true;
      enableStealthMode = true;
      blockAllIncoming = false;
      allowSigned = true;
      allowSignedApp = true;
    };
    wakeOnLan.enable = true;
  };

  power = {
    restartAfterFreeze = true;
    restartAfterPowerFailure = true;
    sleep = {
      allowSleepByPowerButton = false;
      computer = "never";
      display = 10;
      harddisk = "never";
    };
  };

  # Adopt the existing Homebrew installation without removing anything that
  # is not yet represented here.
  homebrew = {
    enable = true;
    # Run Homebrew as this existing account without managing the account.
    user = "alice";
    onActivation = {
      autoUpdate = false;
      cleanup = "none";
      upgrade = false;
    };
    brews = [ "smartmontools" ];
    casks = [ "ghostty" ];
  };
}
