| Command                                                      | Description                                |
| ------------------------------------------------------------ | ------------------------------------------ |
| `git init`                                                   | Initialize a local Git repository          |
| `git clone <repo-url>`                                       | Clone a remote repository                  |
| `git clone -b <branch> --single-branch --depth 1 <repo-url>` | Clone only one branch with limited history |
| `git status`                                                 | Show working directory status              |
| `git add <file>`                                             | Add file to staging area                   |
| `git add -A`                                                 | Add all changes to staging area            |
| `git commit -m "message"`                                    | Commit staged changes                      |
| `git log`                                                    | Show commit history                        |
| `git log --oneline`                                          | Show compact commit history                |
| `git log -3`                                                 | Show last 3 commits                        |
| `git diff`                                                   | Show unstaged changes                      |
| `git diff <file>`                                            | Show changes in a specific file            |
| `git diff <commit>`                                          | Show changes from a commit                 |

---

| Command                      | Description                        |
| ---------------------------- | ---------------------------------- |
| `git branch`                 | List local branches                |
| `git branch -a`              | List all branches (local + remote) |
| `git branch <name>`          | Create a new branch                |
| `git branch -d <name>`       | Delete a local branch (safe)       |
| `git branch -D <name>`       | Force delete a local branch        |
| `git checkout <branch>`      | Switch to a branch                 |
| `git checkout -b <branch>`   | Create and switch to a branch      |
| `git checkout -`             | Switch to previous branch          |
| `git merge <branch>`         | Merge branch into current branch   |
| `git diff <source> <target>` | Preview changes before merging     |

---

| Command                             | Description                 |
| ----------------------------------- | --------------------------- |
| `git remote -v`                     | Show remote URLs            |
| `git remote add origin <url>`       | Add remote repository       |
| `git remote set-url origin <url>`   | Change remote URL           |
| `git fetch`                         | Fetch changes from remote   |
| `git pull`                          | Fetch and merge from remote |
| `git pull origin <branch>`          | Pull specific branch        |
| `git push`                          | Push to remote              |
| `git push -u origin <branch>`       | Push and set upstream       |
| `git push origin --delete <branch>` | Delete remote branch        |

---

| Command                  | Description                    |
| ------------------------ | ------------------------------ |
| `git rm <file>`          | Remove file from repo and disk |
| `git rm -r <folder>`     | Remove folder                  |
| `git rm --cached <file>` | Remove from staging only       |
| `git checkout -- <file>` | Discard local file changes     |

---

| Command                        | Description                 |
| ------------------------------ | --------------------------- |
| `git branch -m <new-name>`     | Rename current branch       |
| `git branch -m <old> <new>`    | Rename another branch       |
| `git push origin :<old> <new>` | Delete old remote, push new |
| `git push -u origin <new>`     | Set upstream for new branch |

---

git pull -> combination of  ```git fetch``` + ```git merge```

``` bash
git fetch: download remote commits 
```

