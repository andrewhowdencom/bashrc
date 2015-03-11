# Determine Environment Type
case $ENVIRONMENT_TYPE in 
    production) 
        Terminal_Color=$Terminal_Production
        ;;
    user)
        Terminal_Color=$Terminal_User
        ;;
    staging) 
        Terminal_Color=$Terminal_Staging
        ;;
    development) 
        Terminal_Color=$Terminal_Development
        ;;
    *)
        Terminal_Color=$Terminal_Default
        ;;
esac

PS1="\[$Terminal_Color\]\A \u@\h \[$Color_Off\]\w\[$Terminal_Color\]:\[$Color_Off\]\$(if [[ \$? == 0 ]]; then echo \"$Terminal_OK\"; else echo \"$Terminal_Error (\$?)\"; fi) $ \[$Color_Off\]"


