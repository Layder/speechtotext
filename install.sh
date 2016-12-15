#!/bin/sh

grep backports /etc/apt/sources.list > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
    apt-get update
fi

apt-get install -y unzip curl
apt-get install -y -t jessie-backports golang

basedir=`dirname "$0"`
basedir=`cd "$basedir" && pwd`

export GOPATH="$basedir"
go get google.golang.org/grpc

rm -rf "$basedir/protoc"
mkdir -p "$basedir/protoc"
cd "$basedir/protoc"
wget https://github.com/google/protobuf/releases/download/v3.1.0/protoc-3.1.0-linux-x86_64.zip
unzip protoc-3.1.0-linux-x86_64.zip
rm protoc-3.1.0-linux-x86_64.zip
cd ..
chmod -R a+rX "$basedir/protoc"

export PATH="$PATH:$basedir/protoc/bin"
go get -u github.com/golang/protobuf/proto
go get -u github.com/golang/protobuf/protoc-gen-go
go get -u cloud.google.com/go/speech/apiv1beta1
go get -u golang.org/x/time/rate

export PATH="$PATH:$basedir/bin"
go build "$basedir/speechtotext.go"
