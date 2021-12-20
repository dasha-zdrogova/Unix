#!/bin/bash

if [ "$1" == "-f" ]; then
	if [ -n "$2" ]; then
		file=$2
	else
		echo "Неверный формат вызова" >&2
		exit 2
	fi
	if [ -n "$3" ]; then
		groupname="$3"
	else
		echo "Неверный формат вызова" >&2
		exit 2
	fi
else
	file=/etc/group
	if [ -n "$1" ]; then
		groupname="$1"
	else
		echo "Неверный формат вызова" >&2
		exit 2
	fi
fi

users=
arr_of_users=
if [ -e "$file" ]; then  # если файл существует, то в нём производится поиск
	string=$( grep "^$groupname:" $file )
	if [ -z "$string" ]; then
		echo "Группа не найдена" >&1
		exit 1
	else
		IFS=':' read -r -a users <<< "$string"
		result="${users[3]}"

		IFS=',' read -r -a arr_of_users <<< "$result"
		for i in "${arr_of_users[@]}"; do
			echo "$i"
		done
	fi
else
	echo "Файл не найден" >&2
	exit 2
fi
