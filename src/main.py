#!/usr/bin/python3

# System modules
import sys

# Installed modules

# Local modules
from statement.params import StatementParams


def zeus_main(cli_args: list) -> None:
    StatementParams(cli_args)


if __name__ == "__main__":
    try:
        zeus_main(sys.argv[1:])
    except Exception as ex:
        # @todo Improve
        raise ex
