#!/usr/bin/env bash

DIR=$(readlink -e "$(dirname "$0")")

if [ -z "$2" ]
then
  echo "Task ID not specified"; exit;
fi

case "$1" in
-r) targetPath="$DIR"; targetLog="root";;
-p) targetPath="$DIR/archive/pause"; targetLog="pause";;
-t) targetPath="$DIR/archive/test"; targetLog="test";;
-a) targetPath="$DIR/archive/$(date +"%Y.%m")"; targetLog="archive $(date +"%Y.%m")";;
*) echo "Wrong key $1. Available keys: -r(oot) -p(ause) -t(est) -a(rchive)"; exit;;
esac

taskPathsCount=$(find ./1_stuff/ -type d -name "$2*" | wc -l)
tasks=$(find $DIR -type d -name "$2*")

IFS=$'\n'

i=0
selectedTask=""
selectedTaskName=""

if [ "$taskPathsCount" -gt 1 ]; then
  declare -a taskNames
  declare -a taskPaths
  declare -a fullTasks
  echo "More than one task found. Select one:"
  for fullTask in $tasks
  do
    i=$((i+1))
    fullTasks[i]=$fullTask
    taskNames[i]=${fullTask##*/}
    taskPaths[i]=${fullTask%/*}
    echo $i: "${taskNames[i]}"
  done

  while [ -z $selectedTask ]; do
      read -er taskNumber
      selectedTask="${fullTasks[taskNumber]}"
      selectedTaskName="${taskNames[taskNumber]}"
      selectedTaskPath="${taskPaths[taskNumber]}"
  done
elif [ "$taskPathsCount" -eq 0 ]; then
  echo "Task not found. Creating new one."
  exec "$DIR/new"
  exit
else
  selectedTask=$tasks
  selectedTaskName=${tasks##*/}
  selectedTaskPath=${tasks%/*}
fi

if [ "$targetPath" = "$selectedTaskPath" ]; then
  echo "Task already in place"
  exit
fi

if ! [ -d "$targetPath" ]; then
  mkdir "$targetPath"
fi

mv "$selectedTask" "$targetPath/$selectedTaskName"

logMessage="$(date +"%F %T") $targetLog"

sed -i "1s/^/$logMessage\n/" $targetPath/$selectedTaskName/move.log
