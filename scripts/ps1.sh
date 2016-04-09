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
        ANSI_TERMINAL_COLOR=$ANSI_TERMINAL_PRODUCTION
        ;;
    user)
        ANSI_TERMINAL_COLOR=$Terminal_User
        ;;
    staging)
        ANSI_TERMINAL_COLOR=$Terminal_Staging
        ;;
    development)
        ANSI_TERMINAL_COLOR=$Terminal_Development
        ;;
    disposable)
        ANSI_TERMINAL_COLOR=$Terminal_Disposable
        ;;
    *)
        ANSI_TERMINAL_COLOR=$Terminal_Default
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

LINE_SUMMARY="$ANSI_TERMINAL_GREEN\[\$(GIT_BRANCH)\]$ANSI_COLOR_OFF"
LINE_PROMPT="\[$ANSI_TERMINAL_GREEN\]● \[$ANSI_TERMINAL_COLOR\]\A \u@\h \[$ANSI_COLOR_OFF\]\w\[$ANSI_TERMINAL_COLOR\]:\[$ANSI_COLOR_OFF\]\$(if [[ \$? == 0 ]]; then echo \"\[$ANSI_TERMINAL_OK\]\"; else echo \"\[$ANSI_TERMINAL_ERROR\] (\$?)\"; fi) $ \[$ANSI_COLOR_OFF\]"
BASH_PROMPT=""


PROMPT_COMMAND=set_ps1
