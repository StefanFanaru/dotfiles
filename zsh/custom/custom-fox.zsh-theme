# fox.zsh-theme

export azsub=$(az account show --query 'name' -o tsv)
export kubecontext=$(kubectl config current-context)

PROMPT='%{$fg[cyan]%}┌[%{$fg_bold[white]%}$azsub%{$reset_color%}%{$fg[cyan]%}]%{$fg[white]%}-%{$fg[cyan]%}[%{$fg_bold[white]%}$kubecontext%{$reset_color%}%{$fg[cyan]%}]%{$fg[white]%}-%{$fg[cyan]%}(%{$fg_bold[white]%}%~%{$reset_color%}%{$fg[cyan]%})
└> % %{$reset_color%}'

