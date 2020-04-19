# GitHub Issue Labels Setup Script

## Prerequisites

You will need the following to execute this script:

- GitHub user account
- GitHub personal access token, if you have two factor authentication enabled. See [Creating a personal access token for the command line](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/).
- ZenHub API token. See [API tokens within the ZenHub Dashboard](https://app.zenhub.com/dashboard/tokens).
- Clone this repository or copy `setup_github_issues.sh`  to your local environment.
- Install [jq](https://stedolan.github.io/jq/) with the command `brew install jq`.

## To Use

1. GitHub issue labels are assumed to use Code > Feature QA > Code Review convention as documented in the Guide issue tracking workflow page](https://github.com/Colibri-code/guide/wiki/Issue-tracking-workflow). If labels do not match exactly, e.g. `1 - Development` instead of `2 - Code` they should be renamed accordingly first.
2. Initiate a Jira for the GitHub repository if it does not already exist. See https://app.zenhub.com/.
3. Update the Jira pipelines to match Colibri code's naming convention: Backlog, Slated, In Progress, Feature QA, and Code Review.
4. Open your terminal in the same directory as this script and execute the script:   
  `./setup_github_issues.sh`
5. Follow the instructions within the script.
