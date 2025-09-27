# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
# ZSH_THEME="lambda"
# ZSH_THEME="candy"
ZSH_THEME="daveverwer"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# ---- completion: do ours first, and skip OMZ's global compinit ----
# export skip_global_compinit=1
# autoload -Uz compinit
# ZSH_COMPDUMP=${ZSH_COMPDUMP:-~/.zcompdump-$HOST-$ZSH_VERSION}
#
# if [[ -r "$ZSH_COMPDUMP.zwc" && "$ZSH_COMPDUMP.zwc" -nt "$ZSH_COMPDUMP" ]]; then
#   source "$ZSH_COMPDUMP.zwc"
# else
#   compinit -C -d "$ZSH_COMPDUMP"   # creates/refreshes dump when needed
#   [[ -r "$ZSH_COMPDUMP" ]] && zcompile -R "$ZSH_COMPDUMP.zwc" "$ZSH_COMPDUMP" 2>/dev/null
# fi

export skip_global_compinit=1
ZSH_COMPDUMP=${ZSH_COMPDUMP:-~/.zcompdump-$HOST-$ZSH_VERSION}
autoload -Uz compinit

_lazy_compinit_then_complete() {
  # run once
  zle -D complete-word 2>/dev/null
  compinit -C -d "$ZSH_COMPDUMP"
  [[ -r "$ZSH_COMPDUMP" ]] && zcompile -R "$ZSH_COMPDUMP.zwc" "$ZSH_COMPDUMP" 2>/dev/null
  zle complete-word        # perform the original action
}
zle -N _lazy_compinit_then_complete
bindkey '^I' _lazy_compinit_then_complete  # ^I is Tab

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  fzf
  fzf-tab
  zsh-autosuggestions
  zsh-syntax-highlighting
)

eval "$(zoxide init zsh)"

zstyle ':completion:*' menu no
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

FZF_TAB_FLAGS=(
  --layout=reverse-list
  --preview-window=right:50%
  --height=60%
  --style=full
  --border
  --padding=1,2
  --input-label=' Input '
  --bind='result:transform-list-label:if [[ -z $FZF_QUERY ]]; then echo " $FZF_MATCH_COUNT items "; else echo " $FZF_MATCH_COUNT matches for [$FZF_QUERY] "; fi'
  --color='border:#9999cc'
  --color='preview-border:#9999cc,preview-label:#ccccff'
  --color='list-border:#9999cc,list-label:#ccccff'
  --color='input-border:#286983,input-label:#9ccfd8'
  --color='header-border:#6699cc,header-label:#99ccff'
)
zstyle ':fzf-tab:complete:*' fzf-flags ${FZF_TAB_FLAGS[@]}
zstyle ':fzf-tab:complete:*' fzf-preview 'lsd --tree --depth 2 --sort extension --group-directories-first $realpath'

# autoload -U promptinit; promptinit
# prompt pure

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source ~/.zsh_profile
source ~/.zsh_aliases

wt() {
  git worktree add "$@"
  dir="${@: -1}"

  cp .ruby-gemset "$dir"/.ruby-gemset
  cp -r .bundle/ "$dir"/.bundle/
  cp .rubocop.yml "$dir"/.rubocop.yml

  cd "$dir" || return

  if git show-ref --verify --quiet refs/heads/main; then
    base_branch="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    base_branch="master"
  else
    echo "❌ Could not detect main or master branch."
    return 1
  fi

  echo "🔄 Rebasing current branch onto $base_branch..."
  git fetch origin
  git rebase "origin/$base_branch" || {
    echo "⚠️ Rebase failed — please resolve conflicts manually."
    return 1
  }

  echo "✅ Rebased onto $base_branch."
}

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
#
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
