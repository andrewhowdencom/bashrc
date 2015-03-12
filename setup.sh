#!/usr/bin/env bash

# Determine path the script is executed in 
# From http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in 
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do 
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

echo "source \"$DIR/include.sh\"" >> "$HOME/.bashrc"
echo "source \"$DIR/include.sh\"" >> "$HOME/.bash_profile"

source "$HOME/.bashrc"

echo "Installed bashrc!"
