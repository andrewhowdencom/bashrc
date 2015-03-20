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
