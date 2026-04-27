---
name: obsidian-cli
description: >
  This skill should be used when the user works with notes, Obsidian,
  vault, daily notes, tags, tasks, bookmarks, or any note-taking operations.
version: 0.1.0
---

# Obsidian CLI — Operate on Obsidian Vaults

Requires the `obsidian` CLI on `$PATH` and the Obsidian desktop app running.

```bash
obsidian <command> [options]
```

## General Notes

- To get the vault directory path, run `obsidian vault info=path`.
- `file=<name>` resolves by name (like wikilinks); `path=<path>` is an exact path (e.g. `folder/note.md`).
- Most commands default to the active file when `file`/`path` is omitted.
- Quote values with spaces: `name="My Note"`.
- Use `\n` for newline, `\t` for tab in content values.
- Target a specific vault: `vault=<name>`.
- Many commands accept `format=json|tsv|csv` for structured output.

## Security Rules

- Confirm with the user before executing write/delete commands (`create`, `append`, `prepend`, `delete`, `move`, `rename`, `property:set`, `property:remove`).
- Prefer reading before writing to verify the target file.

## Vault & File Info

```bash
obsidian vault                           # vault info
obsidian vault info=name                 # vault name only
obsidian vaults                          # list known vaults
obsidian vaults verbose                  # include vault paths
obsidian files                           # list all files
obsidian files folder=Projects ext=md    # filter by folder/extension
obsidian files total                     # file count
obsidian folders                         # list folders
obsidian file file=MyNote                # show file info
obsidian folder path=Projects            # show folder info
```

## Reading & Writing Notes

### read — Read file contents

```bash
obsidian read file=MyNote
obsidian read path=folder/note.md
```

### create — Create a new file

```bash
obsidian create name=MyNote content="Hello world"
obsidian create name=FromTemplate template=Daily open
obsidian create path=Projects/idea.md content="New idea" overwrite
```

| Flag | Description |
|------|-------------|
| `name` | File name |
| `path` | File path |
| `content` | Initial content |
| `template` | Template to use |
| `overwrite` | Overwrite if file exists |
| `open` | Open file after creating |
| `newtab` | Open in new tab |

> **WRITE command** — confirm with the user before executing.

### append / prepend — Add content to a file

```bash
obsidian append file=MyNote content="New paragraph"
obsidian append file=MyNote content=" inline text" inline
obsidian prepend path=inbox.md content="# New Section"
```

`inline` appends/prepends without a newline separator.

> **WRITE command** — confirm with the user before executing.

### delete — Delete a file

```bash
obsidian delete file=MyNote
obsidian delete path=old/note.md permanent   # skip trash
```

> **WRITE command** — confirm with the user before executing.

### move / rename

```bash
obsidian move file=MyNote to=Archive/
obsidian move path=inbox/note.md to=Projects/note.md
obsidian rename file=MyNote name="Better Name"
```

> **WRITE command** — confirm with the user before executing.

### open — Open a file in Obsidian

```bash
obsidian open file=MyNote
obsidian open path=Projects/idea.md newtab
```

## Daily Notes

```bash
obsidian daily                              # open today's daily note
obsidian daily:read                         # read daily note contents
obsidian daily:path                         # get daily note path
obsidian daily:append content="- Task done"
obsidian daily:prepend content="## Morning"
```

`daily:append` and `daily:prepend` accept `inline`, `open`, and `paneType=tab|split|window`.

> **daily:append / daily:prepend** — confirm with the user before executing.

## Search

```bash
obsidian search query="meeting notes"
obsidian search query="TODO" path=Projects limit=10 case
obsidian search:context query="API key"           # includes matching line context
obsidian search:context query="bug" format=json
obsidian search:open query="meeting"              # open search in Obsidian UI
```

| Flag | Description |
|------|-------------|
| `query` | Search text (required) |
| `path` | Limit to folder |
| `limit` | Max files |
| `total` | Return match count only |
| `case` | Case sensitive |
| `format` | `text` (default) or `json` |

## Tags & Properties

### Tags

```bash
obsidian tags                               # list all tags
obsidian tags counts sort=count             # sorted by frequency
obsidian tags file=MyNote                   # tags for a specific file
obsidian tag name=project                   # tag info
obsidian tag name=project verbose           # include file list
```

### Properties (frontmatter)

```bash
obsidian properties                         # list all properties in vault
obsidian properties file=MyNote format=yaml
obsidian property:read name=status file=MyNote
obsidian property:set name=status value=done file=MyNote
obsidian property:set name=priority value=1 type=number file=MyNote
obsidian property:remove name=draft file=MyNote
```

Property types: `text`, `list`, `number`, `checkbox`, `date`, `datetime`.

> **property:set / property:remove** — confirm with the user before executing.

## Tasks

