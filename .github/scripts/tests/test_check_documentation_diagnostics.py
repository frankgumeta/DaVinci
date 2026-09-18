import json
import tempfile
import unittest
from pathlib import Path

import importlib.util


MODULE_PATH = Path(__file__).parents[1] / "check-documentation-diagnostics.py"
MODULE_SPEC = importlib.util.spec_from_file_location("check_documentation_diagnostics", MODULE_PATH)
assert MODULE_SPEC is not None and MODULE_SPEC.loader is not None
check_documentation_diagnostics = importlib.util.module_from_spec(MODULE_SPEC)
MODULE_SPEC.loader.exec_module(check_documentation_diagnostics)


class DocumentationDiagnosticsTests(unittest.TestCase):
    def write_payload(self, root: Path, diagnostics: list[dict]) -> None:
        path = root / "Build" / "Intermediates" / "DaVinciComponents-diagnostics.json"
        path.parent.mkdir(parents=True)
        path.write_text(json.dumps({"diagnostics": diagnostics}), encoding="utf-8")

    def test_own_warning_fails(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.write_payload(
                root,
                [
                    {
                        "severity": "warning",
                        "source": "file:///repo/Sources/DaVinciComponents/DSButton.swift",
                        "summary": "unresolved topic",
                        "range": {"start": {"line": 12}},
                    }
                ],
            )
            self.assertEqual(check_documentation_diagnostics.owned_failures(root), [
                "/repo/Sources/DaVinciComponents/DSButton.swift:12: warning: unresolved topic"
            ])

    def test_external_warning_is_allowed(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.write_payload(
                root,
                [
                    {
                        "severity": "warning",
                        "source": "file:///repo/.build/SwiftUI.swift",
                        "summary": "SDK diagnostic",
                    }
                ],
            )
            self.assertEqual(check_documentation_diagnostics.owned_failures(root), [])

    def test_own_note_is_allowed(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.write_payload(
                root,
                [
                    {
                        "severity": "note",
                        "source": "file:///repo/Sources/DaVinciComponents/DSButton.swift",
                        "summary": "informational",
                    }
                ],
            )
            self.assertEqual(check_documentation_diagnostics.owned_failures(root), [])


if __name__ == "__main__":
    unittest.main()
