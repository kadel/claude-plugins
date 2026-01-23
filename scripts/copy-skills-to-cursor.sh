#!/bin/bash
#
# Copy skills from this repository to Cursor's personal skills directory
# Usage: ./scripts/link-skills-to-cursor.sh [--dry-run] [--force] [--clean]
#

set -euo pipefail

CURSOR_SKILLS_DIR="${HOME}/.cursor/skills"
DRY_RUN=false
FORCE=false
CLEAN=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run) DRY_RUN=true; shift ;;
        --force) FORCE=true; shift ;;
        --clean) CLEAN=true; shift ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Copy skills from this repository to ~/.cursor/skills/"
            echo ""
            echo "Options:"
            echo "  --dry-run  Show what would be done without making changes"
            echo "  --force    Overwrite existing skills"
            echo "  --clean    Remove skills created by this script"
            echo "  -h, --help Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
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
echo "Cursor skills directory: ${CURSOR_SKILLS_DIR}"
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

# Clean mode
if [[ "${CLEAN}" == true ]]; then
    echo "Cleaning skills..."
    for skill_path in "${SKILLS[@]}"; do
        skill_name=$(basename "${skill_path}")
        target="${CURSOR_SKILLS_DIR}/${skill_name}"

        if [[ -d "${target}" && -f "${target}/SKILL.md" ]]; then
            if [[ "${DRY_RUN}" == true ]]; then
                echo "  Would remove: ${target}"
            else
                rm -rf "${target}"
                echo "  Removed: ${target}"
            fi
        fi
    done

    if [[ -d "${CURSOR_SKILLS_DIR}" ]] && [[ -z "$(ls -A "${CURSOR_SKILLS_DIR}")" ]]; then
        if [[ "${DRY_RUN}" == true ]]; then
            echo "  Would remove empty directory: ${CURSOR_SKILLS_DIR}"
        else
            rmdir "${CURSOR_SKILLS_DIR}"
            echo "  Removed empty directory: ${CURSOR_SKILLS_DIR}"
        fi
    fi

    echo "Done!"
    exit 0
fi

# Create directory if needed
if [[ ! -d "${CURSOR_SKILLS_DIR}" ]]; then
    if [[ "${DRY_RUN}" == true ]]; then
        echo "Would create directory: ${CURSOR_SKILLS_DIR}"
    else
        mkdir -p "${CURSOR_SKILLS_DIR}"
        echo "Created directory: ${CURSOR_SKILLS_DIR}"
    fi
fi

# Copy skills
echo "Copying skills..."
for skill_path in "${SKILLS[@]}"; do
    skill_name=$(basename "${skill_path}")
    target="${CURSOR_SKILLS_DIR}/${skill_name}"

    if [[ -e "${target}" ]]; then
        if [[ "${FORCE}" == true ]]; then
            if [[ "${DRY_RUN}" == true ]]; then
                echo "  Would replace: ${skill_name}"
            else
                rm -rf "${target}"
                cp -R "${skill_path}" "${target}"
                echo "  Replaced: ${skill_name}"
            fi
        else
            echo "  Skipped (exists): ${skill_name} - use --force to overwrite"
        fi
    else
        if [[ "${DRY_RUN}" == true ]]; then
            echo "  Would copy: ${skill_name}"
        else
            cp -R "${skill_path}" "${target}"
            echo "  Copied: ${skill_name}"
        fi
    fi
done

echo ""
if [[ "${DRY_RUN}" == true ]]; then
    echo "Dry run complete. No changes made."
else
    echo "Done! Skills are now available in Cursor."
fi
