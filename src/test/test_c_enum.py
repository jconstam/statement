#!/usr/bin/env python3

# System modules

# Installed modules
import pytest

# Local modules
from statement.c_data import CData, CEnum, CStruct, NoValuesError, NoFieldsError

# Test modules


class TestCData:
    def test_item_to_string_not_implemented(self) -> None:
        cdata = CData("mod", "name", True)
        with pytest.raises(NotImplementedError) as exc_info:
            _ = cdata._items_to_strings()
        assert str(exc_info.value) == "Subclasses must implement _items_to_strings method."

    def test_to_string_not_implemented(self) -> None:
        cdata = CData("mod", "name", True)
        with pytest.raises(NotImplementedError) as exc_info:
            _ = cdata.to_string()
        assert str(exc_info.value) == "Subclasses must implement to_string method."


class TestCEnum:
    def test_no_values_error(self) -> None:
        enum = CEnum("testmodule", "testenum")
        with pytest.raises(NoValuesError) as exc_info:
            _ = enum.to_string()
        assert str(exc_info.value) == 'Cannot generate enum testenum with no values.  Use "add_data" to add values first.'

    def test_singleton(self) -> None:
        enum = CEnum("mymodule", "myenum")
        enum.add_data("value1")
        expected_str = "typedef enum MYMODULE_MYENUM\n{\n    MYMODULE_MYENUM__VALUE1,\n\n    MYMODULE_MYENUM__COUNT\n} mymodule_myenum_t;\n"
        assert enum.to_string() == expected_str

    def test_multiple_values(self) -> None:
        enum = CEnum("testmod", "testenum")
        enum.add_data("first")
        enum.add_data("second")
        enum.add_data("third")
        expected_str = (
            "typedef enum TESTMOD_TESTENUM\n"
            "{\n"
            "    TESTMOD_TESTENUM__FIRST,\n"
            "    TESTMOD_TESTENUM__SECOND,\n"
            "    TESTMOD_TESTENUM__THIRD,\n"
            "\n"
            "    TESTMOD_TESTENUM__COUNT\n"
            "} testmod_testenum_t;\n"
        )
        assert enum.to_string() == expected_str


class TestCStruct:
    def test_no_fields_error(self) -> None:
        struct = CStruct("testmodule", "teststruct")
        with pytest.raises(NoFieldsError) as exc_info:
            _ = struct.to_string()
        assert str(exc_info.value) == 'Cannot generate struct teststruct with no fields.  Use "add_field" to add fields first.'

    def test_single_field(self) -> None:
        struct = CStruct("mymodule", "mystruct")
        struct.add_field("int", "field1")
        expected_str = "typedef struct\n{\n    int field1;\n} mymodule_mystruct_t;\n"
        assert struct.to_string() == expected_str

    def test_multiple_fields(self) -> None:
        struct = CStruct("testmod", "teststruct")
        struct.add_field("int", "field1")
        struct.add_field("float", "field2")
        struct.add_field("char*", "field3")
        expected_str = "typedef struct\n{\n    int field1;\n    float field2;\n    char* field3;\n} testmod_teststruct_t;\n"
        assert struct.to_string() == expected_str
