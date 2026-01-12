############# VARIABLES #############

CURR_PATH=$(shell pwd)
VENV_DIR=.venv
VENV_PATH=${CURR_PATH}/${VENV_DIR}
FORCE_SETUP_VENV=1
USE_EXISTING_VENV=0
TEST_IMAGE_NAME=statement_test
TEST_CONTAINER_NAME=jconstam/statement-dev-c
CONTAINER_APP_DIR=/app
BASIC_EXAMPLE_DIR=${CONTAINER_APP_DIR}/basic

############# FUNCTIONS #############

define setup_venv
	$(eval $@_FORCE = $(1))
	@echo "Setting up Virtual Environment"
	@bash scripts/setup_venv.sh ${VENV_PATH} $($@_FORCE)
endef

define print_line1
	@echo "========================================================================================="
endef

define run_in_docker
	@docker run --rm --mount src="${CURR_PATH}/examples/",target=${CONTAINER_APP_DIR},type=bind --workdir ${1} --name ${TEST_IMAGE_NAME} ${TEST_CONTAINER_NAME} "${2}"
endef

############# TARGETS #############

## help: Displays all available build targets.
help: Makefile
	@echo
	@echo " Choose a command:"
	@echo
	@sed -n 's/^## //p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo

## setup_venv: Sets up the Python virtual environment.
.PHONY: setup_venv
setup_venv:
	@$(call setup_venv,${USE_EXISTING_VENV})

## setup_venv_force: Sets up the Python virtual environment, forcing re-creation.
.PHONY: setup_venv_force
setup_venv_force:
	@$(call setup_venv,${FORCE_SETUP_VENV})

## delete_venv: Deletes the Python virtual environment.
.PHONY: delete_venv
delete_venv:
	@echo "Deleting virtual environment"
	@rm -rf ${VENV_PATH}

## check_eof_newlines: Checks that all non-hidden files end with a newline.
.PHONY: check_eof_newlines
check_eof_newlines:
	@echo "Checking for EOF newlines..."
	@bash scripts/check_eof_newlines.sh ./

## lint_python : Runs the linter.
.PHONY: lint_python
lint_python : format_python
	@echo "Running Python linter..."
	@ruff check --fix

## format_python: Formats the code.
.PHONY: format_python
format_python:
	@echo "Formatting Python code..."
	@ruff format --line-length 160

## lint_python_ci: Runs the linter without fixing anything for CI.
.PHONY: lint_python_ci
lint_python_ci:
	@$(call print_line)
	@echo "Running Python linter (no fixes)..."
	@ruff check

## format_python_ci: Runs the formatter without fixing anything for CI.
.PHONY: format_python_ci
format_python_ci:
	@$(call print_line)
	@echo "Running Python formatter (no fixes)..."
	@ruff format --check --line-length 160

## lint_bash: Runs the linter to check code style and quality.
.PHONY: lint_bash
lint_bash:
	@$(call print_line)
	@echo "Running Bash linter..."
	@shellcheck --color=always --external-sources --shell=bash --severity=style scripts/*.sh

## type_check_python: Runs the type checker to validate type annotations.
.PHONY: type_check_python
type_check_python:
	@$(call print_line)
	@echo "Running Python type checker..."
	@mypy src/*.py src/statement/*.py src/test/*.py --warn-redundant-casts --warn-unused-ignores --warn-unreachable --disallow-untyped-defs \
		--disallow-incomplete-defs  --disallow-untyped-decorators --disallow-redefinition --disallow-untyped-globals --disable-error-code=method-assign \
    	--follow-untyped-imports --check-untyped-defs --strict-equality

## test_python: Runs the unit tests to validate code functionality.
.PHONY: test_python
test_python:
	@$(call print_line)
	@echo "Running unit tests..."
	@pytest --cache-clear --cov-report term --cov-report html:.pytest_cov_html --cov=statement  src/test

## test_ci: Runs all CI tests including linters, type checker, and unit tests.
.PHONY: test_ci
test_ci: check_eof_newlines format_python_ci lint_python_ci lint_bash type_check_python test_python
	@$(call print_line)
	@echo "All tests passed!"
	@$(call print_line)

## build_test_container: Builds the Docker container for testing.
.PHONY: build_test_container
build_test_container:
	@docker build --no-cache -f examples/Dockerfile.dev_c --tag ${TEST_CONTAINER_NAME} examples

## push_test_container: Pushes the Docker container for testing to Docker Hub.
.PHONY: push_test_container
push_test_container: build_test_container
	@docker push ${TEST_CONTAINER_NAME}:latest

## pull_test_container: Pulls the Docker container for testing from Docker Hub.
.PHONY: pull_test_container
pull_test_container:
	@docker pull ${TEST_CONTAINER_NAME}:latest

## run_test_container: Runs the Docker container for testing.
.PHONY: run_test_container
run_test_container:
	@docker run -it --rm --mount src="${CURR_PATH}/examples/",target=${CONTAINER_APP_DIR},type=bind --name ${TEST_IMAGE_NAME} ${TEST_CONTAINER_NAME}

## delete_test_container: Deletes the Docker container for testing.
.PHONY: delete_test_container
delete_test_container:
	@docker rmi ${TEST_CONTAINER_NAME} || true
	@docker system prune --force

## build_examples: Builds all example projects.
.PHONY: build_examples
build_examples: build_example_basic

## clean_examples: Cleans all example projects.
.PHONY: clean_examples
clean_examples: clean_example_basic

## clobber_examples: Clobbers all example projects.
.PHONY: clobber_examples
clobber_examples: clobber_example_basic

## build_example_basic: Builds the basic example project.
.PHONY: build_example_basic
build_example_basic:
	@echo "Building the basic example project..."
	@$(call run_in_docker,${BASIC_EXAMPLE_DIR},"make build")

## clean_example_basic: Cleans the basic example project.
.PHONY: clean_example_basic
clean_example_basic:
	@echo "Cleaning the basic example project..."
	@$(call run_in_docker,${BASIC_EXAMPLE_DIR},"make clean")

## clobber_example_basic: Clobbers the basic example project.
.PHONY: clobber_example_basic
clobber_example_basic:
	@echo "Clobbering the basic example project..."
	@$(call run_in_docker,${BASIC_EXAMPLE_DIR},"make clobber")

## unit_test_example_basic: Builds the basic example project.
.PHONY: unit_test_example_basic
unit_test_example_basic:
	@echo "Unit testing the basic example project..."
	@$(call run_in_docker,${BASIC_EXAMPLE_DIR},"ceedling clobber gcov:all")

## validate_unit_test_coverage_example_basic: Validates the unit test coverage of the basic example project.
.PHONY: validate_unit_test_coverage_example_basic
validate_unit_test_coverage_example_basic:
	@bash ./scripts/check_xml_field.sh examples/basic/build_tests/artifacts/gcov/gcovr/coverage.xml "coverage.linerate" "1.0"
	@bash ./scripts/check_xml_field.sh examples/basic/build_tests/artifacts/gcov/gcovr/coverage.xml "coverage.branchrate" "1.0"

