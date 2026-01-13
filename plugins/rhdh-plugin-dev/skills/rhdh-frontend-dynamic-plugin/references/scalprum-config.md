# Scalprum Configuration Reference

Scalprum provides module federation for dynamic frontend plugin loading in RHDH.

## Basic Configuration

Add to `package.json`:

```json
{
  "name": "@my-org/plugin-my-plugin",
  "scalprum": {
    "name": "my-org.plugin-my-plugin",
    "exposedModules": {
      "PluginRoot": "./src/index.ts"
    }
  }
}
```

## Configuration Fields

### name

Webpack container name used in RHDH configuration.

```json
{
  "scalprum": {
    "name": "my-org.plugin-my-plugin"
  }
}
```

**Naming Convention:**
- Replace `@` with nothing
- Replace `/` with `.`
- Example: `@my-org/plugin-my-plugin` → `my-org.plugin-my-plugin`

This name is referenced in `pluginConfig.dynamicPlugins.frontend`:

```yaml
pluginConfig:
  dynamicPlugins:
    frontend:
      my-org.plugin-my-plugin:  # Must match scalprum.name
        dynamicRoutes: []
```

### exposedModules

Entry points exposed for dynamic loading.

```json
{
  "scalprum": {
    "exposedModules": {
      "PluginRoot": "./src/index.ts"
    }
  }
}
```

**Key:** Module name referenced in wiring config
**Value:** Path to entry file

## Default Configuration

If no `scalprum` configuration is provided, the CLI generates defaults:

```json
{
  "scalprum": {
    "name": "<package_name>",
    "exposedModules": {
      "PluginRoot": "./src/index.ts"
    }
  }
}
```

The CLI outputs this during export:

```
No scalprum config. Using default dynamic UI configuration:
{
  "name": "backstage-community.plugin-todo",
  "exposedModules": {
    "PluginRoot": "./src/index.ts"
  }
}
```

## Multiple Exposed Modules

Expose multiple entry points for better code organization:

```json
{
  "scalprum": {
    "name": "my-org.plugin-my-plugin",
    "exposedModules": {
      "PluginRoot": "./src/index.ts",
      "EntityCards": "./src/components/cards/index.ts",
      "SearchComponents": "./src/components/search/index.ts"
    }
  }
}
```

Reference specific modules in wiring:

```yaml
mountPoints:
  - mountPoint: entity.page.overview/cards
    module: EntityCards           # Uses EntityCards module
    importName: MyCard

  - mountPoint: search.page.results
    module: SearchComponents      # Uses SearchComponents module
    importName: MySearchResult
```

## Module Organization Patterns

### Single Module (Simple Plugin)

All components exported from one entry:

```
src/
├── index.ts              # PluginRoot - exports everything
├── plugin.ts
└── components/
    ├── MyPage.tsx
    └── MyCard.tsx
```

```json
{
  "exposedModules": {
    "PluginRoot": "./src/index.ts"
  }
}
```

```typescript
// src/index.ts
export { myPlugin } from './plugin';
export { MyPage } from './components/MyPage';
export { MyCard } from './components/MyCard';
```

### Multiple Modules (Complex Plugin)

Separate modules for different integration points:

```
src/
├── index.ts              # PluginRoot - main exports
├── plugin.ts
├── components/
│   ├── pages/
│   │   └── index.ts      # Pages module
│   ├── cards/
│   │   └── index.ts      # EntityCards module
│   └── search/
│       └── index.ts      # SearchComponents module
```

```json
{
  "exposedModules": {
    "PluginRoot": "./src/index.ts",
    "Pages": "./src/components/pages/index.ts",
    "EntityCards": "./src/components/cards/index.ts",
    "SearchComponents": "./src/components/search/index.ts"
  }
}
```

### Benefits of Multiple Modules

1. **Code Splitting**: Smaller initial bundle, load only needed code
2. **Clear Organization**: Logical grouping of related components
3. **Selective Loading**: RHDH loads only referenced modules

## Import Name Resolution

When `importName` is not specified, `default` export is used:

```yaml
# Uses default export from PluginRoot module
dynamicRoutes:
  - path: /my-plugin
```

Explicit import name:

```yaml
# Uses named export 'MyPage' from PluginRoot module
dynamicRoutes:
  - path: /my-plugin
    importName: MyPage
```

Module and import name:

```yaml
# Uses 'MyCard' from 'EntityCards' module
mountPoints:
  - mountPoint: entity.page.overview/cards
    module: EntityCards
    importName: MyCard
```

## Static JSX Content

For dynamic plugins that need static JSX children:

```typescript
// Regular export (static plugin)
export const EntityTechdocsContent = () => {...}

// Dynamic plugin export with static children
export const DynamicEntityTechdocsContent = {
  element: EntityTechdocsContent,
  staticJSXContent: (
    <TechDocsAddons>
      <ReportIssue />
    </TechDocsAddons>
  ),
};
```

Reference in wiring:

```yaml
mountPoints:
  - mountPoint: entity.page.docs/cards
    importName: DynamicEntityTechdocsContent
```

### Dynamic JSX Content

Access other dynamic plugins in static JSX:

```typescript
export const DynamicEntityTechdocsContent = {
  element: EntityTechdocsContent,
  staticJSXContent: (dynamicConfig: DynamicConfig) => {
    const addons = dynamicConfig?.techdocsAddons ?? [];
    return (
      <TechDocsAddons>
        {addons.map(({ Component, config }) => (
          <Component {...config.props} />
        ))}
      </TechDocsAddons>
    );
  },
};
```

## Troubleshooting

### Module Not Found

Error: `Cannot find module 'PluginRoot'`

1. Verify `scalprum.exposedModules` has the referenced module
2. Check module path is correct relative to package root
3. Re-export the plugin: `npx @red-hat-developer-hub/cli@latest plugin export`

### Import Not Found

Error: `Cannot find 'MyComponent' in module`

1. Verify component is exported from the entry file
2. Check export name matches `importName` in wiring
3. Use named exports, not just re-exports

### Name Mismatch

Plugin not loading silently:

1. Verify `scalprum.name` matches `pluginConfig.dynamicPlugins.frontend.<name>`
2. Check for typos in both locations
3. Package name transformation is correct

## Best Practices

### 1. Explicit Scalprum Configuration

Always define `scalprum` in package.json instead of relying on defaults:

```json
{
  "scalprum": {
    "name": "my-org.plugin-my-plugin",
    "exposedModules": {
      "PluginRoot": "./src/index.ts"
    }
  }
}
```

### 2. Consistent Naming

Follow the naming convention:
- Package: `@my-org/plugin-my-plugin`
- Scalprum name: `my-org.plugin-my-plugin`

### 3. Single Responsibility Modules

Each exposed module should have a clear purpose:
- `PluginRoot` - Plugin definition and main page
- `EntityCards` - Entity page components
- `Icons` - Custom icons

### 4. Re-export Pattern

Use barrel exports for clean module interfaces:

```typescript
// src/components/cards/index.ts
export { MyCard } from './MyCard';
export { AnotherCard } from './AnotherCard';
```

### 5. Verify After Export

After export, check `dist-dynamic/dist-scalprum/` for:
- Generated chunk files
- Correct module structure
- Source maps (for debugging)
