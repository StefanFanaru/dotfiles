#!/bin/bash

TARGET_DIR="$1"
if [ -z "$1" ]; then
	TARGET_DIR="/mnt/x/Lectra/digital-platform"
fi
IS_PATH_REPO="$2"

GIT_LOG_FILE="$HOME/.logs/sync_projects_git_pull_log.txt"
NPM_LOG_FILE="$HOME/.logs/sync_projects_npm_log.txt"
BUILD_DOTNET_LOG_FILE="$HOME/.logs/sync_projects_build_dotnet_log.txt"
GIT_PULL_SUCCESS_COUNT=0
GIT_PULL_FAIL_COUNT=0
DOTNET_BUILD_SUCCESS_COUNT=0
DOTNET_BUILD_FAIL_COUNT=0
NPM_INSTALL_SUCCESS_COUNT=0
NPM_INSTALL_FAIL_COUNT=0
NPM_BUILD_SUCCESS_COUNT=0
NPM_BUILD_FAIL_COUNT=0
NO_CHANGES_COUNT=0
EXCLUDED_PROJECTS=("e2e-tests" "embroidery")

>$GIT_LOG_FILE
>$BUILD_DOTNET_LOG_FILE
>$NPM_LOG_FILE

echo "Starting script execution..."
echo "Target directory: $TARGET_DIR"

