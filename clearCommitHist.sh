#!/bin/bash

function on_exit(){
    echo "${1}"
    read -n 1 -s -r -p "Press any key to exit" 
    exit ${2}
}

function confirm() {
    read -r -p "${1} [Y/N] " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

if confirm "Save log?" 
then 
    exec > >(tee ClearCommitHistory.log) 2>&1 
fi

read -p 'Branch Name: ' branch

if [[ `git branch | egrep "^\*?[[:space:]]+${branch}$"` ]] || [[ `git branch | egrep "^[[:space:]]+${branch}$"` ]]
then 
    echo "Branch $branch found"
else
    on_exit "Branch $branch not found, exiting..." 1
fi


if confirm "Proceed will clear all $branch branch commits history - Are you sure?" 

then 

    git checkout --orphan latest_branch

    git add -A

    git commit -am "Clear $branch Commit History"

    git branch -D $branch

    git branch -m $branch

    git push -f -u -v origin $branch

else 
    on_exit "Process Aborted" 2
fi 
    
on_exit "DONE" 0