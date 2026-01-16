# RHDH Plugin Development

Claude Code plugin for developing dynamic plugins for Red Hat Developer Hub (RHDH), the enterprise distribution of Backstage.

## Skills

### Backend Dynamic Plugin (`rhdh-backend-dynamic-plugin`)

Bootstrap and develop backend dynamic plugins for RHDH.

**Trigger phrases:**
- "Create RHDH backend plugin"
- "Bootstrap backend dynamic plugin"
- "New scaffolder action for RHDH"
- "Create catalog processor"
- "Create backend module"

**What it covers:**
- RHDH version compatibility (1.5 - 1.8)
- Backstage new backend system (`createBackendPlugin`, `createBackendModule`)
- Export with `@red-hat-developer-hub/cli`
- OCI image packaging
- Dependency handling (shared, bundled, embedded)
- Local and container debugging

**Reference files:**
- `references/versions.md` - Version compatibility matrix
- `references/export-guide.md` - Export options and flags
- `references/packaging-guide.md` - OCI, tgz, npm packaging
- `references/debugging.md` - Debugging techniques

---

### Frontend Dynamic Plugin (`rhdh-frontend-dynamic-plugin`)

Bootstrap and develop frontend dynamic plugins for RHDH.

**Trigger phrases:**
- "Create RHDH frontend plugin"
- "Add entity card to RHDH"
- "Create dynamic route"
- "Configure mount points"
- "Add sidebar menu item"
- "Create theme plugin"

**What it covers:**
- Dynamic routes and full-page plugins
- Entity page mount points and cards
- Sidebar menu items and icons
- Custom tabs and entity customization
- Themes, scaffolder extensions, TechDocs addons
- Route bindings between plugins

**Reference files:**
- `references/frontend-wiring.md` - Complete wiring reference
- `references/entity-page.md` - Entity page customization

---

### Generate Frontend Wiring (`generate-frontend-wiring`)

Analyze an existing Backstage frontend plugin and generate the RHDH dynamic plugin wiring configuration.

**Trigger phrases:**
- "Generate frontend wiring"
- "Show frontend wiring"
- "Create RHDH binding"
- "Generate dynamic plugin config"
- "Show plugin wiring for RHDH"

**What it does:**
- Analyzes plugin source files (package.json, plugin.ts, index.ts)
- Identifies exported pages, cards, APIs, and icons
- Determines scalprum name from manifest or package name
- Generates complete `dynamicPlugins.frontend` configuration

## Quick Start

### Backend Plugin

```bash
# 1. Create Backstage app (for RHDH 1.7)
npx @backstage/create-app@0.6.2
cd my-app && yarn install

# 2. Create backend plugin
yarn new  # Select "backend-plugin"

# 3. Implement using new backend system
# Edit plugins/<plugin-id>-backend/src/plugin.ts

# 4. Export as dynamic plugin
cd plugins/<plugin-id>-backend
npx @red-hat-developer-hub/cli@latest plugin export

# 5. Package as OCI image
npx @red-hat-developer-hub/cli@latest plugin package \
  --tag quay.io/<namespace>/<plugin>:v0.1.0
```

### Frontend Plugin

```bash
# 1. Create Backstage app (for RHDH 1.7)
npx @backstage/create-app@0.6.2
cd my-app && yarn install

# 2. Create frontend plugin
yarn new  # Select "plugin"

# 3. Implement React components
# Edit plugins/<plugin-id>/src/

# 4. Export as dynamic plugin
cd plugins/<plugin-id>
npx @red-hat-developer-hub/cli@latest plugin export

# 5. Package and configure wiring
npx @red-hat-developer-hub/cli@latest plugin package \
  --tag quay.io/<namespace>/<plugin>:v0.1.0
```

## Version Compatibility

| RHDH | Backstage | create-app |
|------|-----------|------------|
| 1.8  | 1.42.5    | 0.7.3      |
| 1.7  | 1.39.1    | 0.6.2      |
| 1.6  | 1.36.1    | 0.5.25     |
| 1.5  | 1.35.1    | 0.5.24     |

## Example Configuration

### Backend Plugin

```yaml
plugins:
  - package: oci://quay.io/example/my-backend:v1.0.0!my-plugin-backend-dynamic
    disabled: false
    pluginConfig:
      myPlugin:
        apiUrl: https://api.example.com
```

### Frontend Plugin

```yaml
plugins:
  - package: oci://quay.io/example/my-frontend:v1.0.0!my-plugin
    disabled: false
    pluginConfig:
      dynamicPlugins:
        frontend:
          my-org.plugin-my-plugin:
            dynamicRoutes:
              - path: /my-plugin
                importName: MyPage
                menuItem:
                  icon: dashboard
                  text: My Plugin
            mountPoints:
              - mountPoint: entity.page.overview/cards
                importName: MyCard
```

## Resources

- [RHDH Dynamic Plugins Documentation](https://github.com/redhat-developer/rhdh/tree/main/docs/dynamic-plugins)
- [Backstage Plugin Development](https://backstage.io/docs/plugins/)
- [Backstage New Backend System](https://backstage.io/docs/backend-system/)
