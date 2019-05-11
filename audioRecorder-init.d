#! /bin/sh
#
# init script for simple audio recorder

### BEGIN INIT INFO
# Provides:          audioRecorder
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Reccord audio from android camera
### END INIT INFO

# Author: Wilson Waters (from ddclient script)

PATH=/sbin:/bin:/usr/sbin:/usr/bin
NAME="audioRecorder"
DAEMON="/usr/local/bin/$NAME"
DESC="Audio Recorder"

# Don't run if not installed
test -f $DAEMON || exit 0

# Evaluate the config for the Debian scripts
run_daemon=false
daemon_interval=300

PIDFILE=/var/run/$NAME.pid
OPTIONS=""

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
. /lib/lsb/init-functions

#
# Function that starts the daemon/service
#
do_start()
{
        rm $PIDFILE
        # Return
        #   0 if daemon has been started
        #   1 if daemon was already running
        #   2 if daemon could not be started
        start-stop-daemon --test --start --background --make-pidfile --quiet \
                --pidfile $PIDFILE --name $NAME --startas $DAEMON \
                >/dev/null \
                || return 1

        start-stop-daemon --start --background --make-pidfile --quiet \
                --pidfile $PIDFILE --name $NAME --startas $DAEMON \
                -- $OPTIONS \
                || return 2
}

#
# Function that stops the daemon/service
#
do_stop()
{
        # Return
        #   0 if daemon has been stopped
        #   1 if daemon was already stopped
        #   2 if daemon could not be stopped
        #   other if a failure occurred
        start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 \
                --pidfile $PIDFILE --name $NAME
        sudo pkill -9 -F $PIDFILE
        rm $PIDFILE
        return "$?"
}


case "$1" in
  start)
        [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
        do_start
        case "$?" in
                0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
                2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
        esac
        ;;
  stop)
        [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
        do_stop
        case "$?" in
                0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
                2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
        esac
        ;;

  status)
        echo -n "Status of $DESC: "
        if [ ! -r "$PIDFILE" ]; then
                echo "$NAME is not running."
                exit 3
        fi
        if read pid < "$PIDFILE" && ps -p "$pid" > /dev/null 2>&1; then
                echo "$NAME is running."
                exit 0
        else
                echo "$NAME is not running but $PIDFILE exists."
                exit 1
        fi
        ;;


  restart|force-reload)
        log_daemon_msg "Restarting $DESC" "$NAME"
        do_stop
        case "$?" in
          0|1)
                do_start
                case "$?" in
                        0) log_end_msg 0 ;;
                        1) log_end_msg 1 ;; # Old process is still running
                        *) log_end_msg 1 ;; # Failed to start
                esac
                ;;
          *)
                # Failed to stop
                log_end_msg 1
                ;;
        esac
        ;;

  *)
        N=/etc/init.d/$NAME
        # echo "Usage: $N {start|stop|restart|reload|force-reload}" >&2
        log_success_msg "Usage: $N {start|stop|restart|force-reload}"
        exit 1
        ;;
esac

exit 0


