#!/bin/bash
#
# Code from https://github.com/docker-library/healthcheck/blob/master/mysql/docker-healthcheck
# Modified here and there :)
#

# Very important - this line ensures the program exits if any of the commands return non 0 status
set -eo pipefail

if [ "$MYSQL_RANDOM_ROOT_PASSWORD" ] && [ -z "$MYSQL_USER" ] && [ -z "$MYSQL_PASSWORD" ]; then
	# there's no way we can guess what the random MySQL password was
	echo >&2 'healthcheck error: cannot determine random root password (and MYSQL_USER and MYSQL_PASSWORD were not set)'
	exit 0
fi

# No need for IP address and `hostname` is not native to this container
host="localhost" 
user="${MYSQL_USER:-root}"
export MYSQL_PWD="${MYSQL_PASSWORD:-$MYSQL_ROOT_PASSWORD}"

args=(
	# force mysql to not use the local "mysqld.sock" (test "external" connectibility)
	-h"$host"
	-u"$user"
	--silent
)

if command -v mysqladmin &> /dev/null; then
	if mysqladmin "${args[@]}" ping > /dev/null; then
		exit 0
	fi
else
	if select="$(echo 'SELECT 1' | mysql "${args[@]}")" && [ "$select" = '1' ]; then
		exit 0
	fi
fi

exit 1