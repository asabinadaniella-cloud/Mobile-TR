#!/bin/sh
if [ -z "$husky_skip_init" ]; then
  debug () {
    [ "$HUSKY_DEBUG" = "1" ] && echo "husky (debug) - $1"
  }

  readonly husky_skip_init=1
  export husky_skip_init

  debug "Reading .huskyrc"
  if [ -f ~/.huskyrc ]; then
    . ~/.huskyrc
  fi

  export PATH="$(dirname "$0")/../../node_modules/.bin:$PATH"
fi
