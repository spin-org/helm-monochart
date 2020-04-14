# Usage:
# make package # Creates release binary
# make publish  # Updates index.yaml with SHA and address of package
# make clean  # Removes old release packages locally

.PHONY = all

REPO_URL=https://raw.githubusercontent.com/spin-org/helm-monochart/master
LOCALPWD = $(shell basename "$$PWD")

all: package publish

check_vars:
	@echo "Checking variables..." && \
	echo LOCALPWD = ${LOCALPWD}

package:
	@echo "Packaging monochart" && \
	helm package stable/monochart -d .

publish:
	make package
	@echo "Updating index.yaml with generated binaries" && \
	helm repo index . --url ${REPO_URL}

cleanup:
	@echo "Removing old packages locally" && \
	find . -maxdepth 1 -type f -iname "*.tgz" ! -path . ! -wholename `ls -1tp ./*.tgz | head -1` -exec echo Removing old file {} \;  -exec rm -f {} \;