# Exmple of a complex case for working with hotfixes
# repo name: kiwi
if [ -z "$1" ]
  then
    echo "No argument supplied - target directory (different of .) expected"
    exit 1
fi
mkdir $1/kiwi
cd $1/kiwi
git init
echo "1" >> test.txt
git add .
git commit -m 'Commit 1 in master to simulate merge'
git tag -a -m "Version 3.1.0 release" kiwi/3.5.0
echo "2" >> test.txt
git add .
git commit -m 'Commit 2 in master to simulate merge'
git tag -a -m "Version 4.1.0 release" kiwi/4.0.0
git checkout -b master-3.5.x kiwi/3.5.0
git checkout -b hotfix/SCC1 kiwi/3.5.0
echo "3" >> test.txt
git add .
git commit -m 'Commit 3 in hotfix/SCC1'
echo "4" >> test.txt
git add .
git commit -m 'Commit 4 in hotfix/SCC1'
git checkout master-3.5.x
git merge --no-ff hotfix/SCC1 -m 'Merge from hotfix/SCC1 to master-3.5.x'
git checkout -b hotfix/SCC2 kiwi/3.5.0
echo "5" >> test.txt
git add .
git commit -m 'Commit 5 in hotfix/SCC2'
echo "6" >> test.txt
git add .
git commit -m 'Commit 6 in hotfix/SCC2'
git checkout master-3.5.x
git merge --no-ff hotfix/SCC2 -m 'Merge from hotfix/SCC2 to master-3.5.x'
echo "Edit the file and fix conflicts and press Y/y to continue"
read -n 1 -p "Input Selection:" mainmenuinput
if [ "$mainmenuinput" = "y" ] || [ "$mainmenuinput" = "Y" ]; then
	git add test.txt
	git commit -m "Merge from hotfix/SCC2 to master-3.5.x' -- Resolved conflicts"
	git checkout -b release/3.5.1 master-3.5.x

	######################################################
	### while working on release a S1 arrives
	######################################################

	git checkout -b hotfix/SCC3 kiwi/3.5.0
	echo 8 >> test.txt
	git add .
	git commit  -m 'Commit 8 in hotfix/SCC3'
	git checkout master-3.5.x
	git merge --no-ff hotfix/SCC3 -m "Merge from hotfix/SCC3 to master-3.5.x"
	echo "Edit the file and fix conflicts and press Y/y to continue"
	read -n 1 -p "Input Selection:" mainmenuinput
	if [ "$mainmenuinput" = "y" ] || [ "$mainmenuinput" = "Y" ]; then
		git add test.txt
		git commit -m "Merge from hotfix/SCC3 to master-3.5.x' -- Resolved conflicts"
		git checkout release/3.5.1
		echo "7" >> test.txt
		git add test.txt
		git commit -m 'Commit 7 in release/3.5.1'
		git checkout master-3.5.x
		git merge --no-ff release/3.5.1 -m 'Merge from release/3.5.1 to master-3.5.x'
		echo "Edit the file and fix conflicts and press Y/y to continue"
		read -n 1 -p "Input Selection:" mainmenuinput
		if [ "$mainmenuinput" = "y" ] || [ "$mainmenuinput" = "Y" ]; then
			git add test.txt
			git commit -m 'Merge from release/3.5.1 to master-3.5.x -- Resolved conflicts'
			git checkout -b release/3.5.1-bis master-3.5.x
			echo "9" >> test.txt
			git add test.txt
			git commit -m 'Commit 9 in release/3.5.1-bis'
			git checkout master-3.5.x
			git merge --no-ff release/3.5.1-bis -m "Merge from release/3.5.1-bis to master 3.5.x"
			git tag -a -m "Version 3.5.1 release" kiwi/3.5.1
			echo 'GREAT!'
			exit 0
		fi
	fi
fi
echo "You need to fix conflicts to continue"
exit 1