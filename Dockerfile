FROM debian:buster-slim

LABEL maintainer="Mickael MASQUELIN <mickael.masquelin@univ-lille.fr>"

# Setup some environment vars
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /home/user
ENV LANG C.UTF-8
ENV TZ Europe/Paris

# Workaround tty check
# See https://github.com/hashicorp/vagrant/issues/1673#issuecomment-26650102
RUN sed -i 's/^mesg n/tty -s \&\& mesg n/g' /root/.profile

# Set bash "strict mode" to catch problems and bugs while running shell scripts
# Update apt cache, upgrade and install all dependencies
RUN set -eux; \
    apt-get update -qq -y \
    && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
    && apt-get install -qq -y --no-install-recommends bsdmainutils build-essential \
       ca-certificates curl dnsutils docker.io gcc git gnupg2 jq less libc-dev login make man neovim openssh-client \ 
       python3-minimal python3-pip python3-setuptools tmux tmux-plugin-manager uidmap wget whois zsh \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/*

# Install docker-compose
RUN pip3 install docker-compose

# Quick fix for gpg2
RUN mkdir /root/.gnupg \
    && echo "disable-ipv6" >> /root/.gnupg/dirmngr.conf

# Install latest su-exec
RUN  set -eux; \
     curl -o /usr/local/bin/su-exec.c https://raw.githubusercontent.com/ncopa/su-exec/master/su-exec.c; \
     gcc -Wall \
         /usr/local/bin/su-exec.c -o/usr/local/bin/su-exec; \
     chown root:root /usr/local/bin/su-exec; \
     chmod 0755 /usr/local/bin/su-exec; \
     rm /usr/local/bin/su-exec.c

# Configure text editor - vim!
RUN curl -fLo ${HOME}/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Clone the git repos of Vim plugins
WORKDIR ${HOME}/.config/nvim/plugged/
RUN git clone --depth=1 https://github.com/ctrlpvim/ctrlp.vim && \
    git clone --depth=1 https://github.com/tpope/vim-fugitive && \
    git clone --depth=1 https://github.com/godlygeek/tabular && \
    git clone --depth=1 https://github.com/plasticboy/vim-markdown && \
    git clone --depth=1 https://github.com/vim-airline/vim-airline && \
    git clone --depth=1 https://github.com/vim-airline/vim-airline-themes && \
    git clone --depth=1 https://github.com/vim-syntastic/syntastic && \
    git clone --depth=1 https://github.com/frazrepo/vim-rainbow && \
    git clone --depth=1 https://github.com/airblade/vim-gitgutter && \
    git clone --depth=1 https://github.com/derekwyatt/vim-scala

# In the entrypoint, a user called `user` will be created
WORKDIR ${HOME}

# Setup my default $SHELL
ENV SHELL /bin/zsh

# Install oh-my-zsh
RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/plugins/zsh-autosuggestions

# Default command to run
CMD ["tail", "-f", "/dev/null"]