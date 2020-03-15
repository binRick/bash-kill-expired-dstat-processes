if [[ $- = *i*  ]]; then
    alias vi="vim"
    alias gc="git commit"
    alias gd="git diff"
    alias gs="git status"

    MAX_DSTAT_AGE_SECONDS=86400

    pid_creation_timestamp(){
        command stat -c %Y /proc/$1/exe
    }
    get_dstat_pids(){
        ps ax|grep 'dstat'|grep  -v tmux|egrep 'python |python2 '|sed 's/^[[:space:]]//g'|cut -d' ' -f1
    }
    get_expired_dstat_pids(){
        for p in $(get_dstat_pids); do
            created_ts=$(pid_creation_timestamp $p)
            if [[ "$created_ts" -lt "$(echo $(date +%s) - $MAX_DSTAT_AGE_SECONDS | bc)" ]]; then
                echo $p
            fi
        done
    }
    kill_expired_dstat_pids(){
        for p in $(get_expired_dstat_pids); do
            kill $p
        done
    }
fi
