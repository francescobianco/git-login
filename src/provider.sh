## Detect the remote provider and configure the credential helper.

# Detect provider name from a remote URL.
# Supports HTTPS (https://github.com/...) and SSH (git@github.com:...) forms.
git_login_provider_detect() {
  local url
  url="$1"

  case "$url" in
    *github.com*) echo "github" ;;
    *gitlab.com*) echo "gitlab" ;;
    *bitbucket.org*) echo "bitbucket" ;;
    *) echo "unknown" ;;
  esac
}

# Extract the hostname from a remote URL for use in git-credential entries.
git_login_provider_host() {
  local url
  url="$1"

  # HTTPS form: https://github.com/user/repo.git
  # SSH form:   git@github.com:user/repo.git
  case "$url" in
    https://*)
      url="${url#https://}"
      echo "${url%%/*}"
      ;;
    git@*)
      url="${url#git@}"
      echo "${url%%:*}"
      ;;
    *)
      echo ""
      ;;
  esac
}

# Configure git to use the in-memory credential cache globally so that
# approved credentials survive across multiple git invocations.
git_login_provider_credential_helper_setup() {
  git config --global credential.helper 'cache --timeout=3600'
}