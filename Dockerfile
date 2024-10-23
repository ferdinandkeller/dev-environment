# start from the most recent ubuntu image
FROM ubuntu:latest

# update the package list & install some basic tools
RUN apt-get update && \
    apt-get install -y tar zip curl wget sudo build-essential make git zsh locales


# === DOCKER ===
# install docker
RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# add ubuntu to the docker group
RUN sudo usermod -aG docker ubuntu


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


# === LANGUAGE SPECIFICS ===
# clone the install scripts folder
COPY --chown=ubuntu:ubuntu install ./install

# === START ===
# start docker daemon
CMD ["sudo", "dockerd"]