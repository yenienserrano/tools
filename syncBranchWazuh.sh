#!/bin/bash

wz_base_branch=$1
wz_destination_branch=$2
wz_merge_branch="merge-${wz_destination_branch}-into-${wz_base_branch}"

echo "
Base branch: $wz_base_branch
Destination branch: $wz_destination_branch
Merge branch: $wz_merge_branch
"

echo "Fetching data"
git fetch
echo "Fetched data"
echo "Checkout to ${wz_base_branch}"
git checkout ${wz_base_branch}
echo "Pull"
git pull
echo "Pulled"
echo "Create merge branch"
git checkout -b ${wz_merge_branch}
echo "Pull ${wz_destination_branch}"
git pull --no-rebase origin ${wz_destination_branch}
echo "Pulled ${wz_destination_branch}"
read -p "Commit? Reply with y to continue " pipeline_sync_branch_response
if [ "$pipeline_sync_branch_response" = "y" ]; then 
  git commit -am "merge: merge ${wz_destination_branch} into ${wz_base_branch}"
  git push --set-upstream origin ${wz_merge_branch}
  gh pr create -a @me -B ${wz_base_branch} -t "Merge ${wz_destination_branch} into ${wz_base_branch}" -b "Merge ${wz_destination_branch} into ${wz_base_branch}"
else
    echo "Abort commiting. Use:
git commit -am "merge: merge ${wz_destination_branch} into ${wz_base_branch}"
git push
gh pr create -a @me -B ${wz_base_branch} -t \"Merge ${wz_destination_branch} into ${wz_base_branch}\"" -b "Merge ${wz_destination_branch} into ${wz_base_branch}"
fi;
