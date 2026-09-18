import importlib.util
import unittest
from pathlib import Path


SCRIPT_PATH = Path(__file__).parents[1] / "list-snapshot-test-suites.py"
SPEC = importlib.util.spec_from_file_location("list_snapshot_test_suites", SCRIPT_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)


class SnapshotSuiteDiscoveryTests(unittest.TestCase):
    def test_discovers_multiple_suites_in_one_file(self):
        source = """
        struct DSSurfaceSnapshotTests {}
        struct DSActivityIndicatorSnapshotTests {}
        """

        self.assertEqual(
            MODULE.suites_in(source),
            ["DSSurfaceSnapshotTests", "DSActivityIndicatorSnapshotTests"],
        )

    def test_uses_declared_suite_instead_of_file_name(self):
        source = "struct DSListRowSnapshotTests {}"

        self.assertEqual(MODULE.suites_in(source), ["DSListRowSnapshotTests"])

    def test_ignores_non_snapshot_types(self):
        self.assertEqual(MODULE.suites_in("struct DSListRowTests {}"), [])


if __name__ == "__main__":
    unittest.main()
