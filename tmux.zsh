tmux_preexec() {
    local tmux_event=${TMUX%%,*}-event/client-attached-pane
    if [[ -f $tmux_event-$TMUX_PANE ]]; then
        eval $(tmux showenv -s)
        command rm $tmux_event-$TMUX_PANE 2>/dev/null
    fi
}

if [[ -n $TMUX ]]; then
    local tmux_event=${TMUX%%,*}-event/client-attached-pane
    command rm $tmux_event-$TMUX_PANE 2>/dev/null

    autoload -U add-zsh-hook
    add-zsh-hook preexec tmux_preexec
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
    zstyle ':fzf-tab:*' popup-pad 30 0
fi

# if [[ -n $TMUX_PANE ]] && (( $+commands[tmux] )) && (( $+commands[fzfp] )); then
#     # fallback to normal fzf if current session name is `floating`
#     export TMUX_POPUP_NESTED_FB='test $(tmux display -pF "#{==:#S,floating}") == 1'

#     export TMUX_POPUP_WIDTH=80%
# fi
