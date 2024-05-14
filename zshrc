source ~/.config/zsh/env.zsh
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/plugins.zsh
# source ~/.config/zsh/vi.zsh
source ~/.config/zsh/fzf.zsh
source ~/.config/zsh/mappings.zsh
source ~/.config/zsh/completion.zsh
source ~/.config/zsh/tmux.zsh

if [ -f ~/.sconfig/zsh/zshrc ]; then
	source ~/.sconfig/zsh/zshrc
fi

if [[ ! -d ~/.config/zsh/zsh-autopair ]]; then
  git clone https://github.com/hlissner/zsh-autopair ~/.config/zsh/zsh-autopair
fi
source ~/.config/zsh/zsh-autopair/autopair.zsh
autopair-init
source ~/.zim/modules/fzf-tab/fzf-tab.plugin.zsh

source ~/.config/zsh/prompt.zsh

source ~/.config/zsh/functions/cd_git_root.zsh
