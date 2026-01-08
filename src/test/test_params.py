#!/usr/bin/env python3

# System modules
from unittest import mock

# Installed modules
import pytest

# Local modules
from statement.params import StatementParams

# Test modules


class TestParams:
    TEST_FILE_NAME = "invalid_config_file_1234"

    @staticmethod
    def _check_stdout_stderr(capsys: pytest.CaptureFixture[str], out_msg: str = "", err_msg: str = "") -> None:
        captured = capsys.readouterr()

        if err_msg:
            assert "usage: pytest [-h] -f CONFIG_FILE" in captured.err
            assert err_msg in captured.err
        else:
            assert captured.err == ""

        if out_msg:
            assert out_msg in captured.out
        else:
            assert captured.out == ""

    def test_constructor_empty_args(self, capsys: pytest.CaptureFixture[str]) -> None:
        with pytest.raises(SystemExit):
            StatementParams([])
        TestParams._check_stdout_stderr(capsys, err_msg="error: the following arguments are required: -f/--config_file")

    @mock.patch("os.path.exists")
    def test_config_file_not_found(self, mock_exists: mock.MagicMock, capsys: pytest.CaptureFixture[str]) -> None:
        mock_exists.return_value = False
        with pytest.raises(SystemExit):
            StatementParams(["-f", self.TEST_FILE_NAME])
        TestParams._check_stdout_stderr(capsys, err_msg=f'Path "{self.TEST_FILE_NAME}" not found')

    @mock.patch("os.path.exists")
    def test_valid_config_file(self, mock_exists: mock.MagicMock, capsys: pytest.CaptureFixture[str]) -> None:
        mock_exists.return_value = True
        StatementParams(["-f", self.TEST_FILE_NAME])
        TestParams._check_stdout_stderr(capsys)
