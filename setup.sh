#!/usr/bin/env bash

# From http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in 
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do 
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

echo "source \"$DIR/entry.sh\"" >> "$HOME/.bashrc"
echo "source \"$DIR/entry.sh\"" >> "$HOME/.bash_profile"

source "$HOME/.bashrc"

echo "Installed bashrc!"
