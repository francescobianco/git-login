## GitLab provider — authenticates via GITLAB_TOKEN and GITLAB_USER.

git_login_gitlab_login() {
  local url
  url="$1"

  local host
  host=$(git_login_provider_host "$url")

  if [ -z "$host" ]; then
    host="gitlab.com"
  fi

  local user
  user="${GITLAB_USER:-}"

  local token
  token="${GITLAB_TOKEN:-}"

  if [ -z "$user" ]; then
    printf "GitLab username: "
    read -r user </dev/tty
  fi

  if [ -z "$token" ]; then
    printf "GitLab token: "
    read -rs token </dev/tty
    echo
  fi

  git credential approve <<EOF
protocol=https
host=${host}
username=${user}
password=${token}
EOF

  echo "git-login: GitLab credentials cached (${user}@${host}, timeout 3600s)"
}