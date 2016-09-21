# cawaii_prompt.sh
export CAWAII_PROMPT_DIR_COLOR='\033[0;33m'
export CAWAII_PROMPT_BRANCH_COLOR='\033[0;35m'
export CAWAII_PROMPT_STATUS_OK_COLOR='\033[0;32m'
export CAWAII_PROMPT_STATUS_WARN_COLOR='\033[1;33m'
export CAWAII_PROMPT_STATUS_NG_COLOR='\033[0;31m'
export CAWAII_PROMPT_STATUS_BUG_COLOR='\033[1;36m'
export CAWAII_PROMPT_TURN_OFF_COLOR='\033[0m'

export CAWAII_PROMPT_STATUS_OK="${CAWAII_PROMPT_STATUS_OK_COLOR}(≧∇≦)b OK${CAWAII_PROMPT_TURN_OFF_COLOR}"
export CAWAII_PROMPT_STATUS_WARN="${CAWAII_PROMPT_STATUS_WARN_COLOR}（;´▽｀A${CAWAII_PROMPT_TURN_OFF_COLOR}"
export CAWAII_PROMPT_STATUS_NG="${CAWAII_PROMPT_STATUS_NG_COLOR}く(\"\"0\"\")＞なんてこった!!${CAWAII_PROMPT_TURN_OFF_COLOR}"
export CAWAII_PROMPT_STATUS_BUG="${CAWAII_PROMPT_STATUS_BUG_COLOR}m(_ _)m promptのバグです${CAWAII_PROMPT_TURN_OFF_COLOR}"

function cawaii_prompt_preprocess () {
  if [ -z $(git rev-parse --git-dir 2> /dev/null) ]; then
    if [ -n "$CAWAII_PROMPT_OLD_PS1" ]; then
      export PS1=$CAWAII_PROMPT_OLD_PS1
    fi
  else
    if [ -z "$CAWAII_PROMPT_OLD_PS1" ]; then
      export CAWAII_PROMPT_OLD_PS1=$PS1
    fi
    export PS1="${CAWAII_PROMPT_DIR_COLOR}\w${CAWAII_PROMPT_TURN_OFF_COLOR}[${CAWAII_PROMPT_BRANCH_COLOR}$(git rev-parse --abbrev-ref HEAD)${CAWAII_PROMPT_TURN_OFF_COLOR}$(git_status_string)]\n\D{%H:%M} $ "
  fi
}

function git_status_string () {
  local statuses=$(git status -s 2> /dev/null | sed 's/^ *//' | cut -d ' ' -f 1 | sort | uniq)
  if [ -z "$statuses" ]; then echo $CAWAII_PROMPT_STATUS_OK; return; fi
  if [ -z "${statuses/*U*/}" ]; then echo $CAWAII_PROMPT_STATUS_NG; return; fi
  if [ -z "${statuses/*[MA?]*/}" ]; then echo $CAWAII_PROMPT_STATUS_WARN; return; fi
  echo $CAWAII_PROMPT_STATUS_BUG
}

export PROMPT_COMMAND="cawaii_prompt_preprocess"
