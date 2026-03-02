# CLAUDE.md — TestQuenty (Nevermore Template Project)

## Project Overview

This is a Roblox game project built with the **Nevermore Engine** framework. Nevermore provides utility packages distributed via npm, with dependency injection via `ServiceBag` and composable, independently versioned Luau packages.

## Tech Stack

- **Language:** Luau (strict mode)
- **Package Manager:** pnpm (enforced via `preinstall` script)
- **Build System:** Rojo — syncs Lua files to Roblox Studio
- **Linting:** Selene + luau-lsp
- **Formatting:** StyLua (tab indentation, Luau syntax, auto-sorted requires)
- **Documentation:** Moonwave (`--[=[ @class ClassName ]=]` docstrings)
- **Toolchain Manager:** Aftman (rojo, selene, stylua, luau-lsp, moonwave-extractor)

## Project Structure

```
src/
├── modules/
│   ├── Client/
│   │   ├── Binders/                    # Client-side binders
│   │   └── TestQuentyServiceClient.lua # Client service entry
│   ├── Server/
│   │   ├── Binders/                    # Server-side binders
│   │   └── TestQuentyService.lua       # Server service entry
│   └── Shared/
│       └── TestQuentyTranslator.lua    # Shared translation module
└── scripts/
    ├── Client/
    │   └── ClientMain.client.lua       # Client bootstrap
    └── Server/
        └── ServerMain.server.lua       # Server bootstrap
```

### Key directories

- `src/modules/` — Game logic. Split into `Client/`, `Server/`, and `Shared/`.
- `src/modules/*/Binders/` — Binder classes that attach behavior to Roblox instances.
- `src/scripts/` — Bootstrap entry points. These create a `ServiceBag`, register services, then call `Init()` and `Start()`.
- `node_modules/` — Nevermore packages installed via pnpm. Rojo maps these into the game tree.

### Rojo mapping (default.project.json)

- `src/modules` + `node_modules` → `ServerScriptService.TestQuenty`
- `src/scripts/Server` → `ServerScriptService.TestQuentyScripts`
- `src/scripts/Client` → `StarterPlayer.StarterPlayerScripts.TestQuentyScripts`

## Common Commands

```bash
pnpm install                        # Install dependencies
rojo serve                          # Start Rojo dev server (connect from Studio)
npm run format                      # Format all src/ with StyLua
npm run lint:luau                   # Type-check with luau-lsp
npm run lint:selene                 # Lint with Selene
npm run lint:stylua                 # Check formatting
npm run lint:moonwave               # Validate Moonwave docs
pnpm install @quenty/<package>      # Add a Nevermore package
```

## Nevermore Architecture

### ServiceBag (Dependency Injection)

Services are singletons managed by `ServiceBag`. Lifecycle:
1. `serviceBag:GetService(require("MyService"))` — registers the service
2. `serviceBag:Init()` — calls `Init` on all registered services
3. `serviceBag:Start()` — calls `Start` on all registered services

Services declare dependencies inside their `Init` method via `self._serviceBag:GetService(...)`.

### Loader

Every module file starts with:
```lua
local require = require(script.Parent.loader).load(script)
```
This replaces the global `require` with Nevermore's loader, enabling require-by-name (e.g., `require("ServiceBag")`) instead of require-by-path.

### Binders

Binders attach behavior to Roblox instances using CollectionService tags. Place binder classes in `src/modules/Client/Binders/` or `src/modules/Server/Binders/`. Register them in the corresponding service's `Init` method.

## Luau Coding Conventions

### File structure

Every module file follows this order:
1. `--!strict` at the top
2. Moonwave docstring: `--[=[ @class ClassName ]=]`
3. Loader require: `local require = require(script.Parent.loader).load(script)`
4. Other requires (alphabetically sorted — StyLua handles this)
5. Class table definition with `ClassName` field
6. `export type` declaration for the class
7. Constructor / `Init` method
8. Other methods
9. `return ClassName`

### Naming

- **Files:** PascalCase, matching the class name (e.g., `TestQuentyService.lua`)
- **Classes/Services:** PascalCase (e.g., `TestQuentyService`)
- **Methods:** PascalCase with dot syntax (e.g., `function MyClass.GetEnabled(self: MyClass)`)
- **Private fields:** underscore prefix (e.g., `_maid`, `_serviceBag`, `_enabled`)
- **Public signals/observables:** PascalCase (e.g., `HumanoidEntered`, `PlayerCount`)
- **Observable methods:** `Observe` prefix, `Brio` suffix when returning Brio (e.g., `ObservePlayersBrio`)
- **Service names:** Must have a `ServiceName` field matching the class name
- **Client services:** Suffix with `Client` (e.g., `TestQuentyServiceClient`)

### Method syntax

