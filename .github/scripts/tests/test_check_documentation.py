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
            (root / ".github").mkdir()
            (root / ".github" / "version-policy.json").write_text(
                '{"stableDependencyVersion": "1.4.0"}', encoding="utf-8"
            )
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
            (root / ".github").mkdir()
            (root / ".github" / "version-policy.json").write_text(
                '{"stableDependencyVersion": "1.4.0"}', encoding="utf-8"
            )
            (root / "README.md").write_text(
                'from: "1.4.0"\n'
                'DSText("Save", role: .titleMedium) {}\n'
                'DSTextStyle(size: 24, lineHeight: 30, weight: .bold, relativeTo: .title2)\n'
                'DSButton("Save", appearance: .primary) {}',
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

    def test_detects_removed_2_0_typography_apis(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "Docs").mkdir()
            (root / ".github").mkdir()
            (root / ".github" / "version-policy.json").write_text(
                '{"stableDependencyVersion": "1.4.0"}', encoding="utf-8"
            )
            (root / "README.md").write_text('from: "1.4.0"', encoding="utf-8")
            (root / "Docs" / "Usage.md").write_text(
                'DSText("Title", role: .title)\n'
                'theme.typography.title\n'
                '    title: DSTextStyle(size: 24, lineHeight: 30, weight: .bold, relativeTo: .title)\n',
                encoding="utf-8",
            )

            failures = MODULE.find_removed_api_references(root)

            self.assertEqual(len(failures), 3)
            self.assertIn("removed text title role", failures[0])
            self.assertIn("removed title typography member", failures[1])
            self.assertIn("removed title typography initializer", failures[2])

    def test_migration_guide_can_reference_removed_apis(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "Docs").mkdir()
            (root / "Docs" / "Migration-2.0.md").write_text(
                'DSText("Title", role: .title)\n'
                'theme.typography.title\n',
                encoding="utf-8",
            )

            self.assertEqual(MODULE.find_removed_api_references(root), [])


if __name__ == "__main__":
    unittest.main()
