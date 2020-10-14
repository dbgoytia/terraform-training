# Fix a messed up branch
git filter-branch --index-filter 'git rm -r --cached --ignore-unmatch <file/dir>' HEAD

