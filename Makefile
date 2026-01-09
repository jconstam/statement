############# VARIABLES #############

CURR_PATH=$(shell pwd)
VENV_DIR=.venv
VENV_PATH=${CURR_PATH}/${VENV_DIR}
FORCE_SETUP_VENV=1
USE_EXISTING_VENV=0
TEST_IMAGE_NAME=statement_test

############# FUNCTIONS #############

define setup_venv
	$(eval $@_FORCE = $(1))
	@echo "Setting up Virtual Environment"
	@bash scripts/setup_venv.sh ${VENV_PATH} $($@_FORCE)
endef

define print_line
	@echo "========================================================================================="
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
build_test_container: examples/Dockerfile.dev_c
	@docker build --no-cache -f examples/Dockerfile.dev_c --tag ${TEST_IMAGE_NAME} examples

## run_test_container: Runs the Docker container for testing.
.PHONY: run_test_container
run_test_container:
	@docker run -it --rm --mount src="${CURR_PATH}/examples/",target=/app,type=bind --name ${TEST_IMAGE_NAME} ${TEST_IMAGE_NAME}

## build_example_basic: Builds the basic example project.
.PHONY: build_example_basic
build_example_basic:
	@echo "Building the basic example project..."
	@docker run --rm --mount src="${CURR_PATH}/examples/",target=/app,type=bind --name ${TEST_IMAGE_NAME} ${TEST_IMAGE_NAME} make -C /app/basic clobber
	@docker run --rm --mount src="${CURR_PATH}/examples/",target=/app,type=bind --name ${TEST_IMAGE_NAME} ${TEST_IMAGE_NAME} make -C /app/basic build
