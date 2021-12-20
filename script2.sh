#!/bin/bash

if [ "$1" == "-f" ]; then
	file=$2
	if [ -n "$3" ]; then
		login="$3"
	else
		login="$USER"
	fi
else
	file=/etc/passwd
	if [ -n "$1" ]; then
		login="$1"
	else
		login="$USER"
	fi
fi

if [ -e "$file" ]; then  # если файл существует, то в нём производится поиск
	string=$( grep "^$login:" $file )
	if [ -z "$string" ]; then
		echo "Пользователь не найден" >&2
		exit 1
	else
		IFS=':' read -r -a result <<< "$string"
		echo "${result[5]}"
	fi
else
	echo "Файл не найден" >&2
	exit 2
fi
