# cawaii_prompt.sh
CAWAII_PROMPT_DIR_COLOR='\033[0;33m'
CAWAII_PROMPT_BRANCH_COLOR='\033[0;35m'
CAWAII_PROMPT_STATUS_OK_COLOR='\033[0;32m'
CAWAII_PROMPT_STATUS_WARN_COLOR='\033[1;33m'
CAWAII_PROMPT_STATUS_NG_COLOR='\033[0;31m'
CAWAII_PROMPT_STATUS_BUG_COLOR='\033[1;36m'
CAWAII_PROMPT_TURN_OFF_COLOR='\033[0m'

CAWAII_PROMPT_STATUS_OK="${CAWAII_PROMPT_STATUS_OK_COLOR}(≧∇≦)b OK${CAWAII_PROMPT_TURN_OFF_COLOR}"
CAWAII_PROMPT_STATUS_WARN="${CAWAII_PROMPT_STATUS_WARN_COLOR}（;´▽｀A${CAWAII_PROMPT_TURN_OFF_COLOR}"
CAWAII_PROMPT_STATUS_NG="${CAWAII_PROMPT_STATUS_NG_COLOR}く(\"\"0\"\")＞なんてこった!!${CAWAII_PROMPT_TURN_OFF_COLOR}"
CAWAII_PROMPT_STATUS_BUG="${CAWAII_PROMPT_STATUS_BUG_COLOR}m(_ _)m promptのバグです${CAWAII_PROMPT_TURN_OFF_COLOR}"

function cawaii_prompt_preprocess () {
  local last_command_status=$?
  if [ -z $(git rev-parse --git-dir 2> /dev/null) ]; then
    if [ -n "$CAWAII_PROMPT_OLD_PS1" ]; then
      export PS1=$CAWAII_PROMPT_OLD_PS1
    fi
  else
    if [ -z "$CAWAII_PROMPT_OLD_PS1" ]; then
      export CAWAII_PROMPT_OLD_PS1=$PS1
    fi
    export PS1="$(last_command_status_string $last_command_status)${CAWAII_PROMPT_DIR_COLOR}\w${CAWAII_PROMPT_TURN_OFF_COLOR}[${CAWAII_PROMPT_BRANCH_COLOR}$(git rev-parse --abbrev-ref HEAD)${CAWAII_PROMPT_TURN_OFF_COLOR}$(git_status_string)]\n\D{%H:%M} $ "
  fi
}

function last_command_status_string () {
  local status=$1
  local status_string="$status"
  if [ $status = 0 ]; then
    status_string=""
  else
    status_string=$CAWAII_PROMPT_STATUS_NG
  fi
  echo $status_string
}

function git_status_string () {
  local statuses=$(git status -s 2> /dev/null | sed 's/^ *//' | cut -d ' ' -f 1 | sort | uniq)
  if [ -z "$statuses" ]; then echo $CAWAII_PROMPT_STATUS_OK; return; fi
  if [ -z "${statuses/*U*/}" ]; then echo $CAWAII_PROMPT_STATUS_NG; return; fi
  if [ -z "${statuses/*[MA?]*/}" ]; then echo $CAWAII_PROMPT_STATUS_WARN; return; fi
  echo $CAWAII_PROMPT_STATUS_BUG
}

PROMPT_COMMAND="cawaii_prompt_preprocess"
