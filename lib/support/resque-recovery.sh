#!/bin/bash

# From: https://gist.github.com/vitobotta/2783513
# Also see: http://vitobotta.com/resque-automatically-kill-stuck-workers-retry-failed-jobs/

max_seconds=600

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
PROJECT_ROOT=$(readlink -f "$SCRIPTPATH/../..")

RAILS_ROOT="${RAILS_ROOT:-$PROJECT_ROOT}"
RAILS_ENV="${RAILS_ENV:-development}"

retry_failed_jobs=false


while read PID COMMAND
do
  if [[ $PID ]] && [[ -d /proc/$PID ]]; then
    SECONDS=`expr $(awk -F. '{print $1}' /proc/uptime) - $(expr $(awk '{print $22}' /proc/${PID}/stat) / 100)`

    if [ $SECONDS -gt $max_seconds ]; then
      kill -9 $PID
      retry_failed_jobs=true
      QUEUE=`echo "$COMMAND" | cut -d ' ' -f 3`
      echo $(date -u) "The forked child with pid #$PID (queue: $QUEUE) was found stuck for longer than $max_seconds seconds."
    fi
  fi
done <<< "$(ps -eo pid,command | grep [r]esque | grep "Processing")"


if [ "$retry_failed_jobs" = true ]; then
  if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
  elif [[ -s "/usr/local/rvm/scripts/rvm" ]]; then
    source "/usr/local/rvm/scripts/rvm"
  fi

  cd "$RAILS_ROOT"
  "$RAILS_ROOT/bin/bundle" exec rake resque:retry_killed
  echo "$(date -u) Worker processes were killed. Failed jobs have been re-queued."
fi
