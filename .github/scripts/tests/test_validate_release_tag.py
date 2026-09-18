import importlib.util
import unittest
from pathlib import Path


SCRIPT_PATH = Path(__file__).parents[1] / "validate-release-tag.py"
SPEC = importlib.util.spec_from_file_location("validate_release_tag", SCRIPT_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)


class ReleaseTagTests(unittest.TestCase):
    CHANGELOG = "## [2.0.0-alpha.1]\n## [2.0.0]\n"

    def test_alpha_is_prerelease(self):
        errors, metadata = MODULE.validate("v2.0.0-alpha.1", self.CHANGELOG)
        self.assertEqual(errors, [])
        self.assertEqual(metadata["prerelease"], "true")
        self.assertEqual(metadata["channel"], "alpha")
        self.assertEqual(metadata["notes_path"], "Docs/Release-2.0.0-alpha.1.md")

    def test_stable_is_not_prerelease(self):
        errors, metadata = MODULE.validate("v2.0.0", self.CHANGELOG)
        self.assertEqual(errors, [])
        self.assertEqual(metadata["prerelease"], "false")
        self.assertEqual(metadata["channel"], "stable")

    def test_malformed_tag_fails(self):
        errors, _ = MODULE.validate("v2.0", self.CHANGELOG)
        self.assertEqual(len(errors), 1)

    def test_missing_changelog_heading_fails(self):
        errors, _ = MODULE.validate("v2.0.0-rc.1", self.CHANGELOG)
        self.assertIn("CHANGELOG.md", errors[0])


if __name__ == "__main__":
    unittest.main()
