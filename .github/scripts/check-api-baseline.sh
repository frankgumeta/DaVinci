#!/bin/bash

set -euo pipefail

mode="${1:---check}"
case "$mode" in
    --check|--update) ;;
    *)
        echo "Usage: $0 [--check|--update]" >&2
        exit 2
        ;;
esac

root="$(cd "$(dirname "$0")/../.." && pwd)"
products_dir="${DAVINCI_PRODUCTS_DIR:-$root/.build/Build/Products/Debug-iphonesimulator}"
baseline_dir="$root/.github/api-baselines/1.4.0"
sdk="$(xcrun --sdk iphonesimulator --show-sdk-path)"
target="arm64-apple-ios17.0-simulator"
modules=(DaVinciTokens DaVinciComponents DaVinciGallery)
temporary_dir="$(mktemp -d)"
trap 'rm -rf "$temporary_dir"' EXIT

if [[ ! -d "$products_dir" ]]; then
    echo "Built products not found at $products_dir" >&2
    echo "Build DaVinci-Package for a generic iOS Simulator first." >&2
    exit 1
fi

mkdir -p "$baseline_dir"

for module in "${modules[@]}"; do
    current="$temporary_dir/$module.json"
    baseline="$baseline_dir/$module.json"

    xcrun swift-api-digester \
        -dump-sdk \
        -module "$module" \
        -I "$products_dir" \
        -sdk "$sdk" \
        -target "$target" \
        -swift-version 6 \
        -swift-only \
        -avoid-location \
        -avoid-tool-args \
        -o "$current"

    if [[ "$mode" == "--update" ]]; then
        cp "$current" "$baseline"
        echo "Updated API baseline for $module"
        continue
    fi

    if [[ ! -f "$baseline" ]]; then
        echo "Missing API baseline: $baseline" >&2
        exit 1
    fi

    diagnostics="$temporary_dir/$module-diagnostics.txt"
    xcrun swift-api-digester \
        -diagnose-sdk \
        -input-paths "$baseline" \
        -input-paths "$current" \
        -swift-only \
        -print-module \
        -compiler-style-diags > "$diagnostics" 2>&1

    if sed '/^\/\*/d; /^[[:space:]]*$/d' "$diagnostics" | grep -q .; then
        echo "Breaking public API changes detected in $module:" >&2
        cat "$diagnostics" >&2
        exit 1
    fi
    echo "API baseline passed for $module"
done
