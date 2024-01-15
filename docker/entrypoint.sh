#!/bin/sh
set -e

USER=${unoserver:-"unouser"}

CMD="su-exec $USER tini -- /usr/bin/python3 -m unoserver.server"
DEFAULT_OPTIONS=""

#if [ "$(id -u)" = '0' ]; then
#    chown -R $USER . || exit 1
#fi

# this if will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; etc will work, but not arg1 arg2
if [ "$#" -eq 0 ] || [ "${1#-}" != "$1" ]; then
    set -- "$CMD" "$@"
fi

# check for the expected command
if [ "$1" = 'unoserver' ]; then
    shift
    exec su-exec $USER tini -- /usr/bin/python3 -m unoserver.server --interface 0.0.0.0
fi

# else default to run whatever the user wanted like "bash" or "sh"
exec "$@"
