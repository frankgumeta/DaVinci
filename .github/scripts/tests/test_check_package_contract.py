import importlib.util
import unittest
from pathlib import Path


SCRIPT_PATH = Path(__file__).parents[1] / "check-package-contract.py"
SPEC = importlib.util.spec_from_file_location("check_package_contract", SCRIPT_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)


def manifest(
    *,
    tools_version: str = "6.4.0",
    language_versions: list[str] | None = None,
    platform_version: str = "17.0",
) -> dict:
    return {
        "toolsVersion": {"_version": tools_version},
        "swiftLanguageVersions": language_versions or ["6"],
        "platforms": [{"platformName": "ios", "version": platform_version}],
        "products": [{"name": name} for name in sorted(MODULE.EXPECTED_PRODUCTS)],
    }


class PackageContractTests(unittest.TestCase):
    def test_expected_contract_passes(self) -> None:
        self.assertEqual(MODULE.validate_manifest(manifest()), [])

    def test_toolchain_and_deployment_drift_are_reported(self) -> None:
        failures = MODULE.validate_manifest(
            manifest(tools_version="6.3.0", platform_version="18.0")
        )
        self.assertEqual(len(failures), 2)
        self.assertIn("Swift tools 6.4.0", failures[0])
        self.assertIn("iOS 17.0", failures[1])

    def test_public_product_drift_is_reported(self) -> None:
        value = manifest()
        value["products"] = value["products"][:-1]
        failures = MODULE.validate_manifest(value)
        self.assertEqual(len(failures), 1)
        self.assertIn("public products", failures[0])


if __name__ == "__main__":
    unittest.main()
