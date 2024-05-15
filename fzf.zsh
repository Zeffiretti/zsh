# export FZF_DEFAULT_OPTS='--bind=ctrl-t:top,change:top --bind ctrl-e:down,ctrl-u:up'
# export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --scroll-off=5 --preview '(highlight -O ansi -n {} || cat {}) 2> /dev/null | head -500'"
# export FZF_DEFAULT_COMMAND='ag -g ""'
# export FZF_DEFAULT_OPTS="--multi --cycle --inline-info --ansi --height 100% \
#    --border --layout=default --preview '$PREVIEW {}' --preview-window \
#    'right:70%:wrap' $FZF_PREVIEW_KEY_BIND"

# export FZF_COMPLETION_OPTS="-1 --cycle --inline-info --ansi --height 60% \
#    --border --layout=reverse --preview '$PREVIEW {}' --preview-window \
#    'right:70%:wrap'  $FZF_PREVIEW_KEY_BIND"
# export FZF_DEFAULT_OPTS='--bind ctrl-e:down,ctrl-u:up --preview "[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (ccat --color=always {} || highlight -O ansi -l {} || cat {}) 2> /dev/null | head -500"'
# export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'



export FZF_DEFAULT_COMMAND='fd'
export FZF_COMPLETION_TRIGGER='\'
export FZF_TMUX=1
export FZF_TMUX_HEIGHT='80%'
export fzf_preview_cmd='[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || highlight -O ansi -l --force {} || cat {}) 2> /dev/null | head -500'

# local extract="
# # trim input
# local in=\${\${\"\$(<{f})\"%\$'\0'*}#*\$'\0'}
# # get ctxt for current completion
# local -A ctxt=(\"\${(@ps:\2:)CTXT}\")
# # real path
# local realpath=\${ctxt[IPREFIX]}\${ctxt[hpre]}\$in
# realpath=\${(Qe)~realpath}
# "
# export PREVIEW="$HOME/.config/zsh/preview.sh"
# # zstyle ':fzf-tab:complete:*:*' extra-opts --preview=$extract";$PREVIEW $realpath"
# # zstyle ':fzf-tab:complete:*:*' extra-opts --preview=$extract";$PREVIEW $realpath"
# zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
# zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
# zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'

# Preview file contents when triggering fzf-tab with vim
# zstyle ':fzf-tab:complet:vim:*' fzf-preview 'highlight -O ansi -l $realpath'
zstyle ':fzf-tab:complete:vim:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:nvim:*' fzf-preview 'highlight -O ansi -l $realpath'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

_fzf_fpath=${0:h}/fzf
fpath+=$_fzf_fpath
autoload -U $_fzf_fpath/*(.:t)
unset _fzf_fpath

fzf-redraw-prompt() {
	local precmd
	for precmd in $precmd_functions; do
		$precmd
	done
	zle reset-prompt
}
zle -N fzf-redraw-prompt

zle -N fzf-find-widget
bindkey '^p' fzf-find-widget

fzf-cd-widget() {
	local tokens=(${(z)LBUFFER})
	if (( $#tokens <= 1 )); then
		zle fzf-find-widget 'only_dir'
		if [[ -d $LBUFFER ]]; then
			cd $LBUFFER
			local ret=$?
			LBUFFER=
			zle fzf-redraw-prompt
			return $ret
		fi
	fi
}
zle -N fzf-cd-widget
bindkey '^t' fzf-cd-widget

fzf-history-widget() {
	local num=$(fhistory $LBUFFER)
	local ret=$?
	if [[ -n $num ]]; then
		zle vi-fetch-history -n $num
	fi
	zle reset-prompt
	return $ret
}
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget

fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

find-in-file() {
	grep --line-buffered --color=never -r "" * | fzf
}
zle -N find-in-file
bindkey '^f' find-in-file

