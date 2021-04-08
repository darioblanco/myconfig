#!/usr/bin/env bash
# Clone and pull Github repository for the currently authenticated user
# Author: Dario Blanco (dblancoit@gmail.com)

set -o errexit
set -o nounset
set -o pipefail

# shellcheck source=utils.sh
. utils.sh
# shellcheck source=install.sh
. install.sh

trap exit_gracefully INT

readonly github_path=~/Github

function sync_repo() {
  if [[ -d "$github_path/$1" ]]; then
    # shellcheck disable=SC2015
    cd "$github_path/$1" && git pull origin master || git pull origin main || print_red "Could not sync $1"
  else
    gh repo clone "$1" "$github_path/$1"
  fi
}

function main() {
  print_green "Syncing Github repositories..."
  install_xcode_clt
  print_blue "Creating Github folder..."
  mkdir -p "$github_path"
  print_blue "Checking Github authentication..."
  gh auth status || gh auth login
  print_blue "Syncing authenticated user repositories..."
  gh api -X GET /user/repos --jq '.[].full_name' -f per_page=300 | while read -r repo ; do
    sync_repo "$repo"
  done
  print_blue "Syncing organization repositories for the authenticated user..."
  gh api /user/orgs --jq '.[].login' | while read -r org ; do
    gh api -X GET /orgs/"$org"/repos --jq '.[].full_name' -f per_page=300 | while read -r repo ; do
      sync_repo "$repo"
    done
  done
  print_green "Github repositories synced"
}

main
