# Release checklist

## Content
- [ ] Every skill has valid frontmatter and a useful description.
- [ ] Skills are focused and avoid contradictory rules.
- [ ] Third-party sources, licenses, and notices have been reviewed.
- [ ] No secrets, private data, or proprietary content are present.

## Validation
- [ ] `bash scripts/validate-skills.sh` passes.
- [ ] Preview discovery with `npx skills add OWNER/REPO --list`.
- [ ] Test installation in a disposable user/project environment.
- [ ] Confirm skills appear in OpenCode.
- [ ] Test at least one representative task per skill category.
- [ ] Confirm no runtime, package, browser, or MCP setup is falsely implied.

## Release
- [ ] Update changelog/release notes.
- [ ] Tag the version.
- [ ] Verify install command in README.
- [ ] Review licenses and notices one final time.
