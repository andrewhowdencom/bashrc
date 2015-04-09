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
    disposable) 
        Terminal_Color=$Terminal_Disposable
        ;; 
    *)
        Terminal_Color=$Terminal_Default
        ;;
esac

function set_ps1 {
  PS1=$BASH_PROMPT
}

function git_branch {
    GIT_BRANCH=$(git symbolic-ref HEAD 2> /dev/null)
    if [[ $? -eq 0 ]]; then
        echo "b: "${GIT_BRANCH#refs/heads/}
    fi
}

LINE_SUMMARY="$Green\[\$(git_branch)\]$Color_Off"
LINE_PROMPT="\[$Terminal_Color\]\A \u@\h \[$Color_Off\]\w\[$Terminal_Color\]:\[$Color_Off\]\$(if [[ \$? == 0 ]]; then echo \"\[$Terminal_OK\]\"; else echo \"\[$Terminal_Error\] (\$?)\"; fi) $ \[$Color_Off\]"
BASH_PROMPT=""

if [[ ! -z $LINE_SUMMARY ]]; then
    BASH_PROMPT="$BASH_PROMPT$LINE_SUMMARY\n";
fi

if [[ ! -z $LINE_PROMPT ]]; then
   BASH_PROMPT="$BASH_PROMPT$LINE_PROMPT"
fi

PROMPT_COMMAND=set_ps1

