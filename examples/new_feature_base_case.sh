create_commit() {
	local content=$1
	local prefix=$2
	local text=$3
	echo $content >> test.txt
	git add test.txt
	git commit -m "Commit $prefix | $content $text"
} 


check_arguments() {
	if [ -z "$1" ]
  	then
    	echo "No argument supplied - target directory (different of .) expected"
    	exit 1
	fi
}

init (){
	mkdir $1/kiwi
	cd $1/kiwi
	git init
}

tag () {
	local comment=$1
	local tag_name=$2
	git tag -a -m "$comment" "$tag_name"
}

check_out_new() {
	local branch=$1
	git checkout -b $branch
}

check_out_new_from_tag() {
	local branch=$1
	local tag=$2
	git checkout -b $branch $tag
}

check_out() {
	local branch=$1
	git checkout $branch
}

merge() {
	local branch_orign=$1
	local target_branch=$2
	git merge --no-ff $branch_orign -m "Merge from #branch_orign to $target_branch"
}

check_arguments $1
init $1
create_commit '1' '' 'in master'
check_out_new 'develop'
create_commit '2' '' 'in develop'
check_out_new 'feature/SCC1'
create_commit '3' 'SCC1' 'feature/SCC1'
check_out develop
merge "feature/SCC1" "develop"
check_out_new 'release/1.0.0'
create_commit '4' '' 'in release/1.0.0'
check_out master
merge "release/1.0.0" "master"
tag "Version 1.0.0 release" "kiwi/1.0.0"
check_out develop
merge "release/1.0.0" "develop"


