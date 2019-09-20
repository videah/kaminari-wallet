#!/usr/bin/env bash

# The reference to the git commit used to generate from proto files.
# Set this to the version of LND you are using.
export REF="0e28ecd6164e77e86f38bc3ea692a4a60896acdf"

YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Pulling lnd files with reference $REF...$NC"
git clone https://github.com/lightningnetwork/lnd
git checkout ${REF}

echo -e "${YELLOW}Pulling API files needed to generate... $NC"
git clone https://github.com/grpc-ecosystem/grpc-gateway

echo -e "${YELLOW}Attempting to generate source files...$NC"
mkdir -p ./lib/generated
protoc -I/usr/local/include -I. \
       -I./grpc-gateway/third_party/googleapis \
       --dart_out=grpc:lib/generated \
        ./lnd/lnrpc/rpc.proto

echo -e "${YELLOW}Cleaning up...$NC"
rm -rf lnd
rm -rf grpc-gateway

if [[ -f ./lib/generated/lnd/lnrpc/rpc.pbgrpc.dart ]]; then
    echo -e "${GREEN}Successfully generated gRPC files needed to compile.$NC"
else
    echo -e "${RED}There was an issue generating the gRPC files.$NC"
fi
