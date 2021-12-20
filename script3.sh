#!/bin/bash

opt_h=
opt_s=
opt_N=
opt_sep=
dir=

# Считывание опций
for arg in "$@"
do
	if [[ -z "$opt_sep" ]]
	then
		case $arg in
		--help)	echo "topsize [--help] [-h] [-N] [-sminsize] [--] [dir]"
			echo "N - количество файлов, если не задано - все файлы"
			echo "minsize - минимальный размер, если не задан - 1 байт"
			echo "-h: вывод размера в 'человекочитаемом формате'" 
			echo "dir - какалог поиска, если не задан, то текущий"
			exit 0
			;;
		--) opt_sep=1 ;;
		-h)	opt_h=1 ;;
		-s)	opt_s=1 ;;
		[0-9]*)	if [[ $opt_s == 1 ]]; then
					minsize="$arg"
				else
					echo 'Опция указана неверно' >&2
					exit 2
				fi ;;
		-[0-9]*) opt_N="${arg##-}" ;;
		*)	dir="$arg"
			if ! [[ -d "$dir" ]]; then
				echo "Данного пути не существует" >&2
				exit 2
			fi ;;
		esac
	else
		dir="$arg"
		if [[ -d "$dir" ]]; then
			echo "Данного пути не существует" >&2
		fi
	fi
done

# Если не задан путь или размер, то их необходимо задать
if ! [[ -n "$minsize" ]]; then
	minsize=1c
fi

if ! [[ -n "$dir" ]]; then
	dir=.
fi

# Вывод пути искомых файлов
if [[ -n "$opt_N" && -n "$opt_h" ]]; then
	find "$dir" -type f -size +"$minsize" -print0 | xargs -0 du | sort -nr | head -"$opt_N" | cut -f2 | xargs -I{} du -sh {}
elif [[ -n "$opt_N" ]]; then
	find "$dir" -type f -size +"$minsize" -print0 | xargs -0 du | sort -nr | head -"$opt_N"
elif [[ -n "$opt_h" ]]; then
	find "$dir" -type f -size +"$minsize" -print0 | xargs -0 du | sort -nr | cut -f2 | xargs -I{} du -sh {}
else
	find "$dir" -type f -size +"$minsize" -print0 | xargs -0 du | sort -nr
fi
