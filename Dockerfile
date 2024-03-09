FROM rust:1.75 AS rust_base 
FROM nvidia/cuda:11.8.0-devel-ubuntu22.04 as cuda_base
FROM cuda_base AS merged_base
COPY --from=rust_base /usr/local/cargo /usr/local/cargo 
COPY --from=rust_base /usr/local/rustup /usr/local/rustup 

ENV PATH="/usr/local/cargo/bin:${PATH}"
ENV RUSTUP_HOME="/usr/local/rustup"
ENV CARGO_HOME="/usr/local/cargo"
ENV DEBIAN_FRONTEND noninteractive 
ENV USER root 
ENV HOME /root 
USER ${USER} 

RUN rustup component add rustfmt && \
    rustup component add rust-analyzer

RUN apt-get update -y && apt-get install -y \
    clang-format \
    clang-tools \ 
    clang \
    clangd \ 
    libc++-dev \ 
    libc++1 \ 
    libc++abi-dev \ 
    libc++abi1 \ 
    libclang-dev \ 
    libclang1 \ 
    liblldb-dev \ 
    libomp-dev \ 
    libomp5 \ 
    lld \ 
    lldb \ 
    llvm-dev \ 
    llvm-runtime \ 
    llvm \ 
    python3-clang \
    lsb-release \
    cmake \
    ripgrep \
    gettext \
    python3.10 \ 
    python3-pip \ 
    vim \
    software-properties-common \ 
    gnupg \
    git \ 
    ninja-build \ 
    cuda-nsight-systems-11-8 \ 
    zip \
    wget \
    xclip

RUN pip install numpy scipy matplotlib 
WORKDIR / 
RUN wget https://github.com/artempyanykh/marksman/releases/download/2023-12-09/marksman-linux-x64 && \
    mv marksman-linux-x64 marksman && chmod +x marksman && \ 
    mkdir /root/.local && \
    mkdir /root/.local/bin && \
    mv marksman /root/.local/bin 

ENV PATH="/root/.local/bin:${PATH}"
WORKDIR / 

RUN git clone https://github.com/neovim/neovim 
WORKDIR /neovim 
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo && \
    make install 

WORKDIR /
RUN rm -rf /neovim && \
    mkdir /usr/local/nvm 

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 21.6.1 

RUN apt-get install -y curl && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \ 
    && npm install -g pyright \
    && pip install autopep8 \
    && mkdir -p /root/.config

RUN git clone https://github.com/catchorg/Catch2.git && \
    cd Catch2 && \
    cmake -B build -S . -DBUILD_TESTING=OFF && \
    cmake --build build/ --target install 
  
ENV XDG_CONFIG_HOME="/root/.config"
ENV NVIM_APPNAME="dev_config/nvim"


