#!/bin/sh

command="$1"

quickstart () {

    whive_get

    whive_dependencies

    whive_dependencies_raspbian

    whive_build

    whive_config

    whive_run

    whive_address

    cpuminer_get

    cpuminer_dependencies

    cpuminer_build
    
    cpuminer_run_local
}

# Get the whive repository
whive_get () {
    
    cd ~
    sudo apt-get install git
    git clone https://github.com/whiveio/whive.git

}

# Install whive dependencies 
whive_dependencies () {

    sudo apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils python3
    sudo apt-get install -y libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev

}

# Install whive dependencies for ubuntu
whive_dependencies_ubuntu () {

    sudo apt-get install -y software-properties-common
    sudo add-apt-repository ppa:bitcoin/bitcoin
    sudo apt-get update
    sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

}

# Install whive dependencies for raspberry pi
whive_dependencies_raspbian () {

    sudo bash -c 'echo deb http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu cosmic main >> /etc/apt/sources.list'
    sudo bash -c 'echo deb-src http://ppa.launchpad.net/bitcoin/bitcoin/ubuntu cosmic main >> /etc/apt/sources.list'
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C70EF1F0305A1ADB9986DBD8D46F45428842CE5E
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository ppa:bitcoin/bitcoin
    sudo apt-get update
    sudo apt-get install -y libdb4.8-dev libdb4.8++-dev

}

# Build whive
whive_build () {
    
    cd ~
    cd whive
    ./autogen.sh
    ./configure
    make

}

# Set up the whive configuration
whive_config () {
    
    cd ~
    mkdir .whive
    cd .whive
    echo "server=1" >> whive.conf
    echo "daemon=1" >> whive.conf
    echo "listen=1" >> whive.conf
    echo "txindex=1" >> whive.conf
    echo "rpcuser=whive" >> whive.conf
    echo "rpcpassword=pass" >> whive.conf

}

# Run whive
whive_run () {
    
    cd ~
    cd whive/src
    whived -daemon

}

# Obtain a whive address and store it in a file
whive_address () {

    cd ~
    cd whive/src
    whive-cli getnewaddress > ~/.whive/whive.address

}

# Get the cpuminer
cpuminer_get () {
    
    cd ~
    git clone https://github.com/cryptozeny/cpuminer-mc-yespower.git

}

# Install cpuminer dependencies
cpuminer_dependencies () {

    sudo apt-get install -y build-essential libcurl4-openssl-dev 

}


# Build the cpuminer
cpuminer_build () {

    cd ~
    cd cpuminer-mc-yespower
    ./build.sh

}

# Run a local cpuminer node
cpuminer_run_local () {

    cd ~
    cd cpuminer-mc-yespower
    export WHIVE_ADDR=$(cat coordinator.seed)
    ./minerd -a yespower -o http://127.0.0.1:1867 -u whive -p pass --no-longpoll --no-getwork --no-stratum  --coinbase-addr=$WHIVE_ADDR -t 3

}

# Run a cpuminer node that joins a node
cpuminer_run_pool () {
    cd ~
    cd cpuminer-mc-yespower
    ./minerd -a yespower -o stratum+tcp://34.73.100.13:3333 -u generateaddress.w1 -t 3

}

# Remove everything
clean () {
    cd ~
    sudo rm -rf .whive

    # stop whived from running
    # stop cpuminer from running
}


# Show help
help () {
  echo "usage: private-ipfs.sh [quickstart|stop]"
}


# Start, stop, remove
case "${command}" in
        "help")
    help
    ;;
        "quickstart")
    quickstart
    ;;
         "stop")
    stop
    ;;
  *)
    echo "Command not Found."
    help
    exit 127;
    ;;
esac



