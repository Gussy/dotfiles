# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Architecture

This is a **chezmoi-managed dotfiles repository** using a custom source directory structure. The repository root IS the chezmoi source directory.

### Chezmoi Configuration

- **Source directory**: This repo is configured as the chezmoi source via `~/.config/chezmoi/chezmoi.toml`
- **Standard layout**: Uses chezmoi's standard naming (e.g., `dot_zshrc.tmpl` → `~/.zshrc`)
- **Ignored files**: `.chezmoiignore` excludes `README.md`, `bin/`, `.vscode/` from being managed

### Machine Detection System

The `.chezmoi.toml.tmpl` template implements hostname-based machine detection:
- Work laptops: Hostname starts with `WORK` → sets `.isWork = true`
- Personal laptops: All others → sets `.isWork = false`

This boolean is used in templates to conditionally include configurations.

## Template System

### Key Template Variables

- `.isWork` - Boolean indicating work vs personal laptop
- `.chezmoi.hostname` - Current machine hostname
- All standard chezmoi variables (`.chezmoi.os`, `.chezmoi.arch`, etc.)

### Template Usage in dot_zshrc.tmpl

Work laptops exclude:
- dottools and hermit/node PATH additions
- NVM setup and bash completion

Personal laptops include all development tools.

Template syntax:
```bash
{{- if .isWork }}
# Work-specific config
{{- else }}
# Personal-specific config
{{- end }}
```

## Development Workflow

### Testing Templates

```bash
# Preview what template will render to
chezmoi execute-template < dot_zshrc.tmpl

# See what would change without applying
chezmoi diff

# Dry run to see all changes
chezmoi apply --dry-run --verbose
```

### Adding New Dotfiles

```bash
# Add a file from home directory
chezmoi add ~/.newfile

# This creates dot_newfile in the repo
```

### Editing Dotfiles

Two methods:
1. Edit source directly in repo: `vim dot_zshrc.tmpl`
2. Use chezmoi editor: `chezmoi edit ~/.zshrc`

Always test with `chezmoi diff` before `chezmoi apply`.

## Important Constraints

### Security
- Never commit secrets/tokens to templates
- GitHub tokens and similar should be excluded from chezmoi management

### Hermit Integration
- `bin/` directory contains Hermit package manager
- This directory is ignored by chezmoi (`.chezmoiignore`)
- Do not add Hermit files to chezmoi management

### Template File Naming
When adding new dotfiles:
- Use `dot_` prefix for dotfiles (e.g., `dot_bashrc` → `~/.bashrc`)
- Use `.tmpl` suffix for templates that need variable substitution
- Use `executable_` prefix for scripts that need execute permission

## Configuration Changes

When modifying machine detection or adding new template variables:
1. Update `.chezmoi.toml.tmpl`
2. Run `chezmoi init` to regenerate `~/.config/chezmoi/chezmoi.toml`
3. Verify with `chezmoi data | jq '.data'`
