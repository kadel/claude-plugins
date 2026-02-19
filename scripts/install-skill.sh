#!/bin/bash
#
# Install a single Claude Code skill from a local path or GitHub URL
# Usage: ./scripts/install-skill.sh <local-path-or-github-url> [--force] [--dry-run]
#
# Examples:
#   ./scripts/install-skill.sh ~/Code/claude-plugins/plugins/jira-utils/skills/use-jira-cli
#   ./scripts/install-skill.sh https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev/skills/skill-development
#   ./scripts/install-skill.sh https://github.com/user/repo/tree/branch/path/to/skill --force
#

set -euo pipefail

CLAUDE_SKILLS_DIR="${HOME}/.claude/skills"
DRY_RUN=false
FORCE=false
SOURCE=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run) DRY_RUN=true; shift ;;
        --force) FORCE=true; shift ;;
        -h|--help)
            echo "Usage: $0 <local-path-or-github-url> [OPTIONS]"
            echo ""
            echo "Install a Claude Code skill from a local path or GitHub URL."
            echo ""
            echo "Arguments:"
            echo "  <source>       Local path to a skill directory, or a GitHub URL"
            echo "                 (e.g. https://github.com/owner/repo/tree/branch/path/to/skill)"
            echo ""
            echo "Options:"
            echo "  --dry-run      Show what would be done without making changes"
            echo "  --force        Overwrite existing skill if it already exists"
            echo "  -h, --help     Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 ~/Code/my-plugins/plugins/foo/skills/bar"
            echo "  $0 https://github.com/anthropics/claude-code/tree/main/plugins/plugin-dev/skills/skill-development"
            exit 0
            ;;
        -*)
            echo "Error: Unknown option: $1"
            exit 1
            ;;
        *)
            if [[ -n "${SOURCE}" ]]; then
                echo "Error: Only one source argument is allowed"
                exit 1
            fi
            SOURCE="$1"
            shift
            ;;
    esac
done

if [[ -z "${SOURCE}" ]]; then
    echo "Error: A source path or GitHub URL is required"
    echo "Run '$0 --help' for usage"
    exit 1
fi

# Resolve source to a local directory
cleanup_tmpdir() {
    if [[ -n "${TMPDIR_CREATED:-}" && -d "${TMPDIR_CREATED}" ]]; then
        rm -rf "${TMPDIR_CREATED}"
    fi
}
trap cleanup_tmpdir EXIT

if [[ "${SOURCE}" =~ ^https?://github\.com/ ]]; then
    # Parse GitHub URL: https://github.com/owner/repo/tree/branch/path/to/skill
    SOURCE="${SOURCE%/}"

    if [[ ! "${SOURCE}" =~ github\.com/([^/]+)/([^/]+)/tree/([^/]+)/(.*) ]]; then
        echo "Error: GitHub URL must be in the format:"
        echo "  https://github.com/owner/repo/tree/branch/path/to/skill"
        exit 1
    fi

    GH_OWNER="${BASH_REMATCH[1]}"
    GH_REPO="${BASH_REMATCH[2]}"
    GH_BRANCH="${BASH_REMATCH[3]}"
    GH_PATH="${BASH_REMATCH[4]}"
    SKILL_NAME="$(basename "${GH_PATH}")"

    echo "Fetching skill '${SKILL_NAME}' from GitHub..."
    echo "  Repo:   ${GH_OWNER}/${GH_REPO}"
    echo "  Branch: ${GH_BRANCH}"
    echo "  Path:   ${GH_PATH}"
    echo ""

    TMPDIR_CREATED="$(mktemp -d)"
    TARBALL_PREFIX="${GH_REPO}-${GH_BRANCH}"

    # Download tarball and extract only the skill subdirectory
    STRIP=$(echo "${GH_PATH}" | awk -F'/' '{print NF + 1}')

    curl -sfL "https://github.com/${GH_OWNER}/${GH_REPO}/archive/refs/heads/${GH_BRANCH}.tar.gz" \
        | tar xz -C "${TMPDIR_CREATED}" --strip-components="${STRIP}" \
            "${TARBALL_PREFIX}/${GH_PATH}" 2>/dev/null

    if [[ $? -ne 0 || ! -d "${TMPDIR_CREATED}" || -z "$(ls -A "${TMPDIR_CREATED}")" ]]; then
        echo "Error: Failed to download skill from GitHub"
        echo "Check that the URL, branch, and path are correct"
        exit 1
    fi

    SKILL_DIR="${TMPDIR_CREATED}"
else
    # Local path - expand ~ and resolve
    SKILL_DIR="${SOURCE/#\~/$HOME}"
    SKILL_DIR="$(cd "${SKILL_DIR}" 2>/dev/null && pwd)" || {
        echo "Error: Local path does not exist: ${SOURCE}"
        exit 1
    }
    SKILL_NAME="$(basename "${SKILL_DIR}")"
fi

# Validate that it looks like a skill directory
if [[ ! -f "${SKILL_DIR}/SKILL.md" ]]; then
    echo "Error: No SKILL.md found in '${SKILL_NAME}'"
    echo "This does not appear to be a valid Claude Code skill directory"
    exit 1
fi

DEST="${CLAUDE_SKILLS_DIR}/${SKILL_NAME}"

echo "Skill:       ${SKILL_NAME}"
echo "Destination: ${DEST}"
echo ""

# Check if destination already exists
if [[ -e "${DEST}" ]]; then
    if [[ "${FORCE}" == true ]]; then
        if [[ "${DRY_RUN}" == true ]]; then
            echo "Would replace existing skill: ${SKILL_NAME}"
        else
            rm -rf "${DEST}"
        fi
    else
        echo "Error: Skill '${SKILL_NAME}' already exists at ${DEST}"
        echo "Use --force to overwrite"
        exit 1
    fi
fi

# Create skills directory if needed
if [[ ! -d "${CLAUDE_SKILLS_DIR}" ]]; then
    if [[ "${DRY_RUN}" == true ]]; then
        echo "Would create directory: ${CLAUDE_SKILLS_DIR}"
    else
        mkdir -p "${CLAUDE_SKILLS_DIR}"
    fi
fi

# Copy the skill
if [[ "${DRY_RUN}" == true ]]; then
    echo "Would install skill '${SKILL_NAME}' to ${DEST}"
    echo ""
    echo "Dry run complete. No changes made."
else
    cp -R "${SKILL_DIR}" "${DEST}"
    echo "Installed skill '${SKILL_NAME}' to ${DEST}"
fi
