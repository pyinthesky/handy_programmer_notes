parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

parse_git_branch2() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

get_git_status(){
        gitbranch=$(parse_git_branch2);
        printf "\n\n";

        printf "Pushed Commits\n";
        printf "======================================================\n";
        git log origin/master..HEAD --oneline;
        printf "\n\n";

        printf "Un-Pushed Commits\n";
        printf "======================================================\n";
        git log --branches --not --remotes --oneline --decorate --format="%C(auto)%h %cd %C(cyan)%an %s";
        printf "\n\n";

        printf "Pushed Files Changed\n";
        printf "======================================================\n";
        #git diff --name-only "\$(parse_git_branch)" "$(git merge-base "\$(parse_git_branch)" master)";
        git diff --name-only "${gitbranch}" "$(git merge-base "${gitbranch}" master)";
        printf "\n\n";

        printf "Stashes\n";
        printf "======================================================\n";
        git stash list;
        printf "\n\n";

        printf "Un-Committed Changes\n";
        printf "======================================================\n";
        git status;
        printf "\n\n";
}

alias gitstatus=get_git_status

export PS1="[\033[96m\]\u@\h\033[00m\]] \W\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "
