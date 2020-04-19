#!/bin/bash

# setup_github_issues.sh 
# USE:
#
# Program adds new labels to github issue labels and deletes all others
# Existing issue labels will NOT be overwritten by new labels with the same name (i.e issue data is saved)
# 
# Run with  --nodelete to use without deleting old labels

function jsonValue(){
	KEY=$1
	num=$2
	awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | sed -n ${num}p
}

# info
token='1cd5118ba9a75cec09768637a9966a0f3f084e5de7ecbd4aa061dbc098acfcc572c9d6a7c276ee60'
pipeID=5b3b99b1ad7a611caffd9f12 #destination pipe
pos=top
repoID=137907596
issueNum=1
gitroot=https://api.github.com
zenroot=https://api.zenhub.io


gitToZen=(
"0 - Backlog"
"1 - Slated"
"2 - Code"
"3A - Feature QA"
"3B - Code Review"
"4 - Dev queue"
"5 - Dev"
"6 - Test queue"
"7 - Test QA"
"8 - Live queue"
"9 - Live QA"
)

taggedissues=$(curl --user "$USER:$PASS" "$gitroot/repos/"$REPO_USER"/"$REPO_NAME"/issues/"$issue"/labels" | jsonValue name)
taggedissues="${taggedissues//\"}"

