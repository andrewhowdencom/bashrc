# Run a mysql query against the local host
function mysql-query {
    ERR_MSG="There is no \$%s environment variable set. Set one to continue"
    for env in "MYSQL_SERVER" "MYSQL_USER" "MYSQL_PASSWORD" "MYSQL_DATABASE"
    do 
      if [[ -z ${!env} ]]; then 
          echo $(printf "$ERR_MSG" "$env"); 
          return 1
      fi
   done

   mysql --host="$MYSQL_SERVER" --user="$MYSQL_USER" --password="$MYSQL_PASSWORD" --database="$MYSQL_DATABASE" -e "$1"
}

# Send notification to pushover
function push-msg {
    # Set the default
    Ex_Status=0
    Result="Successfully"
    Pushover_Url="https://api.pushover.net/1/messages.json"

    # Check to see if theres an app code
    if [[ -z $ENVIRONMENT_PUSHOVER_APP ]]; then
        echo "There is no \$ENVIRONMENT_PUSHOVER_APP environment variable available"
        return 1
    fi

    # Check if theres a user code
    if [[ -z $ENVIRONMENT_PUSHOVER_USER ]]; then
        echo "There is no \$ENVIRONMENT_PUSHOVER_USER environment variable available"
    fi

    if [[ -z $ENVIRONMENT_PUSHOVER_SOUND ]]; then 
        ENVIRONMENT_PUSHOVER_SOUND="cashregister"
    fi;

    # Make Request
    Pushover_Request=$(curl -s \
        --form-string "token=$ENVIRONMENT_PUSHOVER_APP" \
        --form-string "user=$ENVIRONMENT_PUSHOVER_USER" \
        --form-string "sound=$ENVIRONMENT_PUSHOVER_SOUND" \
        --form-string "message=$1" \
        $Pushover_Url \
        -o /dev/null -w "%{http_code}")

    # Determine if it was a failure
    if [[ "$Pushover_Request" != 200 ]]; then
        Result="Error ($Pushover_Request): Failed to"
        Ex_Status=1
    fi
    
    # Provide some feedback
    echo "$Result dispatched \"$1\" to Pushover"
    return $Ex_Status
}

# Name the terminal window
# http://askubuntu.com/questions/22413/how-to-change-gnome-terminal-title
function name_terminal {
    echo -ne "\033]0;$1\007"
}

# Copy things to the clipboard
function xcopy {
    if [ $(which xclip > /dev/null) ]; then
        echo "You'll need to install xclip";
        return;
    fi;

    xclip -selection clipboard
}

