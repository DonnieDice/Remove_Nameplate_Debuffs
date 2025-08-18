# Addon Release Agent Instructions

## Purpose
This agent handles the complete release process for RND (Remove Nameplate Debuffs) addon, ensuring all files are properly updated before creating and pushing a tagged release.

## Release Checklist

### 1. Pre-Release Validation
- [ ] Verify all changes are committed
- [ ] Ensure working directory is clean
- [ ] Confirm on main branch

### 2. Version Updates
- [ ] Update version in `data/core.lua` (line 13: `local ADDON_VERSION = "X.X.X"` and line 3 header comment)
- [ ] Update version in all TOC files:
  - `Remove_Nameplate_Debuffs.toc`
  - `Remove_Nameplate_Debuffs_Cata.toc`
  - `Remove_Nameplate_Debuffs_Vanilla.toc`
  - `Remove_Nameplate_Debuffs_Mists.toc`
  - `Remove_Nameplate_Debuffs_BCC.toc`
  - `Remove_Nameplate_Debuffs_Wrath.toc`

### 3. Changelog Updates
- [ ] Update `docs/CHANGES.md` with new version entry at the top
  - Format: `## vX.X.X - Brief Title`
  - List all changes with proper prefixes: `- Added`, `- Fixed`, `- Updated`, `- Removed`
  - Include file references in brackets: `[core.lua]`, `[locales.lua]`, etc.
- [ ] Update `docs/changelog.txt` with same version entry
  - Format: `vX.X.X-------------------------------------------------------------------`
  - Same changes as CHANGES.md but different format
- [ ] Ensure changelog entries are clear and user-friendly

### 4. GitHub Workflow Verification
- [ ] Check `.github/workflows/release.yml` extracts changelog correctly
- [ ] Verify Discord webhook will send only current version's changelog
- [ ] Confirm changelog extraction logic in workflow:
  ```yaml
  # Should extract only the current version's changes
  version=$(grep "^## Version:" Remove_Nameplate_Debuffs.toc | sed 's/## Version: //')
  # Extract changelog for this specific version from changelog.txt
  ```

### 5. Commit Process
- [ ] Stage all changes with `git add -A`
- [ ] Create descriptive commit message:
  ```
  chore(release): update RND to version X.X.X
  
  - [List main changes]
  - [Include bug fixes]
  - [Note new features]
  
  🤖 Generated with [Claude Code](https://claude.ai/code)
  
  Co-Authored-By: Claude <noreply@anthropic.com>
  ```

### 6. Tag and Push
- [ ] Create annotated tag: `git tag -a vX.X.X -m "Release vX.X.X - Brief description"`
- [ ] Push to remote: `git push origin main --tags`

### 7. Post-Release Verification
- [ ] Verify GitHub Actions workflow triggered
- [ ] Check Discord notification sent with correct changelog
- [ ] Confirm release appears on GitHub releases page

## Important Notes

### Changelog Format for Discord
The Discord webhook in the GitHub workflow expects the changelog to be formatted properly. The workflow:
1. Extracts changelog from `docs/CHANGES.md` (per .pkgmeta specification)
2. Gets only the current version's changes (not the entire history)
3. Preserves the "- " bullet format from CHANGES.md

**How it works**:
```bash
# Extract current version changelog only
VERSION="${{ steps.extract_version.outputs.version }}"
CHANGELOG_RAW=$(awk "/^## v${VERSION}/{flag=1; next} /^## v[0-9]/{flag=0} flag && /^-/" docs/CHANGES.md | head -20)
```

This ensures Discord notifications only show what changed in the specific release.

### Version Consistency
All version numbers must match across:
- `data/core.lua` (ADDON_VERSION constant and header comment)
- All TOC files (## Version: field)
- Git tag (vX.X.X format)
- Changelog entry header

### Discord Notification
The Discord webhook expects:
- Version number from TOC file
- Changelog from extraction step
- Proper formatting with bullet points
- RGX Mods branding

## Usage

When asked to create a release:
1. Ask for the new version number if not provided
2. Ask for a summary of changes if not provided
3. Follow the checklist above systematically
4. Use TodoWrite tool to track progress
5. Verify each step before proceeding to the next

## Common Issues to Check

1. **Mismatched Versions**: Ensure all files have the same version
2. **Missing Changelog**: Always update changelog.txt before release
3. **Uncommitted Changes**: Never create a release with uncommitted changes
4. **Wrong Branch**: Always release from main branch
5. **Changelog Format**: Ensure changelog is properly formatted for Discord extraction

## Command Sequence

```bash
# 1. Check status
git status
git branch

# 2. Update files (use Edit tool for each)
# - core.lua
# - all TOC files
# - changelog.txt

# 3. Stage and commit
git add -A
git commit -m "chore(release): update RND to version X.X.X ..."

# 4. Tag and push
git tag -a vX.X.X -m "Release vX.X.X - Description"
git push origin main --tags
```

This agent ensures a complete and consistent release process every time.