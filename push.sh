# This file is used to push data to the remote git repository.
# It is present if you get git pack size exceeded errors due to this repo being to big

# Adjust the following variables as necessary
REMOTE=nudawn
#BRANCH=arch/v5.5-arch1
BRANCH=$(git rev-parse --abbrev-ref HEAD)
BATCH_SIZE=500

# check if the branch exists on the remote
if git show-ref --quiet --verify refs/remotes/$REMOTE/$BRANCH; then
  # if so, only push the commits that are not on the remote already
  range=$REMOTE/$BRANCH..HEAD
else
  # else push all the commits
  range=HEAD
fi
# count the number of commits to push
n=$(git log --first-parent --format=format:x $range | wc -l)

# push each batch
for i in $(seq $n -$BATCH_SIZE 1); do
   # get the hash of the commit to push
   h=$(git log --first-parent --reverse --format=format:%H --skip $i -n1)
   echo "Pushing $h..."
   git push $REMOTE $h:refs/heads/$BRANCH
done
# push the final partial batch
git push $REMOTE HEAD:refs/heads/$BRANCH
