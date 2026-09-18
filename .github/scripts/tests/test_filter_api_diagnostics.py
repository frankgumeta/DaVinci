import importlib.util
import unittest
from pathlib import Path


SCRIPT_PATH = Path(__file__).parents[1] / "filter-api-diagnostics.py"
SPEC = importlib.util.spec_from_file_location("filter_api_diagnostics", SCRIPT_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)


def document(*, external: bool, conformances: list[str]) -> dict:
    return {
        "kind": "Root",
        "children": [
            {
                "kind": "TypeDecl",
                "name": "EnvironmentValues",
                "moduleName": "SwiftUICore" if external else "DaVinciTokens",
                "isExternal": external,
                "conformances": [
                    {"kind": "Conformance", "name": name}
                    for name in conformances
                ],
            }
        ],
    }


class APIDiagnosticFilteringTests(unittest.TestCase):
    def test_filters_verified_environment_values_sdk_delta(self):
        diagnostic = (
            "API breakage: extension EnvironmentValues has removed conformance "
            "to Sendable\n"
        )
        filtered, ignored = MODULE.filter_diagnostics(
            diagnostic,
            document(external=True, conformances=["Sendable"]),
            document(external=True, conformances=[]),
        )

        self.assertEqual(filtered, "")
        self.assertEqual(ignored, [diagnostic.rstrip()])

    def test_does_not_filter_davinci_owned_type_change(self):
        diagnostic = (
            "API breakage: extension EnvironmentValues has removed conformance "
            "to Sendable\n"
        )
        filtered, ignored = MODULE.filter_diagnostics(
            diagnostic,
            document(external=False, conformances=["Sendable"]),
            document(external=False, conformances=[]),
        )

        self.assertEqual(filtered, diagnostic)
        self.assertEqual(ignored, [])

    def test_preserves_other_breaking_changes(self):
        diagnostic = "API breakage: struct DSTheme has been removed\n"
        filtered, ignored = MODULE.filter_diagnostics(
            diagnostic,
            document(external=True, conformances=["Sendable"]),
            document(external=True, conformances=[]),
        )

        self.assertEqual(filtered, diagnostic)
        self.assertEqual(ignored, [])


if __name__ == "__main__":
    unittest.main()