```bash
obsidian tasks                              # list all tasks
obsidian tasks todo                         # incomplete tasks only
obsidian tasks done                         # completed tasks only
obsidian tasks file=MyNote verbose          # grouped by file with line numbers
obsidian tasks daily                        # tasks from daily note
obsidian tasks status=" " format=json       # filter by status character
obsidian task path=note.md line=5 toggle    # toggle task status
obsidian task file=MyNote line=3 done       # mark task done
obsidian task daily line=2 todo             # mark daily task as todo
```

> **task (toggle/done/todo)** — confirm with the user before executing.

## Links & Graph Analysis

```bash
obsidian links file=MyNote                  # outgoing links
obsidian backlinks file=MyNote              # incoming links
obsidian backlinks file=MyNote counts       # with link counts
obsidian orphans                            # files with no incoming links
obsidian deadends                           # files with no outgoing links
obsidian unresolved                         # unresolved links in vault
obsidian unresolved verbose                 # include source files
```

## Bookmarks

```bash
obsidian bookmarks                          # list bookmarks
obsidian bookmark file=Projects/idea.md title="Read later"
obsidian bookmark search="TODO" title="Todo search"
obsidian bookmark url="https://example.com" title="Reference"
```

> **bookmark** — confirm with the user before executing.

## Templates

```bash
obsidian templates                          # list available templates
obsidian template:read name=Daily
obsidian template:read name=Daily resolve title="Today's Note"
obsidian template:insert name=Daily         # insert into active file
```

## Outline & Word Count

```bash
obsidian outline file=MyNote                # heading tree
obsidian outline file=MyNote format=md      # markdown format
obsidian wordcount file=MyNote
obsidian wordcount file=MyNote words        # word count only
```

## Plugins

```bash
obsidian plugins                            # list installed plugins
obsidian plugins filter=community versions
obsidian plugins:enabled filter=core
obsidian plugin id=dataview                 # plugin info
obsidian plugin:enable id=dataview
obsidian plugin:disable id=dataview
obsidian plugin:install id=dataview enable  # install and enable
obsidian plugin:uninstall id=dataview
obsidian plugin:reload id=my-plugin         # for development
obsidian plugins:restrict on               # enable restricted mode
```

> **plugin:enable/disable/install/uninstall** — confirm with the user before executing.

## Sync & History

### Sync

```bash
obsidian sync:status                        # show sync status
obsidian sync on                            # resume sync
obsidian sync off                           # pause sync
obsidian sync:history file=MyNote           # sync version history
obsidian sync:read file=MyNote version=2    # read a sync version
obsidian sync:restore file=MyNote version=2 # restore a sync version
obsidian sync:deleted                       # list deleted files in sync
```

### Local History

```bash
obsidian history file=MyNote                # list history versions
obsidian history:list                       # list files with history
obsidian history:read file=MyNote version=1 # read a history version
obsidian history:restore file=MyNote version=3
```

> **sync:restore / history:restore** — confirm with the user before executing.

## Themes & CSS Snippets

```bash
obsidian themes                             # list installed themes
obsidian theme                              # show active theme
obsidian theme:set name="Minimal"
obsidian theme:install name="Minimal" enable
obsidian theme:uninstall name="Minimal"
obsidian snippets                           # list CSS snippets
obsidian snippet:enable name=custom
obsidian snippet:disable name=custom
```

## Commands & Hotkeys

```bash
obsidian commands                           # list all commands
obsidian commands filter=editor             # filter by prefix
obsidian command id=editor:toggle-bold      # execute a command
obsidian hotkeys                            # list hotkeys
obsidian hotkey id=editor:toggle-bold       # get hotkey for command
```

## Other Commands

```bash
obsidian aliases                            # list aliases in vault
obsidian recents                            # recently opened files
obsidian random                             # open a random note
obsidian random:read folder=Ideas           # read a random note from folder
obsidian unique name="Zettel" content="..."  # create unique note (with timestamp)
obsidian diff file=MyNote                   # list local/sync versions
obsidian diff file=MyNote from=1 to=3       # diff between versions
obsidian tabs                               # list open tabs
obsidian workspace                          # show workspace tree
obsidian reload                             # reload the vault
obsidian version                            # show Obsidian version
```

## QuickAdd Plugin

If the QuickAdd community plugin is installed:

```bash
obsidian quickadd:list                      # list choices
obsidian quickadd:run choice="Add Task" vars='{"task":"Buy milk"}'
obsidian quickadd:check choice="Add Task"   # check missing inputs
```

## Output Format Tips

Use `format=json` for structured output that can be piped to `jq`:

```bash
obsidian search:context query="TODO" format=json | jq '.[].file'
obsidian tags counts format=json | jq '.[] | select(.count > 5)'
obsidian tasks format=json | jq '.[] | select(.status == " ")'
```
