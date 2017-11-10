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
	cp -r hot_fix_case_s1_mmerges $1/kiwi
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
	check_out $target_branch
	git merge --no-ff $branch_orign -m "Merge from $branch_orign to $target_branch"
}


manual_merge(){
	local branch_orign=$1
	local target_branch=$2
	local merged_file=$3
	check_out $target_branch
	cp $merged_file test.txt
	git add test.txt
	git commit -m "Merge from $branch_orign to $target_branch -- Resolved conflicts"
}

add_features() {
	check_out "develop"
	create_commit "dev 0" "SCC21" "to simulate a feature merge"
}

hot_fixes() {
	check_out_new_from_tag "master-3.5.x" "kiwi/3.5.0"

	#### SCC1
	check_out_new_from_tag "hotfix/SCC1" "kiwi/3.5.0"
	create_commit "3" "SCC1" "in hotfix/SCC1"
	create_commit "4" "SCC1" "in hotfix/SCC1"

	#### Finish SCC1
	merge "hotfix/SCC1" "master-3.5.x"
	merge "hotfix/SCC1" "develop"
	manual_merge "hotfix/SCC1" "develop" "hot_fix_case_s1_mmerges/merge_scc1_dev.txt"

	#### SCC2
	check_out_new_from_tag "hotfix/SCC2" "kiwi/3.5.0"
	create_commit "5" "SCC2" "in hotfix/SCC2"
	create_commit "6" "SCC2" "in hotfix/SCC2"

	#### Finish SCC2
	merge "hotfix/SCC2" "master-3.5.x"
	manual_merge "hotfix/SCC2" "master-3.5.x" "hot_fix_case_s1_mmerges/merge_scc2_master_3_5_x.txt"
	merge "hotfix/SCC2" "develop"
	manual_merge "hotfix/SCC2" "develop" "hot_fix_case_s1_mmerges/merge_scc2_dev.txt"

	
	#### Starts working on release/3.5.1
	check_out_new_from_tag "release/3.5.1" "master-3.5.x"

	######################################################
	### while working on release a S1 arrives
	######################################################

	check_out_new_from_tag "hotfix/SCC4" "kiwi/3.5.0"
	create_commit "8" "SCC4" "in hotfix/SCC4"
	merge "hotfix/SCC4" "master-3.5.x"
	manual_merge "hotfix/SCC4" "master-3.5.x" "hot_fix_case_s1_mmerges/merge_scc4_master_3_5_x.txt"
	merge "hotfix/SCC4" "develop"
	manual_merge "hotfix/SCC4" "develop" "hot_fix_case_s1_mmerges/merge_scc4_dev.txt"

	#### Release/3.5.1 - SCC3
	check_out "release/3.5.1"
	create_commit "7" "SCC3" "in release/3.5.1"

	#### Finish release -- first attemp
	merge "release/3.5.1" "master-3.5.x"
	manual_merge "release/3.5.1" "master-3.5.x" "hot_fix_case_s1_mmerges/merge_release_3_5_1_master_3_5_x.txt"
	merge "release/3.5.1" "develop"
	manual_merge "release/3.5.1" "develop" "hot_fix_case_s1_mmerges/merge_release_3_5_1_develop.txt"
	

	#### Release/3.5.1 after S1 - SCC5
	check_out_new_from_tag "release/3.5.1-bis" "master-3.5.x"
	create_commit "9" "SCC5" "in release/3.5.1-bis"
	merge "release/3.5.1-bis" "master-3.5.x" 
	merge "release/3.5.1-bis" "develop"
	manual_merge "release/3.5.1-bis" "develop" "hot_fix_case_s1_mmerges/merge_release_3_5_1_bis_develop.txt"
	
	check_out "master-3.5.x"
	tag "Version 3.5.1 release" "kiwi/3.5.1"
}





# Exmple of a complex case for working with hotfixes
# repo name: kiwi
check_arguments $1
init $1

create_commit "0" "SCC0" "Initial commit"
create_commit "1" "SCC1" "in master to simulate merge"
tag "Version 3.1.0 release" "kiwi/3.5.0"
create_commit "2" "SCC2" "in master to simulate merge'"
tag "Version 4.1.0 release" "kiwi/4.0.0"

check_out_new "develop"

add_features
hot_fixes