sync_repo() {
	dir=$1
	if [[ " ${EXCLUDED_PROJECTS[@]} " =~ " ${dir##*/} " ]]; then
		return
	fi
	cd "$dir" || return

	if [ -d ".git" ]; then
		# NOTE: Handle GIT
		echo "Processing git repository in $dir..."

		git status &>/dev/null
		if [ $? -ne 0 ]; then
			echo "Not a git repository: $dir" >>$GIT_LOG_FILE
			return
		fi

		if [ -n "$(git status --porcelain)" ]; then
			echo "$dir has changes." >>$GIT_LOG_FILE
			# stash any changes with name "Before auto-sync _short_date_time_"
			git stash push -m "Before auto-sync $(date +'%Y-%m-%d_%H-%M-%S')" &>/dev/null
			if [ $? -eq 0 ]; then
				echo "Stashed changes in $dir"
			else
				echo "Failed to stash changes in $dir" >>$GIT_LOG_FILE
				return
			fi
		fi

		git checkout main-next &>/dev/null
		pull_origin=$(
			git pull origin main-next 2>&1 | grep -q 'find remote ref main-next'
			echo $?
		)
		if [ $pull_origin -eq 0 ]; then
			echo "$dir did not have branch main-next" >>$GIT_LOG_FILE
			git checkout stefan/delivery &>/dev/null
			GIT_PULL_SUCCESS_COUNT=$((GIT_PULL_SUCCESS_COUNT + 1))
			return
		fi
		git checkout -b stefan/delivery-next &>/dev/null
		git merge main-next &>/dev/null
		if [ $? -ne 0 ]; then
			echo "Failed to sync stefan/delivery branch in $dir" >>$GIT_LOG_FILE
			GIT_PULL_FAIL_COUNT=$((GIT_PULL_FAIL_COUNT + 1))
			return
		fi

		had_changes_on_origin=$(
			git pull origin main-next 2>&1 | grep -q 'up-to-date'
			echo $?
		)

		if [ $? -eq 0 ]; then
			echo "Successfully pulled in $dir"
			GIT_PULL_SUCCESS_COUNT=$((GIT_PULL_SUCCESS_COUNT + 1))
		else
			echo "Failed to pull in $dir" >>$GIT_LOG_FILE
			GIT_PULL_FAIL_COUNT=$((GIT_PULL_FAIL_COUNT + 1))
		fi

		# if not had changes on origin, return
		if [ $had_changes_on_origin -eq 0 ]; then
			NO_CHANGES_COUNT=$((NO_CHANGES_COUNT + 1))
			return
		else
			echo "Changes found in $dir"
		fi
		# NOTE: Handle .NET build
		# if ls *.sln &>/dev/null; then
		# 	echo "Building .sln files in $dir..."
		# 	dotnet build &>/dev/null
		# 	if [ $? -eq 0 ]; then
		# 		echo "Build sln succeeded in $dir"
		# 		DOTNET_BUILD_SUCCESS_COUNT=$((DOTNET_BUILD_SUCCESS_COUNT + 1))
		# 	else
		# 		echo "Build sln failed in $dir" >>$BUILD_DOTNET_LOG_FILE
		# 		DOTNET_BUILD_FAIL_COUNT=$((DOTNET_BUILD_FAIL_COUNT + 1))
		# 	fi
		# fi
		# else loog for .csproj files and build them

		# use find to search for .csproj files
		# if found, build them
		exclude_csproj=("Samples.GeminiCad.GetContentFromConfluence.csproj" "Samples.GeminiCad.ExtractRenderTargetsFromZip.csproj")
		if [ -n "$(find . -name '*.csproj')" ]; then
			echo "Building .csproj files in $dir..."
			for csproj in $(find . -name '*.csproj'); do
				if [[ " ${exclude_csproj[@]} " =~ " ${csproj##*/} " ]]; then
					continue
				fi
				dotnet build "$csproj" &>/dev/null
				if [ $? -eq 0 ]; then
					echo "Build csproj succeeded $csproj"
					DOTNET_BUILD_SUCCESS_COUNT=$((DOTNET_BUILD_SUCCESS_COUNT + 1))
				else
					echo "Build csproj failed $dir$csproj" >>$BUILD_DOTNET_LOG_FILE
					DOTNET_BUILD_FAIL_COUNT=$((DOTNET_BUILD_FAIL_COUNT + 1))
				fi
			done
		fi

		#NOTE: Handle NPM install and build
		if [ -n "$(find . -name package.json -not -path "*/node_modules/*" -not -path "*/dist/*")" ]; then
			npm_dirs=$(find . -name package.json -not -path "*/node_modules/*" -not -path "*/dist/*" -exec dirname {} \;)
			for npm_dir in $npm_dirs; do
				cd "$npm_dir" || continue

				# Check for missing dependencies using npm ls
				missing_deps=$(npm ls --depth=0 2>&1 | grep 'UNMET DEPENDENCY')
				if [ -n "$missing_deps" ]; then
					echo "Running npm install in $dir$npm_dir..."
					npm run build >/dev/null 2>&1
					if [ $? -eq 0 ]; then
						echo "Successfully ran npm install in $dir$npm_dir"
						NPM_INSTALL_SUCCESS_COUNT=$((NPM_INSTALL_SUCCESS_COUNT + 1))
					else
						echo "Failed to run npm install in $dir$npm_dir" >>$NPM_LOG_FILE
						NPM_INSTALL_FAIL_COUNT=$((NPM_INSTALL_FAIL_COUNT + 1))
					fi

				fi
				# check in package.json of npm_dir if there is a build script
				if grep -q '"build":' package.json; then
					echo "Running npm run build in $dir$npm_dir..."
					# if $dir ends with nx-apps, run nx build
					if [[ $dir == *nx-apps ]]; then
						nx run-many --targets=build &>/dev/null 2>&1
					else
						npm run build &>/dev/null 2>&1
					fi

					if [ $? -eq 0 ]; then
						echo "Build npm succeeded in $dir$npm_dir"
						NPM_BUILD_SUCCESS_COUNT=$((NPM_BUILD_SUCCESS_COUNT + 1))
					else
						echo "Build npm failed in $dir$npm_dir" >>$NPM_LOG_FILE
						NPM_BUILD_FAIL_COUNT=$((NPM_BUILD_FAIL_COUNT + 1))
					fi
				fi
				cd - &>/dev/null
			done
		fi

	fi

	cd - &>/dev/null
}

if [ "$IS_PATH_REPO" = "true" ]; then
	sync_repo "$TARGET_DIR"
else
	for dir in "$TARGET_DIR"/*; do
		if [ -d "$dir" ]; then
			sync_repo "$dir"
		fi
	done
fi

## if git pull fail print the log file
if [ $GIT_PULL_FAIL_COUNT -gt 0 ]; then
	echo "Git pull failed in some repositories. Check $GIT_LOG_FILE for more details."
	bat $GIT_LOG_FILE
fi

## if build fail print the log file
if [ $DOTNET_BUILD_FAIL_COUNT -gt 0 ]; then
	echo "Build failed in some repositories. Check $BUILD_DOTNET_LOG_FILE for more details."
	bat $BUILD_DOTNET_LOG_FILE
fi

# if npm install or build fail print the log file
if [ $NPM_INSTALL_FAIL_COUNT -gt 0 ] || [ $NPM_BUILD_FAIL_COUNT -gt 0 ]; then
	echo "npm install or build failed in some repositories. Check $NPM_LOG_FILE for more details."
	bat $NPM_LOG_FILE
fi

echo "Script execution completed."
echo ""
echo "Summary:"
echo "no changes: $NO_CHANGES_COUNT"
echo "git pull succeeded: $GIT_PULL_SUCCESS_COUNT"
echo "git pull failed: $GIT_PULL_FAIL_COUNT"
echo "dotnet build succeeded: $DOTNET_BUILD_SUCCESS_COUNT"
echo "dotnet build failed: $DOTNET_BUILD_FAIL_COUNT"
echo "npm install succeeded: $NPM_INSTALL_SUCCESS_COUNT"
echo "npm install failed: $NPM_INSTALL_FAIL_COUNT"
echo "npm build succeeded: $NPM_BUILD_SUCCESS_COUNT"
echo "npm build failed: $NPM_BUILD_FAIL_COUNT"
