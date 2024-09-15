# Release

This is a guide to know the steps to create a new release.

1. Update the version in [CREATE_PR_VERSION](../create-pr)
1. Update the version in [CHANGELOG.md](../CHANGELOG.md)
1. Build the project `./build.sh bin` - This generates `bin/create-pr` & `bin/checksum`
1. Create a [new release](https://github.com/Chemaclass/create-pr/releases/new) from GitHub
1. Attach `bin/create-pr` and `bin/checksum` to the release
