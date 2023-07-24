# working_directory "/app"
# # pid "/app/shared/pids/unicorn.pid"
# # stderr_path "/app/shared/log/unicorn.stderr.log"
# # stdout_path "/app/shared/log/unicorn.stdout.log"

# listen "/app/shared/sockets/unicorn.sock"
# worker_processes 2
# timeout 30

worker_processes 8

pid "/var/run/unicorn.pid"
listen "/var/tmp/unicorn.sock"

# stdout_path "./log/unicorn.stdout.log"
# stderr_path "./log/unicorn.stderr.log"

stdout_path "/dev/stdout"
stderr_path "/dev/stderr"