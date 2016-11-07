# Defaults
PS1_ENABLED=${PS1_ENABLED:-FALSE}
PS1_STATUS=${PS1_STATUS:-FALSE}
PS1_STATUS_GIT_BRANCH=${PS1_STATUS_GIT_BRANCH:-FALSE}
PS1_STATUS_KUBE_CONTEXT=${PS1_STATUS_KUBE_CONTEXT:-FALSE}
PS1_STATUS_EXIT_CODE=${PS1_STATUS_EXIT_CODE:-FALSE}

PS1_INCLUDE_EXIT_CODE=${PS1_INCLUDE_EXIT_CODE:-TRUE}
PS1_INCLUDE_HOST=${PS1_INCLUDE_HOST:-FALSE}
PS1_INCLUDE_TIME=${PS1_INCLUDE_TIME:-TRUE}
PS1_INCLUDE_PATH=${PS1_INCLUDE_PATH:-TRUE}

ANSI_STATUS_COLOR=${ANSI_COLOR_WHITE}

# Determine Environment Type
case $ENVIRONMENT_TYPE in
    production)
        ANSI_TERMINAL_COLOR=$ANSI_TERMINAL_PRODUCTION
        ;;
    user)
        ANSI_TERMINAL_COLOR=$ANSI_TERMINAL_USER
        ;;
    staging)
        ANSI_TERMINAL_COLOR=$ANSI_TERMINAL_STAGING
        ;;
    development)
        ANSI_TERMINAL_COLOR=$ANSI_TERMINAL_DEVELOPMENT
        ;;
    disposable)
        ANSI_TERMINAL_COLOR=$ANSI_TERMINAL_DISPOSABLE
        ;;
    *)
        ANSI_TERMINAL_COLOR=$ANSI_TERMINAL_DEFAULT
        ;;
esac

# Sets the PS1 configuration setting
function set_ps1 {
    # The exit code variable declaration must be first to catch the previous
    # commands exit code.
    EXIT_CODE=$?

    # Check if PS1 customisation is enabled.
    if [[ $PS1_ENABLED != TRUE ]]; then return; fi;
    PS1=""
    SUMMARY=""
    PROMPT=""

    # STATUS
    function set_status_git_branch {

        # Check if we're including the git branch in the status
        if [[ $PS1_STATUS_GIT_BRANCH != TRUE ]]; then
            return;
        fi;

        local BRANCH=$(git symbolic-ref HEAD 2> /dev/null);

        if [[ $? -eq 0 && -n "$BRANCH" ]]; then
            SUMMARY="${SUMMARY}\[$ANSI_STATUS_COLOR\]branch:\[$ANSI_COLOR_OFF\] ${BRANCH#refs/heads/} "
        fi
    }

    function set_status_kube_context {
        if [[ $PS1_STATUS_KUBE_CONTEXT != TRUE ]]; then
            return;
        fi;

        if [[ $? -eq 0 && $(which kubectl) ]]; then
          local CONTEXT=$(kubectl config current-context);

          # Determine whether the cluster is a local, staging or prod cluster
          # Default is the prod cluster
          local COLOR=${ANSI_TERMINAL_PRODUCTION}

          # Check if it's a local environment
          echo "${CONTEXT}" | grep -E 'minikube|local-|lcl-' > /dev/null && COLOR=${ANSI_TERMINAL_DEVELOPMENT}

          # Check if it's a staging environment
          echo "${CONTEXT}" | grep -E 'staging-|stg-' > /dev/null && COLOR=${ANSI_TERMINAL_STAGING}

          SUMMARY="${SUMMARY}\[$ANSI_STATUS_COLOR\]k8s:\[${COLOR}\] ${CONTEXT}\[${ANSI_COLOR_OFF}\] "
        fi;
    }

    function set_status_exit_code {
        if [[ $PS1_STATUS_EXIT_CODE != TRUE ]]; then return; fi;

        if [[ ${EXIT_CODE} != 0 ]]; then
            SUMMARY="${SUMMARY}\[${ANSI_TERMINAL_ERROR}\]exit:\[${ANSI_COLOR_OFF}\]: ${EXIT_CODE}"
        fi;
    }

    function set_prompt_exit_status {
        if [[ $PS1_INCLUDE_EXIT_CODE != TRUE ]]; then return; fi;

        if [[ $EXIT_CODE != 0 ]]; then
            local ANSI_COLOR=$ANSI_TERMINAL_ERROR;
        else
            local ANSI_COLOR=$ANSI_TERMINAL_SUCCESS;
        fi;

        PROMPT="${PROMPT}\[$ANSI_COLOR\]●\[$ANSI_COLOR_OFF\]"
    }

    # PROMPT
    function set_prompt_time {
        # Check if we're including time in the prompt
        if [[ $PS1_INCLUDE_TIME != TRUE ]]; then return; fi;

        PROMPT="${PROMPT} \[$ANSI_TERMINAL_COLOR\]\A\[$ANSI_COLOR_OFF\]"
    }

    function set_prompt_host {
        if [[ $PS1_INCLUDE_HOST != TRUE ]]; then return; fi;

        PROMPT="${PROMPT} [\u] \[$ANSI_TERMINAL_COLOR\]\h\[$ANSI_COLOR_OFF\]"
    }

    function set_prompt_path {
        if [[ $PS1_INCLUDE_PATH != TRUE ]]; then return; fi;
        PROMPT="${PROMPT} \w"
    }

    function set_prompt_suffix {
        PROMPT="${PROMPT} $ "
    }

    # Exit code should be printed in status line when it's not 0.

    # Invoke customisation methods
    # Status line
    set_status_kube_context;
    set_status_git_branch;
    set_status_exit_code;

    # Prompt line
    set_prompt_exit_status;
    set_prompt_time;
    set_prompt_host;
    set_prompt_path;
    set_prompt_suffix;

    if [[ -n "${SUMMARY}" ]]; then
        PS1="${PS1}${SUMMARY}\n"
    fi

    if [[ -n "${PROMPT}" ]]; then
      PS1="${PS1}${PROMPT}"
    fi
}

#LINE_SUMMARY="$ANSI_TERMINAL_GREEN\[\$(GIT_BRANCH)\]$ANSI_COLOR_OFF"
#LINE_PROMPT="\[$ANSI_TERMINAL_GREEN\]● \[$ANSI_TERMINAL_COLOR\]\A \u@\h \[$ANSI_COLOR_OFF\]\w\[$ANSI_TERMINAL_COLOR\]:\[$ANSI_COLOR_OFF\]\$(if [[ \$? == 0 ]]; then echo \"\[$ANSI_TERMINAL_OK\]\"; else echo \"\[$ANSI_TERMINAL_ERROR\] (\$?)\"; fi) $ \[$ANSI_COLOR_OFF\]"
#BASH_PROMPT=""


PROMPT_COMMAND=set_ps1
