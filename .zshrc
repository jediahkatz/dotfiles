# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/home/jediahkatz/.local/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
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
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git gitfast
    docker docker-compose kubectl
    fzf fzf-tab
    zsh-z zsh-autosuggestions zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

export EDITOR='nano'

# Set $SH_OS variable
if test -f /proc/version && rg -q microsoft /proc/version; then
  SH_OS="WSL"
elif [[ "$OSTYPE" = "darwin"* ]]; then
  SH_OS="OSX"
elif [[ "$OSTYPE" = "linux-gnu"* ]]; then
  SH_OS="LINUX"
else
  SH_OS="OTHER"
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ls="lsd"
alias jedia="/mnt/c/Users/jedia"
alias reload="exec ${SHELL} -l"
alias path="echo -e '${PATH//:/\\n}' | cat"
alias help="nano -v ~/.help"
alias cmd="cmd.exe /C"
# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
# https://github.com/mathiasbynens/dotfiles/blob/main/.aliases
alias map="xargs -n1"
if [ "$SH_OS" = "WSL" ]; then
  alias cat="batcat"
  alias fd="fdfind"
else
  alias cat="bat"
fi

# Use Ctrl+Backspace (WSL) or Option+Backspace (OSX) to delete previous word
if [ "$SH_OS" = "WSL" ]; then
  bindkey '^H' backward-kill-word
elif [ "$SH_OS" = "OSX" ]; then
  bindkey '^[^H' backward-kill-word
fi

# Enable completion from man pages
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select

# Use ripgrep instead of find for fzf
if type rg &> /dev/null && type fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND="rg --files --hidden -g '!AppData/' -g '!.git/' -g '!node_modules/' "
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  # But ripgrep has terrible directory search so we'll use fd
  if [ "$SH_OS" = "WSL" ]; then
    export FZF_ALT_C_COMMAND="fdfind -t d . ~ /mnt/c/Users/jedia"
  else
    export FZF_ALT_C_COMMAND="fd -t d . ~"
  fi
fi

# Fix slooooow git autocompletion
__git_files () {
  _wanted files expl 'local files' _files
}

# Copy to clipboard and remove trailing newlines
if [ "$SH_OS" = "WSL" ]; then
  function copy() {
    sed -Ez '$ s/\n+$//' $1 | clip.exe
  }
elif [ "$SH_OS" = "OSX" ]; then
  function copy() {
    perl -pe 'chomp if eof' $1 | pbcopy
  }
fi

# Always work in a tmux session if tmux is installed
# Modified from https://github.com/chrishunt/dot-files/blob/master/.zshrc
# Currently experimenting with setting this in Windows Terminal settings
if which tmux 2>&1 >/dev/null; then
  if [ $TERM != "screen-256color" ] && [ $TERM != "screen" ] \
  && [ "$TERM_PROGRAM" != "vscode" ] && [ "$USING_VSCODE" != "true" ] \
  && [[ "$SH_OS" != "WSL" ]]; then
    tmux new-session -A -s sesh && exit # || { :; cmd.exe /C wt; exit }
  fi
fi

# ####################################
# ###### Only load nodejs when needed:
NVM_DIR="$HOME/.nvm"

# Skip adding binaries if there is no node version installed yet
if [ -d $NVM_DIR/versions/node ]; then
  NODE_GLOBALS=(`find $NVM_DIR/versions/node -maxdepth 3 \( -type l -o -type f \) -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
fi
NODE_GLOBALS+=("nvm", "npm", "diff-so-fancy")

load_nvm() {
  # Unset placeholder functions
  for cmd in "${NODE_GLOBALS[@]}"; do unset -f ${cmd} &>/dev/null; done

  # Load NVM
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

  # (Optional) Set the version of node to use from ~/.nvmrc if available
  nvm use 2> /dev/null 1>&2 || true

  # Do not reload nvm again
  export NVM_LOADED=1
}

for cmd in "${NODE_GLOBALS[@]}"; do
  # Skip defining the function if the binary is already in the PATH
  if ! which ${cmd} &>/dev/null; then
    eval "${cmd}() { unset -f ${cmd} &>/dev/null; [ -z \${NVM_LOADED+x} ] && load_nvm; ${cmd} \$@; }"
  fi
done

# ############## End lazy nodejs loader
# ######################################

# use diff-so-fancy for regular diffs
unalias diff
diff() {
  command diff -u $@ | diff-so-fancy
}

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "${method}"="lwp-request -m '${method}'"
done

# find-in-file (adapted from gbstan) - usage: fif <SEARCH_TERM> <SEARCH_DIR (optional)>
fif() {
  if [ ! "$#" -gt 0 ]; then
    echo "Need a string to search for!";
    return 1;
  fi
  rg --files-with-matches --no-messages "$1" "${2:-.}" | fzf $FZF_PREVIEW_WINDOW --preview "rg --ignore-case --pretty --context 10 '$1' {}"
}

# Python-style slices for files (by jediahkatz)
# Ex: slice "1:5:2", slice "-3:", slice ":5:-1"
slice() {
  local slicearr=("${(@s/:/)1}")
  local start=${slicearr[1]:-0}
  local stop=${slicearr[2]:-""}
  local step=${slicearr[3]:-1}
  if [ $step -eq "0" ]; then
    echo "Slice step cannot be 0.";
    return 1;
  fi
  if [ $start -ge "0" ];
    # Adding 1 because tail is 1-indexed
    then local slice_fromstart=(tail -n "+$(($start + 1))")
    else local slice_fromstart=(tail -n "$((-1 * $start))")
  fi
  if [ -z $stop ]; then
    local slice_tostop=(cat)
  elif [ $stop -ge "0" ]; then
    if [ $start -ge "0" ];
      then local slice_tostop=(head -n "$(($stop - $start))")
      # Hard case
      else
        echo "Slices like [-5:10] are unsupported... implement this if ever needed."
        return 1;
    fi
  else
    local slice_tostop=(head -n $stop)
  fi
  local slice_mayberev=(cat)
  if [ $step -lt "0" ]; then
    local slice_mayberev=(tac)
    local step=$((-1 * step))
  fi
  if [ $step -eq "1" ]; then
    local slice_step=(cat)
  else
    local slice_step=(awk 'NR%$step==1')
  fi
  cat $2 | $slice_fromstart | $slice_tostop | $slice_mayberev | $slice_step
}

# Set special env var when opening vscode from zsh
function code() {
  USING_VSCODE=true command code $@
}

# Use hub to wrap git
function git() { hub $@; }

##################################
########## WSL ONLY CONFIGURATIONS

if [ "$SH_OS" = "WSL" ]; then

  # Send a notification (since `tput bel` is broken)
  function notify() {
    powershell.exe -ExecutionPolicy Bypass "New-BurntToastNotification -Text \"${1:-`date`}\""
  }

  # Find and kill a windows process
  function winkill() {
    # -f = force
    if [ -v $1 ]; then
      local f_flag=""
    elif [ $1 = "-f" ]; then
      local f_flag="/F"
    else
      echo "Invalid option to winkill: $1"
      return 1
    fi
    local pid=`tasklist.exe | fzf | awk '{print $2}'`
    taskkill.exe $f_flag /PID "$pid"
  }

  # Open folders in explorer / open files in the default application
  function open() {
    declare arg="${1:-$(</dev/stdin)}";
    if [ -z $arg ]
      then explorer.exe
    elif [ -e $arg ]
      then explorer.exe `wslpath -aw $arg`
      else explorer.exe $arg
    fi
  }

fi

# Support GUI
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=1

######### END WSL ONLY CONFIGURATIONS
#####################################

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
