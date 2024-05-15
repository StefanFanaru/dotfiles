export FZF_DEFAULT_COMMAND="rg --files --hidden
--preview 'bat --color=always --style=numbers --line-range=:500 {}'
--bind 'ctrl-/:toggle-preview'"
export FZF_CTRL_T_OPTS="
	--layout=reverse
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xsc)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"
export FZF_TMUX_OPTS='-p80%,60%'
