# Fix a messed up branch
git filter-branch --index-filter 'git rm -r --cached --ignore-unmatch <file/dir>' HEAD

# Clone a branch from the main branch:
git checkout -b dev main


# Delete a branch
git branch -d dev

