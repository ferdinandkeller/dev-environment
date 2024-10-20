# start from the most recent ubuntu image
FROM ubuntu:latest

# update the package list & install some basic tools
RUN apt-get update && \
    apt-get install -y tar zip curl wget sudo build-essential make git zsh locales


# === USER ===
# add ubuntu to sudoers & remove password
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    passwd -d ubuntu

# set the working directory
WORKDIR /home/ubuntu

# switch to the ubuntu user
USER ubuntu


# === MACHINE ===
# set the timezone to UTC
# RUN timedatectl set-timezone UTC
ENV TZ=etc/UTC

# set the locale to en_US.UTF-8
RUN sudo locale-gen en_US.UTF-8 && \
    sudo update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

# enable colored output in the terminal
ENV TERM=xterm-256color


# === GIT ===
# install git config
COPY --chown=ubuntu:ubuntu .gitconfig .


# === SHELL ===
# change default shell
RUN chsh -s /usr/bin/zsh

# install oh-my-zsh (keep the default theme)
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"


# === EDITOR ===
# install neovim
RUN sudo apt-get install -y neovim

# copy neovim config
COPY --chown=ubuntu:ubuntu init.lua .config/nvim/init.lua


# === TMUX ===
# install tmux
RUN sudo apt-get install -y tmux

# clone tmux plugin manager
RUN mkdir -p .tmux/plugins && \
    git clone https://github.com/tmux-plugins/tpm .tmux/plugins/tpm

# clone tmux config
COPY --chown=ubuntu:ubuntu .tmux.conf .


# === GO ===
# install go
RUN sudo apt-get install -y golang-go


# === START ===
# we want to start with a z shell by default
CMD ["/usr/bin/zsh"]