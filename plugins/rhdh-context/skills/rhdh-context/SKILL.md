---
name: RHDH Context
description: This skill should be used whenever the user mentions "RHDH", "Red Hat Developer Hub", or "Developer Hub" in any context — whether asking questions, developing plugins, debugging, deploying, or discussing architecture. It provides essential background context about what RHDH is, how it differs from vanilla Backstage, and key nuances that affect all RHDH-related work.
version: 0.2.0
---

## Purpose

Provide context on what Red Hat Developer Hub (RHDH) is, how it relates to Backstage, and the key nuances that affect plugin development and deployment.

## What is RHDH

Red Hat Developer Hub (RHDH) is Red Hat's enterprise distribution of [Backstage](https://backstage.io), the open-source developer portal framework originally created by Spotify. RHDH packages Backstage with enterprise support, curated plugins, and an operator-based deployment model for OpenShift and Kubernetes.

RHDH is **not a fork** of Backstage. It tracks upstream Backstage releases and layers enterprise features on top. The core Backstage APIs and plugin system remain the same, but RHDH adds its own deployment, configuration, and plugin distribution mechanisms.

Key additions RHDH provides over vanilla Backstage:
- **Dynamic plugin system** — install/remove plugins without rebuilding the application
- **Operator-based deployment** — `Backstage` Custom Resource managed by the rhdh-operator
- **Helm chart deployment** — alternative to operator for simpler setups
- **Pre-packaged plugins** — curated set of plugins included in the container image (disabled by default, enabled via configuration)
- **YAML-based frontend wiring** — configure routes, mount points, menus without code changes
- **Enterprise auth defaults** — authentication required by default (no anonymous access)
- **Telemetry** — anonymous usage analytics via `analytics-provider-segment` (enabled by default)
- **Branding and theming** — configurable logos, colors, sidebar, and i18n via app-config

## RHDH vs Vanilla Backstage

### What stays the same

- Backstage plugin APIs (`@backstage/core-plugin-api`, `@backstage/backend-plugin-api`)
- Software catalog model and entity kinds
- TechDocs, scaffolder templates, search
- Authentication providers and permission framework
- React-based frontend architecture

### What RHDH changes

| Area | Vanilla Backstage | RHDH |
|------|-------------------|------|
| **Plugin installation** | Static: plugins compiled into the app at build time | Dynamic: plugins loaded at runtime without rebuilding |
| **Deployment** | DIY: build Docker image, deploy however you want | Operator-managed (`Backstage` CR) or Helm chart on OpenShift/K8s |
| **Plugin distribution** | npm packages as build-time dependencies | OCI images (recommended), tgz archives, npm packages, or local directories |
| **Frontend wiring** | Code in `App.tsx`, `EntityPage.tsx` | YAML-based wiring via `dynamic-plugins.yaml` and `app-config` |
| **Configuration** | `app-config.yaml` baked into image | ConfigMaps/Secrets mounted at runtime, assembled from multiple sources |
| **Versioning** | Pick any Backstage version | Fixed Backstage version per RHDH release |
| **Auth** | Guest access allowed in development | Auth required by default, guest must be explicitly enabled |
| **Support** | Community | Red Hat subscription |

## Dynamic Plugins

The dynamic plugin system is the most significant difference between RHDH and vanilla Backstage.

### How dynamic plugins work

RHDH decouples plugins from the core application. A **backend plugin manager** service scans a configured root directory (`dynamicPlugins.rootDirectory`) for dynamic plugin packages and loads them at startup.

