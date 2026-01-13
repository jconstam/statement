############# VARIABLES #############

BASIC_EXAMPLE_PATH=${EXAMPLES_PATH}/basic
BASIC_EXAMPLE_CONTAINER_PATH=${CONTAINER_APP_DIR}/basic
TEST_IMAGE_NAME=statement_test
TEST_CONTAINER_NAME=jconstam/statement-dev-c
CONTAINER_APP_DIR=/app

############# FUNCTIONS #############

define run_in_docker
	@docker run --rm --mount src="${CURR_PATH}/examples/",target=${CONTAINER_APP_DIR},type=bind --workdir ${1} --name ${TEST_IMAGE_NAME} ${TEST_CONTAINER_NAME} "${2}"
endef

############# CONTAINER TARGETS #############

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

############# COMPOSITE TARGETS #############

## build_examples: Builds all example projects.
.PHONY: build_examples
build_examples: build_example_basic

## clean_examples: Cleans all example projects.
.PHONY: clean_examples
clean_examples: clean_example_basic

## clobber_examples: Clobbers all example projects.
.PHONY: clobber_examples
clobber_examples: clobber_example_basic

## unit_test_examples: Unit tests all example projects.
.PHONY: unit_test_examples
unit_test_examples: unit_test_example_basic

## validate_unit_test_coverage_examples: Validates unit test coverage for all example projects.
.PHONY: validate_unit_test_coverage_examples
validate_unit_test_coverage_examples: validate_unit_test_coverage_example_basic

## cppcheck_examples: Runs cppcheck on all example projects.
.PHONY: cppcheck_examples
cppcheck_examples: cppcheck_example_basic

## clangtidy_examples: Runs clang-tidy on all example projects.
.PHONY: clangtidy_examples
clangtidy_examples: clangtidy_example_basic

############# BASIC EXAMPLE TARGETS #############

## build_example_basic: Builds the basic example project.
.PHONY: build_example_basic
build_example_basic:
	@$(call print_line)
	@echo "Building the basic example project..."
	@$(call run_in_docker,${BASIC_EXAMPLE_CONTAINER_PATH},"make build")

## clean_example_basic: Cleans the basic example project.
.PHONY: clean_example_basic
clean_example_basic:
	@echo "Cleaning the basic example project..."
	@$(call run_in_docker,${BASIC_EXAMPLE_CONTAINER_PATH},"make clean")

## clobber_example_basic: Clobbers the basic example project.
.PHONY: clobber_example_basic
clobber_example_basic:
	@echo "Clobbering the basic example project..."
	@$(call run_in_docker,${BASIC_EXAMPLE_CONTAINER_PATH},"make clobber")

## unit_test_example_basic: Builds the basic example project.
.PHONY: unit_test_example_basic
unit_test_example_basic:
	@$(call print_line)
	@echo "Unit testing the basic example project..."
	@$(call run_in_docker,${BASIC_EXAMPLE_CONTAINER_PATH},"ceedling clobber gcov:all")

## validate_unit_test_coverage_example_basic: Validates the unit test coverage of the basic example project.
.PHONY: validate_unit_test_coverage_example_basic
validate_unit_test_coverage_example_basic:
	@$(call print_line)
	@bash ${SCRIPTS_PATH}/check_xml_field.sh examples/basic/build_tests/artifacts/gcov/gcovr/coverage.xml "coverage.linerate" "1.0"
	@bash ${SCRIPTS_PATH}/check_xml_field.sh examples/basic/build_tests/artifacts/gcov/gcovr/coverage.xml "coverage.branchrate" "1.0"

## cppcheck_example_basic: Runs cppcheck on the basic example project.
.PHONY: cppcheck_example_basic
cppcheck_example_basic:
	@$(call print_line)
	@echo "Running cppcheck on the basic example project..."
	@bash ${SCRIPTS_PATH}/run_cppcheck.sh ./examples/basic/

## clangtidy_example_basic: Runs clang-tidy on the basic example project.
.PHONY: clangtidy_example_basic
clangtidy_example_basic:
	@$(call print_line)
	@echo "Running clang-tidy on the basic example project..."
	@bash ${SCRIPTS_PATH}/run_clangtidy.sh ${CURR_PATH} ${SCRIPTS_PATH}/.clang-tidy ${BASIC_EXAMPLE_PATH}

############# END OF FILE #############
