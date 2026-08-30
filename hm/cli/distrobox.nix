_: {
  programs.distrobox = {
    enable = true;
    containers = {
      ubuntu = {
        image = "quay.io/toolbx/ubuntu-toolbox:latest";
      };
    };
  };
}
