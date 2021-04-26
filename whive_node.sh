#!/bin/sh

set -e

command="$1"

quickstart () {

    echo "Installing whive from scratch..."
    
    clean

    whive_get

    whive_dependencies

    whive_build

    whive_config

    whive_run

    sleep 7200

    whive_address

    cpuminer_get

    cpuminer_dependencies

    cpuminer_build

    cpuminer_run_local
}

start () {
    
    echo "Starting whived and minerd..."
    whive_run
    sleep 600
    whive_address
    cpuminer_run_local

}

stop () {

    echo "Stopping whived and minerd..."
    
    # stop whived from running
    pkill -9 whived || true
    
    # stop cpuminer from running
    pkill -9 minerd || true
}

balance () {

    echo "Fetching wallet balance..."
    curl --user whive --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getbalance", "params": ["*", 6] }' -H 'content-type: text/plain;' http://127.0.0.1:1867/

}

# Get the whive repository
whive_get () {
    
    echo "Cloning the whive repository..."
    cd ~
    git clone https://github.com/whiveio/whive.git

}

# Install whive dependencies 
whive_dependencies () {

    echo "Installing the whive dependencies..."
    sudo apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils python3
    sudo apt-get install -y libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev
    cd ~
    curl 'https://raw.githubusercontent.com/bitcoin/bitcoin/master/contrib/install_db4.sh' > install_db4.sh
    chmod +x ./install_db4.sh
    sleep 15
    ./install_db4.sh `pwd`
    export BDB_PREFIX=`pwd`
}

# Build whive
whive_build () {
    
    echo "Building whive..."
    cd ~
    cd whive
    ./autogen.sh
    ./configure BDB_LIBS="-L${BDB_PREFIX}/db4/lib -ldb_cxx-4.8" BDB_CFLAGS="-I${BDB_PREFIX}/db4/include" 
    make

}

# Set up the whive configuration
whive_config () {
    
    echo "Setting up whive configurations..."
    cd ~
    if [ ! -d ~/.whive ]; then
        mkdir .whive
        cd .whive
        echo "server=1" >> whive.conf
        echo "daemon=1" >> whive.conf
        echo "listen=1" >> whive.conf
        echo "txindex=1" >> whive.conf
        echo "rpcuser=whive" >> whive.conf
        echo "rpcpassword=pass" >> whive.conf
    fi

}

# Run whive
whive_run () {
    
    echo "Running whive..."
    cd /home/pi
    cd whive/src
    ./whived -daemon

}

# Obtain a whive address and store it in a file
whive_address () {

    echo "Generating a whive address..."
    cd /home/pi
    cd whive/src
    ./whive-cli getnewaddress > ~/.whive/whive.address

}

# Get the cpuminer
cpuminer_get () {
    
    echo "Getting the cpuminer..."
    cd ~
    git clone https://github.com/whiveio/cpuminer-mc-yespower.git

}

# Install cpuminer dependencies
cpuminer_dependencies () {

    echo "Getting cpuminer dependencies..."
    sudo apt-get install -y build-essential libcurl4-openssl-dev 

}


# Build the cpuminer
cpuminer_build () {

    echo "Building the cpuminer..."
    cd ~
    cd cpuminer-mc-yespower

    # Specific for raspberry pi
    ./build-ARMv7l.sh 

}

# Run a local cpuminer node
cpuminer_run_local () {

    echo "Running the cpuminer node..."
    cd /home/pi
    cd cpuminer-mc-yespower
    export WHIVE_ADDR=$(cat ~/.whive/whive.address)
    ./minerd -a yespower -o http://127.0.0.1:1867 -u whive -p pass --no-longpoll --no-getwork --no-stratum  --coinbase-addr=$WHIVE_ADDR -t 3 &

}

# Run a cpuminer node that joins a node
cpuminer_run_pool () {

    echo "Running cpuminer that joins a pool..."
    cd ~
    cd cpuminer-mc-yespower
    ./minerd -a yespower -o stratum+tcp://34.73.100.13:3333 -u generateaddress.w1 -t 3

}

# Remove everything
clean () {

    echo "Removing unnecessary directories, stopping processes..."

    if [ -d ~/whive ]; then
        rm -Rf ~/whive
    fi

    if [ -d ~/cpuminer-mc-yespower ]; then
        rm -Rf ~/cpuminer-mc-yespower
    fi

    if [ -d ~/.install_db4.sh ]; then
        rm -Rf ~/.install_db4.sh
    fi

    if [ -d ~/.db4 ]; then
        rm -Rf ~/.db4
    fi

    if [ -d ~/.db-4.8.30.NC.tar.gz ]; then
        rm -Rf ~/.db-4.8.30.NC.tar.gz
    fi

    stop
}


# Show help
help () {
  echo "usage: private-ipfs.sh [quickstart|start|stop|balance]"
}


# Start, stop, remove
case "${command}" in
        "help")
    help
    ;;
        "quickstart")
    quickstart
    ;;
        "start")
    start
    ;;
        "balance")
    balance
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



