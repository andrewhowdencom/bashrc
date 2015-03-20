# Include Files

# Determine current executing folder. 
# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do 
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source "$DIR/environment.sh"
source "$DIR/functions.sh"
source "$DIR/path.sh"
source "$DIR/colors.sh"
source "$DIR/alias.sh"
source "$DIR/ps1.sh"
source "$DIR/status.sh"
