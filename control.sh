#!/bin/bash

SERVICE_NAME="goadmin_tpl"
VERSION="v0.1.0"

function build() {
	go build -o $SERVICE_NAME -tags=jsoniter -ldflags "-w -s"
}

function swagger() {
	rm -f docs/api/swagger.yaml
	cd app && swag init --output ../docs/api --outputTypes yaml --parseInternal
	cd ..
}

function status() {
	auth_pid=$(ps -ef |grep $SERVICE_NAME|grep -v grep|awk '{print $2}')
	if [[ x$auth_pid == x"" ]]; then
		error "$SERVICE_NAME service is not running."
		return 0
	else
		success "$SERVICE_NAME service is running as ${auth_pid}"
	fi
}

function start() {
	auth_pid=$(ps -ef |grep $SERVICE_NAME |grep -v grep|awk '{print $2}')
	if [[ x$auth_pid == x"" ]]; then
		info "starting auth process..."
		nohup ./$SERVICE_NAME >> runtime.log 2>&1 &
	fi
	status
}

function restart() {
	#如果auth进程存在，直接kill服务进程，如果不存在，启动auth
	auth_pid=$(ps -ef |grep $SERVICE_NAME|grep -v grep|awk '{print $2}')
	if [[ x$auth_pid != x"" ]]; then
			info "$SERVICE_NAME service is running as ${auth_pid}"
			warn "killing ${auth_pid}"
			kill -15 ${auth_pid}
			info "wait server exit..."
			auth_pid=$(ps -ef |grep $SERVICE_NAME|grep -v grep|awk '{print $2}')
			if [[ x$auth_pid != x"" ]]; then
			  kill -9 ${auth_pid}
			fi
	fi
	start
	info "wait server start..."
	status
}

function stop() {
	auth_pid=$(ps -ef |grep $SERVICE_NAME|grep -v grep|awk '{print $2}')
	if [[ x$auth_pid == x"" ]]; then
		error "$SERVICE_NAME service is not running."
		return 0
	else
		success "$SERVICE_NAME service is running as ${auth_pid}"
		warn "killing service #${auth_pid}"
		kill ${auth_pid}
		return 1
	fi
}

function clean() {
    rm -f runtime.log
    rm -f "${SERVICE_NAME}"
}

function info(){
    echo -e "\033[34m$1\033[0m"
}


function success(){
    echo -e "\033[32m$1\033[0m"
}

## Error to warning with blink
function error(){
    echo -e "\033[31m$1\033[0m"
}

## Error to warning with blink
function warn(){
    echo -e "\033[33m$1\033[0m"
}


case "$1" in
    build)
        build
        ;;
    clean)
        clean
        ;;
    swagger)
        swagger
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    *)
    info "Usage: $0 {build|clean|swagger|start|stop|restart|status}"
esac
