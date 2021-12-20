#!/bin/bash

opt_v=
opt_d=
opt_sep=

for arg in "$@"
do
	if [[ -z "$opt_sep" && "${arg:0:1}" == "-" ]]
	then
		case "$arg" in
		--)	opt_sep=1 
			;;
		-v)	opt_v=1 
			;;
		-d) opt_d=1 
			;;
		-h)	echo "$0: Переименование файла путём втавки суффикса перед расширением"
			echo "всех файлов заданного каталога и всех его подкаталогов,"			
			echo "имена которых удовлетворяют хотя бы одному из заданных шаблонов"
			echo "Синтаксис: $0 [-h] [-d|-v] [--] suffix dir mask1 [mask2...]"
			echo "-d: запуск с выводом исходных и конечных имён файлов без переименования" 
			echo "-v: запуск с выводом исходных и конечных имён переименовываемых файлов"
			echo "-h: вывод справки и выход"
			exit 0
			;;
		*)	echo "$0: Незаданная опция "$arg", напишите $0 -h для помощи" >&2
			exit 2
			;;
		esac
	fi
done

opt_sep=
suffix=
dir=
k=0
declare -a masks # Создание массива с масками
for arg in "$@"
do
	if [[ "$opt_sep"  || "${arg:0:1}" != '-' ]]
		then
			if [[ -z $suffix ]]
			then
				suffix=$arg
			elif [[ -z $dir ]]
			then
				dir=$arg
			else
				masks[k]="$arg"
				k=$((k+1))
			fi	
	fi	
done

if [[ -z "$suffix" || -z "$dir" || -z "${masks[@]}" ]]
then
	echo "Суффикс, директория или маска не найдены"
	exit 2
fi

for mask in "${masks[@]}"
do
	find "$dir" -name "$mask"
done | sort -u | while read file
do
	IFS='/' read -r -a result <<< "$file"

	name="${file%.*}"
	ext="${file#"$name"}"
		
	if [[ -n "$opt_d" || -n "$opt_v" ]]
	then
		echo "$file" "-->" "$name$suffix$ext"
	fi
	if [[ -z opt_d ]]
	then
		echo mv -- "$file" "$name$suffix$ext"
	fi
done


