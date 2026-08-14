import importlib.util
import unittest
from pathlib import Path


SCRIPT_PATH = Path(__file__).parents[1] / "select-ios-simulator.py"
SPEC = importlib.util.spec_from_file_location("select_ios_simulator", SCRIPT_PATH)
MODULE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(MODULE)


def runtime(version, devices, available=True):
    return {
        "identifier": f"com.apple.CoreSimulator.SimRuntime.iOS-{version.replace('.', '-')}",
        "name": f"iOS {version}",
        "version": version,
        "platform": "iOS",
        "isAvailable": available,
        "supportedDeviceTypes": devices,
    }


def iphone(name):
    return {
        "identifier": f"com.apple.CoreSimulator.SimDeviceType.{name.replace(' ', '-')}",
        "name": name,
        "productFamily": "iPhone",
    }


class SimulatorSelectionTests(unittest.TestCase):
    def test_latest_selects_newest_available_runtime(self):
        data = {
            "runtimes": [
                runtime("17.5", [iphone("iPhone 15")]),
                runtime("26.1", [iphone("iPhone 17 Pro")]),
                runtime("27.0", [iphone("iPhone 17 Pro")], available=False),
            ]
        }

        selected = MODULE.select_runtime(data, None)

        self.assertEqual(selected["version"], "26.1")

    def test_major_selects_newest_matching_minor(self):
        data = {
            "runtimes": [
                runtime("17.4", [iphone("iPhone 15")]),
                runtime("17.5", [iphone("iPhone 15 Pro")]),
                runtime("26.1", [iphone("iPhone 17 Pro")]),
            ]
        }

        selected = MODULE.select_runtime(data, 17)

        self.assertEqual(selected["version"], "17.5")

    def test_device_is_selected_from_runtime_compatibility_list(self):
        selected_runtime = runtime(
            "17.5",
            [iphone("iPhone 14"), iphone("iPhone 15 Pro")],
        )

        selected = MODULE.select_device_type(selected_runtime)

        self.assertEqual(selected["name"], "iPhone 15 Pro")

    def test_missing_requested_runtime_fails_clearly(self):
        with self.assertRaisesRegex(ValueError, "No available iOS 17"):
            MODULE.select_runtime({"runtimes": []}, 17)


if __name__ == "__main__":
    unittest.main()
