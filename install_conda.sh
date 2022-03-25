#!/usr/bin/env bash

_ostype=$(uname -s)
_kernelarch=$(uname -m)

function is_installed() {
    command -v $1 &>/dev/null
    if [[ "$?" == "0" ]]; then
        return 0
    fi
    return 1
}

if [[ $_ostype == 'Linux' ]]; then
    is_installed curl
    if [[ "$?" == "1" ]]; then
        is_installed wget
        if [[ "$?" == "1" ]]; then
            printf "\e[1;31mYou need to install curl or wget\n\e[0m"
            exit $_wget
        fi
    fi
    _sha256verification='745c99af2cb0d0e0f43c7ed1a3417ff4d5118eafb501518120ea30361f1bb8f6'
    is_installed curl
    if [[ "$?" == "0" ]]; then
        curl https://repo.anaconda.com/miniconda/Miniconda3-py37_4.11.0-Linux-x86_64.sh --output Miniconda3-py37_4.11.0-Linux-x86_64.sh --silent
    fi
    is_installed wget
    if [[ "$?" == "0" ]]; then
        wget -O Miniconda3-py37_4.11.0-Linux-x86_64.sh https://repo.anaconda.com/miniconda/Miniconda3-py37_4.11.0-Linux-x86_64.sh &>/dev/null
    fi
    is_installed sha256sum
    _shasum=$(is_installed shasum)
    _verifyFile=""
    if [[ "$?" == "0" ]]; then
        _verifyFile=$(sha256sum Miniconda3-py37_4.11.0-Linux-x86_64.sh | cut -d' ' -f1)
    else
        is_installed shasum
        if [[ "$?" == "0" ]]; then
            _verifyFile=$(shasum -a 256 Miniconda3-py37_4.11.0-Linux-x86_64.sh | cut -d' ' -f1)
        else
           printf "\e[1;32mYou need to install sha256sum or shasum to check if the file is not corrupted\n\e[0m"
        fi
    fi
    if [[ "$_verifyFile" != "$_sha256verification" ]]; then
        printf "\e[1;31mverification failed\n\e[0m";
        exit 1
    fi
    # Interactive mode
    /usr/bin/bash Miniconda3-py37_4.11.0-Linux-x86_64.sh
    _shell=$(echo $SHELL | cut -d'/' -f3)
    if [[ $_shell == 'zsh' ]]; then
        . ~/.zshrc
    elif [[ $_shell == 'bash' ]]; then
        . ~/.bashrc
    fi
    # conda create --name $USER
    # conda activate $USER
fi

printf "\e[1;32mPlease Run this commands (CHANGE \$USER BY YOUR NICKNAME):\n\e[0m"
printf "\e[1;32m 1. conda init $SHELL\n\e[0m"
printf "\e[1;32m 2. conda create --name \$USER\n\e[0m"
printf "\e[1;32m 3. conda activate \$USER\n\e[0m"
printf "\e[1;32m 4. echo \"y\" | conda install requests\n\e[0m"