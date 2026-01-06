#!/usr/bin/python3

#!/usr/bin/env python3

# System modules
import os
import argparse

# Installed modules

# Local modules


class StatementParams:
    def _path_t(self, value_string: str) -> str:
        if not os.path.exists(value_string):
            raise argparse.ArgumentError(None, f'Path "{value_string}" not found')
        return value_string

    def _validate_path(self, file_name: str) -> None:
        if not os.path.exists(file_name):
            raise argparse.ArgumentError(None, f'Path "{file_name}" not found')

    def __init__(self, raw_args: list) -> None:
        parser = argparse.ArgumentParser(
            description="STATEMENT\nState Machine Generator"
        )
        parser.add_argument(
            "-f",
            "--config_file",
            type=self._path_t,
            required=True,
            help="Configuration file containing the definition of the state machine",
        )

        # This does seem a bit obtuse.
        # First we convert the namespace we get from argparse to a dictionary using the vars method.
        # Then we use that dictionary to update the class namespace.
        # There doesn't seem to be a way to do this directly.
        self.__dict__.update(vars(parser.parse_args(raw_args)))

        self._validate_path(self.config_file)
