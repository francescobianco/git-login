## GitHub provider — authenticates via GITHUB_TOKEN and GITHUB_USER.

git_login_github_login() {
  local url
  url="$1"

  local host
  host=$(git_login_provider_host "$url")

  # Fall back to github.com for SSH remotes that resolve to github.com
  if [ -z "$host" ]; then
    host="github.com"
  fi

  local user
  user="${GITHUB_USER:-}"

  local token
  token="${GITHUB_TOKEN:-}"

  if [ -z "$user" ]; then
    printf "GitHub username: "
    read -r user </dev/tty
  fi

  if [ -z "$token" ]; then
    printf "GitHub token: "
    read -rs token </dev/tty
    echo
  fi

  git credential approve <<EOF
protocol=https
host=${host}
username=${user}
password=${token}
EOF

  echo "git-login: GitHub credentials cached (${user}@${host}, timeout 3600s)"
}