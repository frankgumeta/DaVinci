import importlib.util
import tempfile
import unittest
from pathlib import Path


SCRIPT_PATH = Path(__file__).parents[1] / "check-documentation.py"
SPEC = importlib.util.spec_from_file_location("check_documentation", SCRIPT_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)


class DocumentationValidationTests(unittest.TestCase):
    def test_detects_removed_api_in_nested_docs(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "Docs").mkdir()
            (root / "README.md").write_text('from: "1.4.0"', encoding="utf-8")
            (root / "Docs" / "Usage.md").write_text(
                'DSIconButton(systemName: "trash") {}', encoding="utf-8"
            )

            failures = MODULE.find_removed_api_references(root)

            self.assertEqual(len(failures), 1)
            self.assertIn("raw systemName", failures[0])

    def test_current_api_examples_pass(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "Docs").mkdir()
            (root / "README.md").write_text(
                'from: "1.4.0"\nDSButton("Save", appearance: .primary) {}',
                encoding="utf-8",
            )
            (root / "ACCESSIBILITY.md").write_text(
                'DSIconButton(symbol: trash, titleForAccessibility: "Delete") {}',
                encoding="utf-8",
            )
            (root / "CONTRIBUTING.md").write_text("Appearance", encoding="utf-8")

            failures = (
                MODULE.find_removed_api_references(root)
                + MODULE.validate_release_floor(root)
            )

            self.assertEqual(failures, [])


if __name__ == "__main__":
    unittest.main()
