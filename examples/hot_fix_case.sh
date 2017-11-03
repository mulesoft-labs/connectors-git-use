# Exmple of a complex case for working with hotfixes
# repo name: kiwi
mkdir kiwi
cd kiwi
git init
echo "1" >> test.txt
git add .
git commit -m 'Commit 1 in master to simulate merge'
git tag -a -m "Version 3.1.0 release" kiwi/3.5.0
echo "2" >> test.txt
git add .
git commit -m 'Commit 2 in master to simulate merge'
git tag -a -m "Version 4.1.0 release" kiwi/4.0.0
git checkout -b master/3.5.x kiwi/3.5.0
git checkout -b hotfix/SCC1 kiwi/3.5.0
echo "3" >> test.txt
git add .
git commit -m 'Commit 3 in hotfix/SCC1'
echo "4" >> test.txt
git add .
git commit -m 'Commit 4 in hotfix/SCC1'
git checkout master/3.5.x
git merge --no-ff hotfix/SCC1 -m 'Merge from hotfix/SCC1 to master/3.5.x'
git checkout -b hotfix/SCC2 kiwi/3.5.0
echo "5" >> test.txt
git add .
git commit -m 'Commit 5 in hotfix/SCC2'
echo "6" >> test.txt
git add .
git commit -m 'Commit 6 in hotfix/SCC2'
git checkout master/3.5.x
git merge --no-ff hotfix/SCC2 -m 'Merge from hotfix/SCC2 to master/3.5.x'
git checkout -b release/3.5.1 master/3.5.x
echo "7" >> test.txt
git add .
git commit -m 'Commit 7 in release/3.5.1'
git checkout master/3.5.x
git merge --no-ff hotfix/SCC2 -m 'Merge from release/3.5.1 to master/3.5.x'
git tag -a -m "Version 4.5.1 release" kiwi/3.5.1
