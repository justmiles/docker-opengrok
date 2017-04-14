#!/bin/ash

mkdir -p $OPENGROK_INSTANCE_BASE/data
mkdir -p $OPENGROK_INSTANCE_BASE/plugins
mkdir -p $OPENGROK_INSTANCE_BASE/etc

# Do the initial index
sleep 10 && $OPENGROK_INSTANCE_BASE/bin/OpenGrok index $SRC_ROOT &

for directory in $(find $SRC_ROOT -type d -maxdepth $REINDEX_MAX_DEPTH | grep -v $REINDEX_FILTER); do
  echo "incrond: watching $directory"
  echo "$directory IN_CLOSE_WRITE,IN_MODIFY,IN_MOVED_TO $OPENGROK_INSTANCE_BASE/bin/OpenGrok index $SRC_ROOT" >> /etc/incron.d/opengrok
done

# start incron daemon
incrond -n &

/bin/ash -c "$@"