- **Backend plugins** — loaded as Node.js modules from the filesystem at startup
- **Frontend plugins** — loaded as JavaScript bundles via [Scalprum](https://github.com/janus-idp/scalprum) (runtime module federation)

Plugins are installed and removed without rebuilding the application — only a pod restart is required.

### Plugin export process

Standard Backstage plugins are converted to dynamic plugins using the RHDH CLI:

```bash
npx @red-hat-developer-hub/cli@latest plugin export
```

This creates a **derived package** in `dist-dynamic/` with a `-dynamic` suffix. The export process:
1. Builds the plugin
2. Rewrites `@backstage/*` dependencies as peer dependencies (shared with the host)
3. Bundles all non-Backstage dependencies into the package
4. Auto-embeds packages with `-node` or `-common` suffixes
5. Generates Scalprum configuration for frontend plugins

Derived dynamic plugin packages should **not** be pushed to the public npm registry.

### Plugin package sources

Plugins in `dynamic-plugins.yaml` can be loaded from four sources:

- **OCI images** (recommended): `oci://quay.io/org/plugin:v1.0.0!plugin-name-dynamic`
- **tgz archives**: URL with required `integrity` hash (SHA-512)
- **npm packages**: package name with version and required `integrity` hash
- **Local directories**: filesystem path (development only)

OCI images can use digests instead of tags for integrity verification. Private registries require the `REGISTRY_AUTH_FILE` environment variable.

### Pre-packaged plugins

The RHDH container image ships with a curated set of plugins listed in `dynamic-plugins.default.yaml`. Most are **disabled by default** and must be explicitly enabled in the user's `dynamic-plugins.yaml` with `disabled: false`. Default plugin configurations can also be loaded from an external OCI image via the `CATALOG_INDEX_IMAGE` environment variable.

### Frontend wiring via YAML

Frontend plugins are wired through YAML configuration rather than code. Consult `references/frontend-wiring.md` for the full configuration reference. Key wiring capabilities:

- **Dynamic routes** — register new pages with sidebar menu items
- **Mount points** — inject components into existing pages (entity page cards, tabs, context menus, application headers, providers)
- **Menu items** — control sidebar ordering, nesting (up to 3 levels), visibility, and icons
- **App icons** — register custom icons into RHDH's icon catalog
- **Entity tabs** — add or modify catalog entity page tabs
- **Route bindings** — connect plugin cross-references
- **API factories** — register or override Backstage utility APIs
- **Scaffolder field extensions** — add custom form fields to software templates
- **TechDocs addons** — extend TechDocs pages
- **Themes** — provide or override light/dark themes
- **Sign-in page** — custom authentication UI
- **Translation resources** — i18n overrides

Mount points support conditional rendering with `if` conditions: `isKind`, `isType`, `hasAnnotation`, and custom functions with `allOf`/`anyOf`/`oneOf` logical operators.

## Deployment Model

RHDH supports two deployment methods on OpenShift/Kubernetes:

### Operator deployment
The **rhdh-operator** watches `Backstage` Custom Resources and reconciles the full deployment. Key components:
- **Backstage CR** — declares the desired RHDH instance
- **ConfigMaps** — hold `app-config` YAML and `dynamic-plugins.yaml`
- **Secrets** — store credentials (database auth, plugin secrets, auth provider secrets)
- **PostgreSQL** — required database, either operator-managed (local) or external
- **Route/Ingress** — exposes the RHDH UI

### Helm chart deployment
An alternative to the operator. See the [rhdh-chart repository](https://github.com/redhat-developer/rhdh-chart) for values and configuration.

### Local development
Run RHDH locally with `yarn start` for development. Corporate proxy environments are supported via `HTTP_PROXY`/`HTTPS_PROXY` environment variables with the `GLOBAL_AGENT_ENVIRONMENT_VARIABLE_NAMESPACE=''` setting.

## Version Compatibility

RHDH pins a specific Backstage version per release. Plugins **must** be built against a compatible Backstage version or they may fail to load due to API mismatches.

| RHDH Version | Backstage Version | Status |
|--------------|-------------------|--------|
| 1.8 / next | 1.42.5 | Latest |
| 1.7 | 1.39.1 | Current |
| 1.6 | 1.36.1 | Supported |
| 1.5 | 1.35.1 | Supported |

Always confirm the target RHDH version before starting plugin development.

## Key Nuances

### Backend plugins must use the new backend system

RHDH only supports backend plugins written with the **new backend system** (`createBackendPlugin`, `createBackendModule` from `@backstage/backend-plugin-api`). The legacy backend system (`createRouter` with `PluginEnvironment`) is not compatible with dynamic plugin loading.

### Default export is required

Dynamic backend plugins must have a **default export** from their `src/index.ts`:

```typescript
export { default } from './plugin';
```

### Shared vs bundled dependencies

`@backstage/*` packages become peer dependencies shared with the RHDH host. Non-Backstage dependencies are bundled. Mismatched `@backstage/*` versions between plugin and host cause runtime failures. Control this with `--shared-package` (use `!` prefix to bundle a `@backstage` package) and `--embed-package` flags.

### MUI v5 styling issues

Frontend dynamic plugins using Material-UI v5 lack default CSS declarations that static plugins receive. Configure `ClassNameGenerator` to prefix component names with `v5-` before exporting. MUI v5 Grid components do not inherit theme spacing — apply `spacing={2}` manually. Using MUI v4 (`@material-ui/core`) avoids these issues.

### Core service overrides

RHDH allows overriding 15 core backend services (auth, caching, database, discovery, HTTP routing, lifecycle, logging, permissions, health, scheduling, user info, URL reading) via dynamic plugins. Set the corresponding environment variable (e.g., `ENABLE_CORE_ROOTHTTPROUTER_OVERRIDE=true`) to disable the default service and provide a custom `BackendFeature` implementation.

### Auth is required by default

RHDH enables authentication by default with 15+ supported providers. RHDH includes an opinionated auth module that can be overridden with `ENABLE_AUTH_PROVIDER_MODULE_OVERRIDE=true`. For development, enable guest access explicitly:

```yaml
auth:
  environment: development
  providers:
    guest:
      dangerouslyAllowOutsideDevelopment: true
```

### No hot reload for dynamic plugins

Dynamic plugins are loaded once at RHDH startup. Changing a plugin requires restarting the RHDH pod.

### App-config is split across ConfigMaps

RHDH assembles app-config from multiple ConfigMaps referenced in the Backstage CR, allowing different teams to own different configuration segments.

### Lock file issue

If the `install-dynamic-plugins` init container terminates unexpectedly, a lock file may persist and prevent subsequent startups. Remove it manually if pod logs show "Waiting for lock release."

### Logging

RHDH uses the winston logging library. Debug-level logs are disabled by default — enable with `LOG_LEVEL=debug` environment variable.

### Telemetry

Anonymous usage data (page visits, button clicks) is collected by default via the `analytics-provider-segment` plugin. IP addresses are anonymized and user identifiers are hashed.