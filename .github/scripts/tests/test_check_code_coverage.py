import importlib.util
import unittest
from pathlib import Path


SCRIPT_PATH = Path(__file__).parents[1] / "check-code-coverage.py"
SPEC = importlib.util.spec_from_file_location("check_code_coverage", SCRIPT_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)


class ProductionLineTotalsTests(unittest.TestCase):
    def test_excludes_dedicated_preview_sources(self):
        target = {
            "coveredLines": 90,
            "executableLines": 120,
            "files": [
                {"name": "DSButton.swift", "coveredLines": 90, "executableLines": 90},
                {"name": "DSButton+Previews.swift", "coveredLines": 0, "executableLines": 30},
            ],
        }

        self.assertEqual(MODULE.production_line_totals(target), (90, 90))

    def test_does_not_exclude_similarly_named_production_sources(self):
        target = {
            "files": [
                {"name": "PreviewCoordinator.swift", "coveredLines": 8, "executableLines": 10},
                {"name": "CardPreview.swift", "coveredLines": 7, "executableLines": 10},
            ]
        }

        self.assertEqual(MODULE.production_line_totals(target), (15, 20))

    def test_falls_back_to_target_totals_when_files_are_unavailable(self):
        target = {"coveredLines": 95, "executableLines": 100}

        self.assertEqual(MODULE.production_line_totals(target), (95, 100))


class MarkdownReportTests(unittest.TestCase):
    def test_threshold_uses_production_totals(self):
        targets = [
            {
                "name": "DaVinciComponents",
                "coveredLines": 95,
                "executableLines": 120,
                "files": [
                    {"name": "Component.swift", "coveredLines": 95, "executableLines": 100},
                    {"name": "Component+Previews.swift", "coveredLines": 0, "executableLines": 20},
                ],
            }
        ]

        markdown, passed = MODULE.markdown_report(
            targets,
            {"DaVinciComponents": 95},
        )

        self.assertTrue(passed)
        self.assertIn("| DaVinciComponents | 95 | 100 | 95.00%", markdown)


if __name__ == "__main__":
    unittest.main()
