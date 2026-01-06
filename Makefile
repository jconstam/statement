############# VARIABLES #############

VENV_DIR=.venv
VENV_PATH=$(shell pwd)/${VENV_DIR}
FORCE_SETUP_VENV=1
USE_EXISTING_VENV=0

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

## lint: Runs the linter.
.PHONY: lint
lint: format
	@echo "Running linter..."
	@ruff check --fix

## format: Formats the code.
.PHONY: format
format:
	@echo "Formatting code..."
	@ruff format

## lint_for_ci: Runs the linter without fixing anything for CI.
.PHONY: lint_for_ci
lint_for_ci:
	@echo "Running linter..."
	@ruff check

## format_for_ci: Runs the formatter without fixing anything for CI.
.PHONY: format_for_ci
format_for_ci:
	@echo "Running linter..."
	@ruff format --check
