# Setting Up GitHub Releases

This guide explains how to set up and use the automated release workflow.

## Prerequisites

1. **Push the workflow file to GitHub:**
   ```bash
   git add .github/workflows/release.yml
   git commit -m "Add release workflow"
   git push
   ```

2. **Verify workflow file location:**
   - The file must be at: `.github/workflows/release.yml`
   - GitHub will automatically detect it

## How to Create a Release

### Method 1: Via GitHub Web Interface (Recommended)

1. Go to your repository on GitHub
2. Click **"Releases"** in the right sidebar (or go to `https://github.com/dvdbits/leaf/releases`)
3. Click **"Create a new release"**
4. Fill in:
   - **Tag version**: e.g., `v0.1.0` (must start with `v`)
   - **Release title**: e.g., `v0.1.0` or `Leaf v0.1.0`
   - **Description**: Add release notes
5. **Important**: Check **"Set as the latest release"**
6. Click **"Publish release"**

The workflow will automatically:
- Build binaries for macOS (x86_64, arm64)
- Build binaries for Linux (x86_64, arm64)
- Attempt to build Windows executable (experimental)
- Attach all binaries to the release

### Method 2: Via Git Tags

```bash
# Create and push a tag
git tag v0.1.0
git push origin v0.1.0

# Then create the release on GitHub (the workflow triggers on release creation, not just tags)
```

## What Happens Automatically

1. **Workflow triggers** when you create a release
2. **Builds run in parallel** for all platforms
3. **Binaries are attached** to the release automatically
4. **Users can download** the appropriate binary for their platform

## Troubleshooting

### Workflow doesn't trigger
- Make sure the workflow file is in `.github/workflows/release.yml`
- Check that you created a **Release** (not just a tag)
- Verify the workflow file is committed and pushed

### Build fails
- Check the Actions tab in GitHub for error messages
- macOS/Linux builds should work reliably
- Windows build may fail (Swift on Windows is experimental) - this is okay, other builds will still succeed

### Binaries not attached
If binaries don't appear on your release:
- Check the "release" job logs in the Actions tab for errors
- Verify at least macOS and Linux builds succeeded (Windows is optional)
- Note: `GITHUB_TOKEN` permissions are automatic - no action needed

### View workflow runs
- Go to **Actions** tab in your GitHub repository
- Click on the workflow run to see logs

## Manual Testing

You can test the workflow without creating a release:

1. Go to **Actions** tab
2. Click **"Release"** workflow
3. Click **"Run workflow"** button
4. This will run the workflow manually (though it won't attach to a release)

## Release Asset Names

The workflow creates these files:
- `leaf-macos-x86_64`
- `leaf-macos-arm64`
- `leaf-linux-x86_64`
- `leaf-linux-arm64`
- `leaf.exe` (if Windows build succeeds)

Users can download the appropriate one for their platform.

