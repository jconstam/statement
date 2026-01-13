############# VARIABLES #############

CURR_PATH=$(shell pwd)
BUILD_PATH=${CURR_PATH}/build

############# FUNCTIONS #############

############# TARGETS #############

## help: Displays all available build targets.
help: Makefile
	@echo
	@echo " Choose a command:"
	@echo
	@sed -n 's/^## //p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## build: Builds the project.
.PHONY: build
build:
	@echo "Building the project..."
	mkdir -p ${BUILD_PATH}
	cd ${BUILD_PATH} && cmake ../ && $(MAKE)

## clean: Cleans the build artifacts.
.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	cd ${BUILD_PATH} && $(MAKE) clean

## clobber: Cleans all build artifacts and temporary files.
.PHONY: clobber
clobber:
	@echo "Clobbering all build artifacts and temporary files..."
	rm -rf ${BUILD_PATH}
