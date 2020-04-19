#!/bin/bash
echo Update a Drupal extension and commit the result to git.
echo Warning:  alpha version. Assumes you are in sites/all/modules/contrib or similar.
read -e -p 'Which extension? ' EXT

if [ -z "$DRUSH_ALIAS" ]; then
	read -e -p 'Site alias (include "@"): ' ALIAS
else
	ALIAS=$DRUSH_ALIAS
	echo "Site alias: $ALIAS"
fi

if [ -z "$JIRA_TICKET" ]; then
	read -e -p 'JIRA ticket: ' JIRA
else
	JIRA=$JIRA_TICKET
	echo "JIRA ticket: $JIRA"
fi

echo OK, I will update $EXT

echo drush $ALIAS -y pm-updatecode $EXT
drush $ALIAS -y pm-updatecode $EXT

read -e -p 'New version (include 7.x-): ' NEW
read -e -p 'Old version (include 7.x-): ' OLD

echo git add -A $EXT
git add -A $EXT

echo git commit -m\"$JIRA: Update $EXT to $NEW from $OLD.\"
git commit -m"$JIRA: Update $EXT to $NEW from $OLD."