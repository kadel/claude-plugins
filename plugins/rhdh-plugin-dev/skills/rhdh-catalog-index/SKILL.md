---
name: rhdh-catalog-index
description: Extract and inspect the RHDH plugin catalog index OCI image to discover available plugins, their OCI artifact references, versions, and default wiring configurations. Use when you need to find plugin package names, versions, pluginConfig examples, or create a dynamic-plugins.yaml from the catalog.
---

# RHDH Plugin Catalog Index Extraction

Use this skill to extract plugin information from the RHDH plugin catalog index OCI image (`quay.io/rhdh/plugin-catalog-index`).

## Prerequisites

- `skopeo` must be installed and available in PATH
- `python3` with `json` and `base64` modules (standard library)

## Step 1: Determine the Catalog Index Tag

The tag matches the RHDH version from `package.json` in the rhdh repo:

```bash
TAG=$(jq -r '.version' package.json)
# e.g. 1.10.0
```

The full image reference is `quay.io/rhdh/plugin-catalog-index:${TAG}`.

## Step 2: Download and Extract the Image

```bash
TMPDIR=$(mktemp -d)
EXTRACT_DIR="${TMPDIR}/extracted"
mkdir -p "$EXTRACT_DIR"

# Download (must override os/arch since it's a linux/amd64 image)
skopeo copy --override-os=linux --override-arch=amd64 \
  "docker://quay.io/rhdh/plugin-catalog-index:${TAG}" \
  "dir:${TMPDIR}/catalog-index"

# Extract all layers
for blob in "${TMPDIR}/catalog-index/"*; do
  [ -f "$blob" ] && tar -xf "$blob" -C "$EXTRACT_DIR" 2>/dev/null || true
done
```

## Step 3: Inspect Extracted Contents

After extraction, the key files are:

```
${EXTRACT_DIR}/
├── dynamic-plugins.default.yaml    # Default plugin list (bundled/pre-installed plugins)
└── catalog-entities/
    └── extensions/
        ├── collections/            # Plugin collection groupings
        ├── packages/               # Individual package entities (one YAML per package)
        │   ├── <plugin-name>.yaml  # Contains: dynamicArtifact, version, appConfigExamples
        │   └── ...
        └── plugins/                # Plugin entities (one YAML per plugin group)
            ├── <plugin-name>.yaml  # Contains: description, categories, highlights, spec.packages
            └── ...
```

### Key fields in package entity files (`packages/*.yaml`):

- `spec.dynamicArtifact` — Full OCI reference to use in `dynamic-plugins.yaml` `package` field
- `spec.version` — Plugin version
- `spec.backstage.role` — One of: `frontend-plugin`, `backend-plugin`, `backend-plugin-module`
- `spec.backstage.supportedVersions` — Compatible Backstage version
- `spec.appConfigExamples` — Array of example configurations including `pluginConfig` wiring
- `spec.partOf` — Plugin group name (links related frontend/backend/modules together)

### Finding a specific plugin:

```bash
# List all available packages
ls "${EXTRACT_DIR}/catalog-entities/extensions/packages/"

# Search for a plugin by name
ls "${EXTRACT_DIR}/catalog-entities/extensions/packages/" | grep <plugin-name>

# Read plugin details including OCI reference and default config
cat "${EXTRACT_DIR}/catalog-entities/extensions/packages/<plugin-name>.yaml"
```

### Finding related packages (frontend + backend + modules):

Look at `spec.partOf` in any package YAML to find the group name, then find all packages with the same `partOf` value:

```bash
grep -l "partOf:" "${EXTRACT_DIR}/catalog-entities/extensions/packages/"*.yaml | \
  xargs grep -l "<group-name>"
```

## Step 4: Get Plugin Metadata from OCI Annotations

For additional metadata (not in catalog entities), inspect the OCI image annotations directly:

```bash
skopeo inspect --no-tags --raw \
  "docker://<oci-image-reference>" | \
  python3 -c "
import sys, json, base64
manifest = json.load(sys.stdin)
b64 = manifest.get('annotations', {}).get('io.backstage.dynamic-packages', '')
if b64:
    print(json.dumps(json.loads(base64.b64decode(b64).decode('utf-8')), indent=2))
"
```

This returns the `io.backstage.dynamic-packages` annotation containing package name, version, backstage role, and plugin relationships.

## Step 5: List Available Tags for a Plugin

```bash
skopeo list-tags "docker://ghcr.io/redhat-developer/rhdh-plugin-export-overlays/<plugin-image-name>"
```

Tags follow the pattern: `bs_<backstage-version>__<plugin-version>` (e.g., `bs_1.45.3__2.3.5`).

## Step 6: Create dynamic-plugins.yaml

Use the `spec.dynamicArtifact` as the `package` value and `spec.appConfigExamples[].content` as the `pluginConfig`:

```yaml
plugins:
  - package: <spec.dynamicArtifact value>
    disabled: false
    pluginConfig:
      <content from spec.appConfigExamples>
```

## Notes

- The `dynamic-plugins.default.yaml` in the image root only contains pre-installed/bundled plugins. Additional plugins (like scorecard) are only available via the catalog entity files.
- The catalog index image is built from the [rhdh-plugin-export-overlays](https://github.com/redhat-developer/rhdh-plugin-export-overlays) repository.
- Plugin OCI images are hosted at `ghcr.io/redhat-developer/rhdh-plugin-export-overlays/`.
- Always clean up temp directories after extraction.
