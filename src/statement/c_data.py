#!/usr/bin/env python3

# System modules

# Installed modules

# Local modules


class NoItemsError(Exception):
    pass


class CData:
    INDENT_STRING = "    "

    def __init__(self, module_name: str, name: str, capitalize: bool) -> None:
        self._module_name: str = module_name
        self._name: str = name
        self._capitalize: bool = capitalize
        self._items: list = []

    @property
    def preamble(self) -> str:
        if self._capitalize:
            return f"{self._module_name.upper()}_{self._name.upper()}"
        else:
            return f"{self._module_name.lower()}_{self._name.lower()}"

    def _print(self, pre_items_lines: list[tuple[str, int]], post_items_lines: list[tuple[str, int]]) -> str:
        output = ""
        for line, indent_count in pre_items_lines:
            output += f"{self.INDENT_STRING * indent_count}{line}\n"
        for item in self._items_to_strings():
            output += f"{self.INDENT_STRING}{item}\n"
        for line, indent_count in post_items_lines:
            output += f"{self.INDENT_STRING * indent_count}{line}\n"
        return output

    def add_data(self, data: object) -> None:
        self._items.append(data)

    def _items_to_strings(self) -> list[str]:
        raise NotImplementedError("Subclasses must implement _items_to_strings method.")

    def to_string(self) -> str:
        raise NotImplementedError("Subclasses must implement to_string method.")


class CEnum(CData):
    def __init__(self, module_name: str, enum_name: str) -> None:
        super().__init__(module_name, enum_name, True)

    def _items_to_strings(self) -> list[str]:
        return [f"{self.preamble}__{str(item).upper()}," for item in self._items]

    def to_string(self) -> str:
        if not self._items:
            raise NoItemsError(f'Cannot generate enum {self._name} with no values.  Use "add_data" to add values first.')
        return self._print([(f"typedef enum {self.preamble}", 0), ("{", 0)], [("", 0), (f"{self.preamble}__COUNT", 1), (f"}} {self.preamble.lower()}_t;", 0)])


class CStruct(CData):
    def __init__(self, module_name: str, struct_name: str) -> None:
        super().__init__(module_name, struct_name, False)

    def add_field(self, field_type: str, field_name: str) -> None:
        self.add_data((field_type, field_name))

    def _items_to_strings(self) -> list[str]:
        return [f"{field_type} {field_name};" for field_type, field_name in self._items]

    def to_string(self) -> str:
        if not self._items:
            raise NoItemsError(f'Cannot generate struct {self._name} with no fields.  Use "add_field" to add fields first.')
        return self._print([("typedef struct", 0), ("{", 0)], [(f"}} {self.preamble}_t;", 0)])
