# start from the most recent ubuntu image
FROM ubuntu:latest

# update the package list & install some basic tools
RUN apt-get update && \
    apt-get install -y curl wget sudo


# === MACHINE ===
# set the timezone to UTC
# RUN timedatectl set-timezone UTC
ENV TZ=etc/UTC


# === COLORS ===
# enable colored output in the terminal
ENV TERM=xterm-256color


# === USER ===
# create a new user 'devuser' and add to sudoers
RUN useradd -m -s /bin/bash devuser && \
    echo 'devuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# set the new user as the default user
USER devuser

# set the working directory
WORKDIR /home/devuser


# === GIT ===
# install git
RUN sudo apt-get install -y git

# install git config
COPY .gitconfig .


# === SHELL ===
# install & configure zsh
RUN sudo apt-get install -y zsh && \
    sudo chsh -s /usr/bin/zsh

# install oh-my-zsh (keep the default theme)
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"


# === EDITOR ===
# install neovim
RUN sudo apt-get install -y neovim


# === TMUX ===
# install tmux
RUN sudo apt-get install -y tmux

# clone tmux plugin manager
RUN mkdir -p .tmux/plugins && \
    git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm

# clone tmux config
COPY .tmux.conf .


# === GO ===
# install go
RUN sudo apt-get install -y golang-go


# === START ===
# we want to start with a z shell by default
CMD ["/usr/bin/zsh"]