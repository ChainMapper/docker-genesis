#!/bin/bash

configfile=$1
ticker=$2
walletdaemon=$3

datadir=/data/wallet
configdir="/config"
walletfile="wallet.dat"
echo "Docker $ticker wallet

By: ChainMapper
Website: https://chainmapper.com"

mkdir -p $datadir

wallet="$configdir/$walletfile"
if [ -f "$wallet" ]
then
    echo "Using $wallet"
    cp $wallet $datadir/$walletfile
fi

config="$configdir/$configfile"
if [ -f "$config" ]
then
    echo "Using $config"
    cp $config $datadir/$configfile
else
    touch $datadir/$configfile
    /gen_config.sh > $datadir/$configfile
fi

echo "Starting $ticker daemon..."
$walletdaemon -datadir=$datadir