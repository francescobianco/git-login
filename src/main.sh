module provider
module github
module gitlab

main() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "fatal: not a git repository (or any of the parent directories): .git" >&2
    return 128
  fi

  local remote_url
  remote_url=$(git remote get-url origin 2>/dev/null)

  if [ -z "$remote_url" ]; then
    echo "git-login: no remote 'origin' found in current directory" >&2
    return 1
  fi

  git_login_provider_credential_helper_setup

  local provider
  provider=$(git_login_provider_detect "$remote_url")

  case "$provider" in
    github) git_login_github_login "$remote_url" ;;
    gitlab) git_login_gitlab_login "$remote_url" ;;
    *) echo "git-login: unsupported provider for remote '$remote_url'" >&2; return 1 ;;
  esac
}