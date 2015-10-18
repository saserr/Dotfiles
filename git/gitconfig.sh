#!/bin/bash

# User
git config --global user.name "Sanjin Sehic"
echo -n "[.gitconfig] email: "; read email
git config --global user.email "$email"

# Core
git config --global core.pager "less -r"
git config --global core.autocrlf input # For Mac and Linux, no EOL conversion
git config --global core.safecrlf true # Check that CRLF conversion is reversible

# Diff
git config --global diff.renames copies
git config --global diff.mnemonicprefix true # Use i/, w/, ... instead of a/ b/ for diff sides

# Branch
git config --global branch.autosetupmerge always # Setup local and remote branches to track their starting branch
git config --global branch.autosetuprebase always # Rebase upon pull instead of merge

# Merge
git config --global merge.summary true
git config --global merge.stat true

# Rebase
git config --global rebase.autosquash true

# Push
git config --global push.default tracking # Push branches to the remote branches they track

# Rerere
git config --global rerere.enabled true # Remember how a hunk conflict was resolved

# Color
git config --global color.branch auto
git config --global color.diff auto
git config --global color.status auto
git config --global color.interactive auto

# Alias
# Common
git config --global alias.s "status -sb"
git config --global alias.a add
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.co checkout
# Helpers
git config --global alias.d "diff --word-diff"
git config --global alias.dc "diff --cached"
git config --global alias.ls 'log --pretty=format:"%C(yellow)%h%Cred%d\ %Creset%s%Cblue\ [%cn]" --decorate'
git config --global alias.ll 'log --pretty=format:"%C(yellow)%h%Cred%d\ %Creset%s%Cblue\ [%cn]" --decorate --numstat'
git config --global alias.gl 'log --graph --pretty=format:'"'"'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"'"' --abbrev-commit'
# Interactive Rebase
git config --global alias.ri "rebase --interactive --autosquash"
git config --global alias.fixup '!sh -c '"'"'git commit -m "fixup! $(git log -1 --format='"'"'\'"'"''"'"'%s'"'"'\'"'"''"'"' $@)"'"'"' -'
git config --global alias.squash '!sh -c '"'"'git commit -m "squash! $(git log -1 --format='"'"'\'"'"''"'"'%s'"'"'\'"'"''"'"' $@)"'"'"' -'
# Stash
git config --global alias.sl "stash list"
git config --global alias.sp "stash pop"
git config --global alias.ss "stash save"
