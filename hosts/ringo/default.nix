{ darwinModules, homebrewModules, ... }: {
  imports = [
    "${darwinModules}/common"
    "${homebrewModules}/common"
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  system.stateVersion = 6;
}
