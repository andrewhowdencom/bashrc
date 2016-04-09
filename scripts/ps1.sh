# Defaults
PS1_ENABLED=${PS1_ENABLED:-FALSE}
PS1_STATUS=${PS1_STATUS:-FALSE}
PS1_STATUS_GIT_BRANCH=${PS1_STATUS_GIT_BRANCH:-FALSE}
PS1_STATUS_KUBE_CONTEXT=${PS1_STATUS_KUBE_CONTEXT:-FALSE}
PS1_INCLUDE_EXIT_CODE=${PS1_EXIT_CODE_VIEW:-FALSE}

PS1_INCLUDE_TIME=${PS1_INCLUDE_TIME:-TRUE}

STATUS_GIT_BRANCH=""
STATUS_KUBECTL_CONTEXT=""
EXIT_CODE=""

# Determine Environment Type
case $ENVIRONMENT_TYPE in
    production)
        TERMINAL_COLOR=$Terminal_Production
        ;;
    user)
        TERMINAL_COLOR=$Terminal_User
        ;;
    staging)
        TERMINAL_COLOR=$Terminal_Staging
        ;;
    development)
        TERMINAL_COLOR=$Terminal_Development
        ;;
    disposable)
        TERMINAL_COLOR=$Terminal_Disposable
        ;;
    *)
        TERMINAL_COLOR=$Terminal_Default
        ;;
esac

# Sets the PS1 configuration setting
function set_ps1 {
    # Check if PS1 customisation is enabled.
    if [[ $PS1_ENABLED != TRUE ]]; then return; fi;
    PS1=""
    SUMMARY=""
    PROMPT=""

    # STATUS
    function set_git_branch {

        # Check if we're including the git branch in the status
        if [[ $PS1_STATUS_GIT_BRANCH != TRUE ]]; then
            return;
        fi;

        local BRANCH=$(git symbolic-ref HEAD 2> /dev/null);

        if [[ $? -eq 0 && -n "$BRANCH" ]]; then
          SUMMARY="${SUMMARY}b: ${BRANCH#refs/heads/}"
        fi
    }

    # PROMPT
    function set_time {
        # Check if we're including time in the prompt
        if [[ $PS1_INCLUDE_TIME != TRUE ]]; then
          return;
        fi;


    }

    function prompt_suffix {
        PROMPT="${PROMPT}$ "
    }

    # Invoke customisation methods
    # Status line
    set_git_branch;

    # Prompt line
    set_time;
    prompt_suffix;

    if [[ -n "${SUMMARY}" ]]; then
        PS1="${PS1}${SUMMARY}\n"
    fi

    if [[ -n "${PROMPT}" ]]; then
      PS1="${PS1}${PROMPT}"
    fi
}

LINE_SUMMARY="$Green\[\$(GIT_BRANCH)\]$Color_Off"
LINE_PROMPT="\[$Green\]● \[$TERMINAL_COLOR\]\A \u@\h \[$Color_Off\]\w\[$TERMINAL_COLOR\]:\[$Color_Off\]\$(if [[ \$? == 0 ]]; then echo \"\[$Terminal_OK\]\"; else echo \"\[$Terminal_Error\] (\$?)\"; fi) $ \[$Color_Off\]"
BASH_PROMPT=""


PROMPT_COMMAND=set_ps1
