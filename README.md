# git-login

> Never type your token again after cloning a repo.

`git-login` detects the current repository's remote provider, configures
`git credential.helper cache` globally, and feeds the right credentials into
it — so `git push` just works for the next hour.

## Features

- Auto-detects provider from `origin` remote (HTTPS or SSH URL)
- Reads credentials from environment variables when available
- Falls back to an interactive prompt (token input is hidden) when not
- Credential cache lasts **3600 seconds** — one run per session is enough
- Multi-provider: GitHub and GitLab out of the box, easy to extend

## Supported providers

| Provider | Username variable | Token variable  |
|----------|-------------------|-----------------|
| GitHub   | `GITHUB_USER`     | `GITHUB_TOKEN`  |
| GitLab   | `GITLAB_USER`     | `GITLAB_TOKEN`  |

## Usage

```sh
# inside any cloned repo
git-login
```

If the variables are set, it runs silently. Otherwise it prompts:

```
GitHub username: your-username
GitHub token: ········
git-login: GitHub credentials cached (your-username@github.com, timeout 3600s)
```

## Recommended setup

Export the variables in your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):

```sh
export GITHUB_USER=your-username
export GITHUB_TOKEN=ghp_...
```

Then `git-login` becomes a zero-input command you can run right after `git clone`.

## Build

Requires [mush](https://mush.javanile.org).

```sh
mush build           # → target/debug/git-login
mush build --release # → target/release/git-login
```

## Extending with a new provider

1. Create `src/<provider>.sh` with a `git_login_<provider>_login()` function
   (copy `src/github.sh` as a template).
2. Add `module <provider>` at the top of `src/main.sh`.
3. Add a `<provider>)` case in the `case "$provider" in` block of `main()`.
4. Add the host pattern in `git_login_provider_detect()` inside `src/provider.sh`.