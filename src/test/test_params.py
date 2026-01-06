#!/usr/bin/env python3

# System modules

# Installed modules
import pytest

# Local modules
from statement.params import StatementParams

# Test modules


class TestParams:
    def test_constructor_empty_args(self) -> None:
        with pytest.raises(SystemExit):
            StatementParams([])
