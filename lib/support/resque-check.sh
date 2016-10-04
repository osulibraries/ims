#!/bin/bash

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
PROJECT_ROOT=$(readlink -f "$SCRIPTPATH/../..")

RAILS_ROOT="${RAILS_ROOT:-$PROJECT_ROOT}"
RAILS_ENV="${RAILS_ENV:-development}"


if ! ps -ef|grep resque-pool-master|grep -vq grep; then
  if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    source "$HOME/.rvm/scripts/rvm"
  elif [[ -s "/usr/local/rvm/scripts/rvm" ]]; then
    source "/usr/local/rvm/scripts/rvm"
  fi

  cd "$RAILS_ROOT"
  echo "$(date -u) Resque pool master process not found. Starting..."
  "$RAILS_ROOT/bin/bundle" exec resque-pool --daemon --environment $RAILS_ENV
fi
