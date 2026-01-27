#!/bin/bash
#
# Install skills from this repository to AI coding assistants
# Supported targets: Cursor, Claude Code, GitHub Copilot
# Usage: ./scripts/install-skills.sh [--target <target>] [--dry-run] [--force] [--clean]
#

set -euo pipefail

# Default configuration
DRY_RUN=false
FORCE=false
CLEAN=false
TARGETS=()

# Target directories
CURSOR_SKILLS_DIR="${HOME}/.cursor/skills"
CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"
COPILOT_SKILLS_DIR="${HOME}/.copilot/skills"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --target)
            if [[ -n "${2:-}" && ! "${2:-}" =~ ^- ]]; then
                TARGETS+=("$2")
                shift
            else
                echo "Error: --target requires an argument (cursor, claude, copilot, all)"
                exit 1
            fi
            shift
            ;;
        --dry-run) DRY_RUN=true; shift ;;
        --force) FORCE=true; shift ;;
        --clean) CLEAN=true; shift ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Install skills from this repository to local AI assistant directories."
            echo ""
            echo "Options:"
            echo "  --target <name>  Target assistant: cursor, claude, copilot, or all (default: all)"
            echo "  --dry-run        Show what would be done without making changes"
            echo "  --force          Overwrite existing skills"
            echo "  --clean          Remove skills created by this script"
            echo "  -h, --help       Show this help message"
            echo ""
            echo "Target locations:"
            echo "  Cursor:  ${CURSOR_SKILLS_DIR}"
            echo "  Claude:  ${CLAUDE_SKILLS_DIR}"
            echo "  Copilot: ${COPILOT_SKILLS_DIR}"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Default to all if no targets specified
if [[ ${#TARGETS[@]} -eq 0 ]]; then
    TARGETS=("cursor" "claude" "copilot")
elif [[ " ${TARGETS[*]} " =~ " all " ]]; then
    TARGETS=("cursor" "claude" "copilot")
fi

# Validate targets
for target in "${TARGETS[@]}"; do
    case $target in
        cursor|claude|copilot) ;;
        *)
            echo "Error: Unknown target '$target'. Supported: cursor, claude, copilot, all"
            exit 1
            ;;
    esac
done

# Find repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [[ ! -d "${REPO_ROOT}/plugins" ]]; then
    echo "Error: Cannot find plugins directory at ${REPO_ROOT}/plugins"
    exit 1
fi

echo "Repository root: ${REPO_ROOT}"
echo "Targets: ${TARGETS[*]}"
echo ""

# Find all skills (directories containing SKILL.md)
SKILLS=()
while IFS= read -r skill_md; do
    SKILLS+=("$(dirname "${skill_md}")")
done < <(find "${REPO_ROOT}/plugins" -type f -name "SKILL.md" -path "*/skills/*" 2>/dev/null | sort)

if [[ ${#SKILLS[@]} -eq 0 ]]; then
    echo "No skills found in ${REPO_ROOT}/plugins/*/skills/*/"
    exit 0
fi

echo "Found ${#SKILLS[@]} skill(s):"
for skill_path in "${SKILLS[@]}"; do
    echo "  - $(basename "${skill_path}")"
done
echo ""

# Function to handle skills for a specific target directory
process_target() {
    local target_name=$1
    local target_dir=$2
    
    echo "Processing target: ${target_name} (${target_dir})"

    # Clean mode
    if [[ "${CLEAN}" == true ]]; then
        echo "  Cleaning skills..."
        for skill_path in "${SKILLS[@]}"; do
            skill_name=$(basename "${skill_path}")
            dest="${target_dir}/${skill_name}"

            if [[ -d "${dest}" && -f "${dest}/SKILL.md" ]]; then
                if [[ "${DRY_RUN}" == true ]]; then
                    echo "    Would remove: ${dest}"
                else
                    rm -rf "${dest}"
                    echo "    Removed: ${dest}"
                fi
            fi
        done

        # Remove parent directory if empty
        if [[ -d "${target_dir}" ]] && [[ -z "$(ls -A "${target_dir}")" ]]; then
             if [[ "${DRY_RUN}" == true ]]; then
                echo "    Would remove empty directory: ${target_dir}"
            else
                rmdir "${target_dir}"
                echo "    Removed empty directory: ${target_dir}"
            fi
        fi
        return
    fi

    # Install mode
    # Create directory if needed
    if [[ ! -d "${target_dir}" ]]; then
        if [[ "${DRY_RUN}" == true ]]; then
            echo "  Would create directory: ${target_dir}"
        else
            mkdir -p "${target_dir}"
            echo "  Created directory: ${target_dir}"
        fi
    fi

    echo "  Installing skills..."
    for skill_path in "${SKILLS[@]}"; do
        skill_name=$(basename "${skill_path}")
        dest="${target_dir}/${skill_name}"

        if [[ -e "${dest}" ]]; then
            if [[ "${FORCE}" == true ]]; then
                if [[ "${DRY_RUN}" == true ]]; then
                    echo "    Would replace: ${skill_name}"
                else
                    rm -rf "${dest}"
                    cp -R "${skill_path}" "${dest}"
                    echo "    Replaced: ${skill_name}"
                fi
            else
                echo "    Skipped (exists): ${skill_name} - use --force to overwrite"
            fi
        else
            if [[ "${DRY_RUN}" == true ]]; then
                echo "    Would copy: ${skill_name}"
            else
                cp -R "${skill_path}" "${dest}"
                echo "    Copied: ${skill_name}"
            fi
        fi
    done
}

# Process each target
for target in "${TARGETS[@]}"; do
    case $target in
        cursor)
            process_target "Cursor" "${CURSOR_SKILLS_DIR}"
            ;;
        claude)
            process_target "Claude" "${CLAUDE_SKILLS_DIR}"
            ;;
        copilot)
            process_target "Copilot" "${COPILOT_SKILLS_DIR}"
            ;;
    esac
    echo ""
done

if [[ "${DRY_RUN}" == true ]]; then
    echo "Dry run complete. No changes made."
else
    echo "Done!"
fi
