#!/bin/bash

# Install SSH first as a backdoor in case something breaks
./install/ssh.sh

./install/stow.sh
./install/keyd.sh
./install/firefox.sh
./install/omarchy-packages.sh
