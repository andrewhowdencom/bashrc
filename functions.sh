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


