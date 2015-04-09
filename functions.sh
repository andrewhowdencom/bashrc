# Add the vendor/bin to the terminal path. 
function add-path-composer {
    # Test if a vendor path exists 
    # That causes problems with multiple autoloads. Doesn't work at the 
    # moment as there is a vendor in the ~/.composer/vendor/bin path
    # if [[ $PATH == *"vendor"* ]]; then 
    #    echo "Vendor already in path";
    #    return 1;
    # fi

    # Add the vendor path
    VENDOR_PATH="$(pwd)/vendor/bin"
    if [[ -e "$VENDOR_PATH" ]]; then
        export PATH=$PATH:$VENDOR_PATH
        echo "Added $VENDOR_PATH to \$PATH"
    else
        echo "Cannot find vendor path"
        return 1
    fi
}

# Function to test whether a PHP file will run successfully via cron as
# a given user
function php-cron {
   if [[ -z $1 ]]; then 
     echo "Usage: $0 {user} {path}"
     return 1 
   fi

   if [[ -z $2 ]]; then 
     echo "Usage: $0 {user} {path}"
     return 1
   fi
   
   sudo su $1 -c "/usr/bin/php -f $2"
}

# Web Services
function status-code {
    curl -s -o /dev/null -I -w "%{http_code}" "$1"
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

    # Make Request
    Pushover_Request=$(curl -s \
        --form-string "token=$ENVIRONMENT_PUSHOVER_APP" \
        --form-string "user=$ENVIRONMENT_PUSHOVER_USER" \
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
