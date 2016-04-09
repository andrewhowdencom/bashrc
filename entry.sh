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
INCLUDES=$DIR/scripts

source "$INCLUDES/environment.sh"
source "$INCLUDES/settings.sh"
source "$INCLUDES/functions.sh"
source "$INCLUDES/path.sh"
source "$INCLUDES/colors.sh"
source "$INCLUDES/alias.sh"
source "$INCLUDES/ps1.sh"
source "$INCLUDES/status.sh"
