{ ... }:

{
  programs.git.enable = true;
  programs.dircolors = {
    enable = true;
    enableFishIntegration = true;
  };

  home.file.".gitconfig".text = ''
    [core]
      pager = less -FRX
    [user]
    	email = 44554692+comejv@users.noreply.github.com
    	name = Côme VINCENT
    [url "ssh://git@github.com/"]
    	insteadOf = https://github.com/
    [init]
    	defaultBranch = main
    [push]
    	autoSetupRemote = true
    [pull]
    	rebase = false
    [diff]
    	tool = nvimdiff
    [difftool]
    	prompt = false
  '';
}
