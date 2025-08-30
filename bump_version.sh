#!/bin/bash

# Version bump script for FUTO Keyboard
# Usage: ./bump_version.sh --minor|--patch

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print usage
usage() {
    echo "Usage: $0 --minor|--patch"
    echo "  --minor    Increment minor version and reset patch to 0"
    echo "  --patch    Increment patch version"
    echo ""
    echo "Examples:"
    echo "  $0 --minor    # v1.2.3 -> v1.3.0"
    echo "  $0 --patch    # v1.2.3 -> v1.2.4"
    exit 1
}

# Function to get current version from git tags
get_current_version() {
    # Try to get the latest tag
    if git describe --tags --abbrev=0 >/dev/null 2>&1; then
        CURRENT_VERSION=$(git describe --tags --abbrev=0)
    else
        echo -e "${YELLOW}No tags found, using default version v0.1.0${NC}"
        CURRENT_VERSION="v0.1.0"
    fi

    # Remove 'v' prefix if present
    CURRENT_VERSION=${CURRENT_VERSION#v}
    echo "$CURRENT_VERSION"
}

# Function to bump version
bump_version() {
    local version=$1
    local bump_type=$2

    # Split version into components
    IFS='.' read -ra VERSION_PARTS <<< "$version"
    local major=${VERSION_PARTS[0]:-0}
    local minor=${VERSION_PARTS[1]:-0}
    local patch=${VERSION_PARTS[2]:-0}

    case $bump_type in
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            echo -e "${RED}Invalid bump type: $bump_type${NC}"
            exit 1
            ;;
    esac

    echo "$major.$minor.$patch"
}

# Function to create git tag
create_tag() {
    local new_version=$1
    local tag_name="v$new_version"

    echo -e "${GREEN}Creating tag: $tag_name${NC}"

    # Create annotated tag
    git tag -a "$tag_name" -m "Release $tag_name

- Ortholinear QWERTY layout improvements
- Enhanced longpress options
- Bug fixes and performance improvements"

    echo -e "${GREEN}Tag created successfully!${NC}"
    echo -e "${YELLOW}To push the tag and trigger a release, run:${NC}"
    echo "  git push origin $tag_name"
}

# Main script
main() {
    # Check if we're in a git repository
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo -e "${RED}Error: Not in a git repository${NC}"
        exit 1
    fi

    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD --; then
        echo -e "${RED}Error: You have uncommitted changes. Please commit or stash them first.${NC}"
        exit 1
    fi

    # Parse arguments
    if [ $# -ne 1 ]; then
        usage
    fi

    case $1 in
        --minor|--patch)
            BUMP_TYPE=${1#--}
            ;;
        *)
            echo -e "${RED}Error: Invalid argument '$1'${NC}"
            usage
            ;;
    esac

    # Get current version
    CURRENT_VERSION=$(get_current_version)
    echo -e "${GREEN}Current version: v$CURRENT_VERSION${NC}"

    # Calculate new version
    NEW_VERSION=$(bump_version "$CURRENT_VERSION" "$BUMP_TYPE")
    echo -e "${GREEN}New version: v$NEW_VERSION${NC}"

    # Confirm with user
    echo -e "${YELLOW}This will create tag v$NEW_VERSION${NC}"
    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Aborted.${NC}"
        exit 0
    fi

    # Create the tag
    create_tag "$NEW_VERSION"
}

# Run main function
main "$@"