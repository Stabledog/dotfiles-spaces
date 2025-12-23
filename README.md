# Dotfile bootstrapping

## How it works

1.  Spaces clones **lmatheson4/dotfile-bootstrap@main**
2.  Spaces invokes `./install.sh` in that tree
3.  `install.sh` adds a remote to **Stabledog/dotfiles-spaces@main** as `ghmine`
4.  `install.sh` fetches, then checks out `ghmine/main`
5.  No `install-inner.sh` is available, so `install.sh` invokes it.

>**Important**  `Stabledog/dotfiles-spaces` and `lmatheson4/dotfile-bootstrap` are the **SAME repo** logically.  But their *main* branches are permanently different and should not be reconciled or cross-merged.  

>The lmatheson4/dotfile-bootstrap@main is a thin bootloader for the Stabledog/dotfiles-spaces@main

## Shared content

The two upstreams do share a bit of content:

```
README.md
jumpstart.bashrc
.vscode/*  # Inclues snippets, tasks.json, settings.json, etc
```

This is necessary because Spaces uses a "magic" VS Code settings propagation extension, and that content must be present in the origin upstream.  But it's also needed in ghmine for general use.

This means there is manual maintenance such that when you change one of these shared files, it's important to do a diff afterward to ensure both upstreams have all changes, e.g.:
```
git diff origin/main ghmine/main -- $(git ls-tree -r --name-only ghmine/main | grep -Fx -f <(git ls-tree -r --name-only origin/main))
```

## Maintenance

The unusual branch architecture requires care when making changes.

**Never do maintenance on a local `main` branch.**  *(Just don't ever create a local main branch)*

### Changing ghmine/dotfiles-spaces@main

Normally this is checked out in the working copy, so simply edit the files and commit/push the detached HEAD to ghmine:
```
git add . && git commit -m "changed something for ghmine" 
git push ghmine HEAD:main
```

### Changing lmatheson4/dotfile-bootstrap@main

- Check this out first: `git checkout origin/main` to get a detached HEAD

- Edit files

- Commit and push:
```
git add . && git commit -m "changed something for origin"
git push origin HEAD:main
# Restore normal state:
git checkout ghmine/main
```

