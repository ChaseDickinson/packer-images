# Path to your oh-my-zsh installation.
export ZSH="/home/ubuntu/.oh-my-zsh"

# Environment variables
export CHEF_LICENSE="accept-no-persist"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=1
export DISABLE_UPDATE_PROMPT=true

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
HIST_STAMPS="yyyy/mm/dd"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  aws
  colored-man-pages
  docker
  git
  vscode
)

source $ZSH/oh-my-zsh.sh

# ------------------------------
# User Settings
# ------------------------------

# ------------------------------
# Misc Config
# ------------------------------
complete -C aws_completer aws

# ------------------------------
# Functions
# ------------------------------
function awsCliUpdate() {
  cd $HOME
  bin_directory="/usr/local/bin"
  install_directory="/usr/local/aws-cli"

  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install --bin-dir "${bin_directory}" --install-dir "${install_directory}" --update
  rm awscliv2.zip
  rm -rf aws
}

function randoPass() {
  numChars="$1"

  value=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9~!@#$%^&*_-' | head -c "$numChars")
  echo $value
}

# ------------------------------
# Aliases
# ------------------------------

# Misc
alias a="alias"
alias rp="randoPass"
alias zshc="code ~/.zshrc"
alias zshr="source ~/.zshrc"

# AWS
alias awsconf="code ~/.aws/config"
alias awscred="code ~/.aws/credentials"
alias awsupdate="awsCliUpdate"
alias awsi="aws sts get-caller-identity"
