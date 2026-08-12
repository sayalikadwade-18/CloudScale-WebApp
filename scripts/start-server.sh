#!/bin/bash
# Starts the Tic Tac Toe web app on port 80
cd "$(dirname "$0")/../app" || exit
sudo python3 -m http.server 80
