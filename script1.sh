#!/bin/bash

flag=False
while [ -n "$1" ]; do
	current=$1
	if [ "$1" == '-h' ]; then
		cat help.txt
		exit 0

	elif [ "$1" == '-v' ]; then
		shift 1
		flag=True

	elif [ "$1" == '-d' ]; then
		shift 1
		while [ -n "$1" ]; do
			if [ "$1" == "--" ]; then
				shift 2
			else
				ls -l "$1"
				shift 1
			fi
		done
		exit 0

	elif [ "$1" == "--" ]; then
		shift 1
		if [ -z "$1" ]; then
			echo "Отсутствует суффикс и файл" > ./errors.txt
			exit 2
		fi
		if [ -z "$2" ]; then
			echo "Отсутствует суффикс или файл" > ./errors.txt
			exit 2
		fi
		suffix=$1
		shift 1
		break

	elif [ "${current:0:1}" == "-" ]; then
		echo "Неподдерживаемая функция" > ./errors.txt
		exit 2
	fi	

done

# Замена имени файла
for i in "$@"; do
	current=$1
	if [ "$flag" == "True" ];
	then 
		ls -l "$current"
	fi
	
	name="${current%.*}"
	extension="${current#$name}"  # Получение расширения

	if [ -e "$current" ]; then
		mv -- "$current" "$name$suffix$extension"
	else
		echo "Отсутствует указанный файл" > ./errors.txt
		continue
	fi

done