Use dot syntax with explicit self typing (Luau doesn't infer metatables well):
```lua
function MyClass.MyMethod(self: MyClass, arg: string): string
    return self._name .. arg
end
```

### Type patterns

```lua
local MyClass = {}
MyClass.ClassName = "MyClass"
MyClass.__index = MyClass

export type MyClass = typeof(setmetatable(
    {} :: {
        _maid: Maid.Maid,
        _serviceBag: ServiceBag.ServiceBag,
    },
    {} :: typeof({ __index = MyClass })
))
```

Use `:: any` casts only for metatable operations (`setmetatable`) and binder registration. Avoid casts elsewhere — fix upstream types instead.

### Service template

```lua
--!strict
--[=[
    @class MyService
]=]

local require = require(script.Parent.loader).load(script)

local ServiceBag = require("ServiceBag")

local MyService = {}
MyService.ServiceName = "MyService"

export type MyService = typeof(setmetatable(
    {} :: {
        _serviceBag: ServiceBag.ServiceBag,
    },
    {} :: typeof({ __index = MyService })
))

function MyService.Init(self: MyService, serviceBag: ServiceBag.ServiceBag): ()
    assert(not (self :: any)._serviceBag, "Already initialized")
    self._serviceBag = assert(serviceBag, "No serviceBag")

    -- Register dependencies here
end

function MyService.Start(self: MyService): ()
    -- Start logic here
end

return MyService
```

### Binder template

Binders extend `BaseObject` and are registered through a service. Place in `Binders/` directory.

### Assertions

Always assert `serviceBag` in constructors:
```lua
self._serviceBag = assert(serviceBag, "No serviceBag")
```
Assert against double initialization:
```lua
assert(not (self :: any)._serviceBag, "Already initialized")
```

## Testing (TestEZ)

Unit tests use the **TestEZ** framework located at `src/modules/Shared/TestEZ/`.

### Test file conventions

- Test files use the `.spec` suffix: `MyModule.spec.lua`
- Place test files next to the module they test (e.g., `SoundConstants.spec.lua` beside `SoundConstants.lua`)
- Test files do NOT use `--!strict` or the Nevermore loader — they are plain ModuleScripts returning a function

### Test file template

Spec files must use the Nevermore loader (not `script.Parent` requires) so module dependencies resolve correctly:

```lua
return function()
    local loader = require(script.Parent.Parent.Parent.node_modules["@quenty"].loader)
    local require = loader.load(script)

    local SoundConstants = require("SoundConstants")

    describe("SoundConstants", function()
        it("should have a UIClick entry", function()
            expect(SoundConstants.Sounds.UIClick).to.be.ok()
        end)
    end)
end
```

**Client module specs** — The Nevermore loader blocks client modules from server context. Use `pcall` + `itSKIP` to gracefully skip:

```lua
return function()
    local ok, MyClientModule = pcall(function()
        return require(script.Parent.MyClientModule)
    end)

    describe("MyClientModule", function()
        if not ok then
            itSKIP("cannot test client module from server context", function() end)
            return
        end
        -- tests here
    end)
end
```

### Running tests via MCP

Use `run_script_in_play_mode` with `run_server` mode. Require TestEZ via `TestEZ.TestBootstrap`:

```lua
local SSS = game:GetService("ServerScriptService")
local TestQuenty = SSS.TestQuenty
local TestEZ = require(TestQuenty.game.Shared.TestEZ)
local TestBootstrap = TestEZ.TestBootstrap

local results = TestBootstrap:run({
    TestQuenty.game.Shared,
    TestQuenty.game.Server,
    TestQuenty.game.Client,
})

print(results:visualize())
print("Success: " .. results.successCount .. ", Failures: " .. results.failureCount)
```

### Important notes

- The Nevermore `LoaderLinkCreator` creates `loader` links asynchronously at runtime — they may not exist during `run_server` mode, so spec files should use the direct loader path
- Loader "Failed to find package" warnings during tests are non-blocking — modules still load via fallback paths
- `start_play` mode disconnects Rojo, so tests must use `run_server` mode
- The loader path from any spec file to the loader module is: `script.Parent.Parent.Parent.node_modules["@quenty"].loader` (3 parents up from the module folder to TestQuenty root)

### TestEZ API quick reference

- `describe(name, fn)` — group tests
- `it(name, fn)` — define a test case
- `expect(value)` — create assertion: `.to.equal(v)`, `.to.be.ok()`, `.to.be.a(type)`, `.to.throw()`, `.never.to.equal(v)`
- `beforeEach(fn)` / `afterEach(fn)` — per-test setup/teardown
- `beforeAll(fn)` / `afterAll(fn)` — per-describe setup/teardown

## Code Style

- **Indentation:** Tabs (enforced by StyLua and .editorconfig)
- **Strict mode:** Always `--!strict` at top of file
- **Requires:** Sorted alphabetically (StyLua `sort_requires = true`)
- **Line endings:** LF
- **Charset:** UTF-8
- **JSON/YAML:** 2-space indent

## Git Conventions

- **Commit style:** Conventional commits — `feat(scope):`, `fix(scope):`, `chore(scope):`
- **Commit messages:** Impact-focused and concise
- **Squash commits** before pushing to maintain clean history
- **Branch:** `main` is the default branch

## CI/CD (GitHub Actions)

- **Linting** (`linting.yml`): Runs on push to main and PRs. Checks luau-lsp, stylua, selene, moonwave.
- **Tests** (`tests.yml`): Runs on PRs. Requires `ROBLOX_OPEN_CLOUD_API_KEY` secret and `nevermore deploy init` setup.
- **Deploy** (`deploy.yml`): Runs on push to main. Requires same setup as tests.

## Key Nevermore Packages in Use

| Package | Purpose |
|---------|---------|
| `@quenty/loader` | Module loader (require-by-name) |
| `@quenty/servicebag` | Dependency injection container |
| `@quenty/binder` | Instance binding via CollectionService |
| `@quenty/clienttranslator` | Client-side i18n |
| `@quenty/cmdrservice` | In-game command system |

## Important Notes

- Never edit files in `node_modules/` — these are managed by pnpm
- The `loader` module is critical — every file depends on it for require-by-name
- Rojo must be running to sync changes to Studio (`rojo serve`)
- Run `pnpm install` after adding new `@quenty/*` dependencies
- The `sourcemap.json` and `globalTypes.d.lua` are generated files (gitignored)
- When adding a new service, register it in the corresponding main service (`TestQuentyService` or `TestQuentyServiceClient`)
