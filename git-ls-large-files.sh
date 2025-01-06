# https://stackoverflow.com/questions/13403069/how-to-find-out-which-files-take-up-the-most-space-in-git-repo
while read -r largefile; do
    echo $largefile | awk '{printf "%s %s ", $1, $3 ; system("git rev-list --all --objects | grep " $1 " | cut -d \" \" -f 2-")}'
done <<< "$(git rev-list --all --objects | awk '{print $1}' | git cat-file --batch-check | sort -k3nr | head -n 20)"
