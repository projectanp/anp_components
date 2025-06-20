#!/bin/bash

# --- Configuration ---
# Set the name of your package from package.json for clarity in messages
# Using grep and sed to robustly extract the package name from package.json
PACKAGE_NAME=$(grep '"name":' package.json | head -1 | sed 's/"name": "\(.*\)",/\1/' | tr -d '[:space:]')

# Debugging: Print the detected package name
echo "Debug: Detected package name: '${PACKAGE_NAME}'"

# Check if the package is scoped (starts with @) and requires --access public

ACCESS_FLAG="--access public"


# --- Helper Functions ---

# Function to display error messages and exit
error_exit() {
  echo "❌ Error: $1" >&2
  exit 1
}

# Function to check for required commands
check_commands() {
  echo "🚀 Checking for required commands..."
  command -v npm >/dev/null || error_exit "npm is not installed. Please install Node.js and npm."
  echo "✅ All required commands found."
}

# Function to clean the build directory
clean_build() {
  echo "✨ Cleaning the 'dist' directory..."
  npm run clean || error_exit "Failed to clean 'dist' directory. Check your 'clean' script in package.json."
  echo "✅ 'dist' directory cleaned."
}

# Function to build the package
build_package() {
  echo "📦 Building the package for CJS, ESM, and type declarations..."
  npm run build || error_exit "Failed to build the package. Check your 'build' script and Rollup configuration."
  echo "✅ Package built successfully."
}

# Function to perform a dry run (npm pack)
pack_test() {
  echo "🔍 Performing a dry run with 'npm pack' to verify package contents..."
  npm pack
  if [ $? -ne 0 ]; then
    error_exit "'npm pack' failed. Please check for errors in your package.json or build output."
  fi
  echo "✅ 'npm pack' successful. A .tgz file has been created, simulating the published package."
  echo "   You can test this .tgz file in another project using 'npm install /path/to/your-package.tgz'"
}

# Function to publish the package to npm
publish_package() {
  echo ""
  # Explicitly check if PACKAGE_NAME is empty before attempting publish
  if [ -z "$PACKAGE_NAME" ]; then
    error_exit "Package name could not be determined from 'package.json'. Please ensure 'package.json' exists and has a 'name' field."
  fi

  read -p "❓ Do you want to publish '${PACKAGE_NAME}' to npm? (y/N): " confirm_publish
  if [[ "$confirm_publish" =~ ^[Yy]$ ]]; then
    echo "🔑 Please ensure you are logged into npm (npm login)."
    echo "🚀 Publishing ${PACKAGE_NAME} to npm..."
    npm publish "$ACCESS_FLAG" || error_exit "Failed to publish the package. Check your npm login status, permissions, or package name/version."
    echo "🎉 Successfully published '${PACKAGE_NAME}' to npm!"
    echo "   View your package at: https://www.npmjs.com/package/${PACKAGE_NAME}"
  else
    echo "Skipping npm publish."
  fi
}

# --- Main Script Execution ---

echo "--- NPM Library Build & Publish Script ---"

check_commands
clean_build
build_package
pack_test
publish_package

echo "--- Script Finished ---"