# Transfer Github labels into Zenhub
function git_to_zen(){
	# Iterate through issue queue
    for issue in "${issuesqueue[@]}"
    issueNum=(GET ISSUE NUMBER)
    do
        # Iterate through labels tagged for each issue
        for label in "${taggedissues[@]}"
        do  
            # Iterate through labels to be moved to Zenhub pipelines
            for elt in "${gitToZen[@]}"
            do
            # Check if label tagged label matches label to be moved to Zenhub pipeline
            if $elt == $label 
                # Move issues tagged w/ old Github progress labels to Zenhub pipelines
                if label == "0 - Backlog"
                    temp=(GET PIPE ID) "Backlog"
                    curl -H "X-Authentication-Token: $TOKEN" --data "pipeline_id=$temp&position=$top" \
                    $zenroot/p1/repositories/$repoID/issues/$issueNum/moves 
                if label == "1 - Slated" 
                    temp=(GET PIPE ID) "Slated"
                    curl -H "X-Authentication-Token: $TOKEN" --data "pipeline_id=$temp&position=$top" \
                    $zenroot/p1/repositories/$repoID/issues/$issueNum/moves 
                if label == "2 - Code" 
                    temp=(GET PIPE ID) "In Progress"
                    curl -H "X-Authentication-Token: $TOKEN" --data "pipeline_id=$temp&position=$top" \
                    $zenroot/p1/repositories/$repoID/issues/$issueNum/moves 
                if label == "3A - Feature QA" 
                    temp=(GET PIPE ID) "Feature QA"
                    curl -H "X-Authentication-Token: $TOKEN" --data "pipeline_id=$temp&position=$top" \
                    $zenroot/p1/repositories/$repoID/issues/$issueNum/moves 
                if label == "3B - Code Review" 
                    temp=(GET PIPE ID) "Code Review"
                    curl -H "X-Authentication-Token: $TOKEN" --data "pipeline_id=$temp&position=$top" \
                    $zenroot/p1/repositories/$repoID/issues/$issueNum/moves 
                if label in ("4 - Dev queue"   "5 - Dev" "6 - Test queue" "7 - Test QA"  "8 - Live queue"  "9 - Live QA")	 
                    temp=(GET PIPE ID) "Closed"
                    curl -H "X-Authentication-Token: $TOKEN" --data "pipeline_id=$temp&position=$top" \
                    $zenroot/p1/repositories/$repoID/issues/$issueNum/moves
            done
            # Map Github estimate labels to Zenhub estimates         
            if label contains 'E.'
                # Extract the estimate from label
                temp="${label/' hours'/}"
                num="${temp/'E.'/}"         
                est= CLEAN UP THE EXTRACTION
                # Set the estimate in Zenhub
                curl -H "X-Authentication-Token: $TOKEN" --data "estimate=$est" \
                $zenroot/p1/repositories/$repoID/issues/$issueNum/estimate 
            fi    
        done
    done 
            

# Map old Github label names to new Github labels
function map_git_to_git(){
    if label == "priority"
        rename "priority" --> "priority: high"
    if label == "manuel deployment"
        rename "manuel deployment" --> "needs manual deployment"



			
function delete(){
	# Delete obsolete labels
	oldlabels="${oldlabels// /%20}"	
	oldlabels="${oldlabels//\"}"
	
	# Keep non-obsolete labels
	for KEEP in "${newlabels[@]}"
	do 
		KEEP="${KEEP// /%20}"
		oldlabels="${oldlabels/"%20$KEEP"/}" # remove non-obsolete labels from delete-list
	done

	# Delete all others
	for word in ${oldlabels[@]}
	do 
		word="${word/'%20'/}"
		word="${word//\"}"
		curl --user "$USER:$PASS" --include --request DELETE "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels/$word"
	done
}


function add_defaults(){
	# Create Priority level labels
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"priority- critical", "color":"ff0000", "description":"top priority and urgent"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"priority- high", "color":"ff6666"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"priority- low", "color":"ffb3b3"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	
	# Create Status labels
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"blocked", "color":"66ffcc"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"blocker", "color":"66ffcc"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"question", "color":"66ffcc"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"needs estimate", "color":"66ffcc"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"needs revision", "color":"66ffcc"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"

	# Create Work-Type labels
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"pattern", "color":"ffcc00"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"theming", "color":"ffcc00"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"migration", "color":"ffeb99"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"drupal", "color":"ffeb99"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"UX/design", "color":"ffd9b3"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"content", "color":"ffa64d"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"documentation", "color":"ff8000"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	
	# Create DevOps labels
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"deployment", "color":"00e1ff"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"needs manual deployment", "color":"00e1ff"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"hotfix", "color":"00e1ff"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"

	# Create Planning labels
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"epic", "color":"cc0066"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"sprint", "color":"cc0066"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"sprint retrospective", "color":"cc0066"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"

	# Create Supplementary labels
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"security", "color":"b9b9b9"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"SEO", "color":"b9b9b9"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"

	# Create Inactive labels
	curl --user "$USER:$PASS" --include --request POST --data '{"name":"duplicate", "color":"3a2a9e"}' "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels"
}

# List of new labels
newlabels=(
	"priority- critical"
	"priority- high"
	"priority- low"
	"blocked"
	"blocker"
	"question"
	"needs revision"
	"needs estimate"
	"pattern"
	"theming"
	"migration"
	"drupal"
	"UX/design"
	"content"
	"documentation"
	"deployment"
	"requires manual deployment"
	"hotfix"
	"epic"
	"SEO"
	"duplicate"
	)


echo -n "GitHub User: "
read USER

# Generate a personal access token at https://github.com/settings/tokens
echo -n "GitHub Password (or token if using 2fa): "
read -s PASS
echo

echo -n "GitHub Repo (expected format is 'owner/repository' e.g. 'COlibri-code/intralinks'): "
read REPO

REPO_USER=$(echo "$REPO" | cut -f1 -d /)
REPO_NAME=$(echo "$REPO" | cut -f2 -d /)

# Get old labels from Github API
oldlabels=$(curl --user "$USER:$PASS" "https://api.github.com/repos/"$REPO_USER"/"$REPO_NAME"/labels" | jsonValue name)


# Terminal interface
if [[ $* == *--nodelete* ]]; then
	read -e -p 'Are you sure you want to run without resetting labels? (Y/N):' ANSWER
	if [[ $ANSWER =~ ^[Nn]$ ]]; then
		echo 'Aborting'
		exit	
	else
		echo 'Running without resetting labels'
		add_defaults
	fi
else
	add_defaults
	delete
fi

