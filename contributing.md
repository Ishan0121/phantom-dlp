# Contributing to Phantom-DLP

Thank you for your interest in contributing to Phantom-DLP! This document provides guidelines and information for contributors.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Contribution Guidelines](#contribution-guidelines)
- [Code Style](#code-style)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Bug Reports](#bug-reports)
- [Feature Requests](#feature-requests)

## 🤝 Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct:

- **Be respectful** - Treat everyone with respect and kindness
- **Be collaborative** - Work together to improve the project
- **Be helpful** - Help newcomers and share knowledge
- **Be constructive** - Provide helpful feedback and suggestions
- **Be patient** - Remember that everyone has different skill levels

## 🚀 Getting Started

### Prerequisites

- Bash 4.0+ (for development and testing)
- yt-dlp (latest version recommended)
- ffmpeg (latest version recommended)
- Git (for version control)
- A text editor or IDE of your choice

### Quick Start

1. **Fork** the repository on GitHub
2. **Clone** your fork locally:
   ```bash
   git clone https://github.com/yourusername/phantom-dlp.git
   cd phantom-dlp
   ```
3. **Create** a new branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Make** your changes and test thoroughly
5. **Commit** and **push** your changes
6. **Create** a Pull Request

## 🛠️ Development Setup

### Environment Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/phantom-dlp.git
cd phantom-dlp

# Make the script executable
chmod +x phantom-dlp.sh

# Test the script
./phantom-dlp.sh
```

### Development Tools

Recommended tools for development:

- **ShellCheck** - Static analysis for shell scripts
  ```bash
  # Install ShellCheck
  sudo pacman -S shellcheck  # Arch Linux
  sudo apt install shellcheck  # Ubuntu/Debian
  
  # Check the script
  shellcheck phantom-dlp.sh
  ```

- **Bash Language Server** - For IDE integration
- **Git hooks** - For automated testing

## 📝 Contribution Guidelines

### Types of Contributions

We welcome various types of contributions:

- **Bug fixes** - Fix existing issues
- **New features** - Add new functionality
- **Documentation** - Improve docs and comments
- **Testing** - Add or improve tests
- **Performance** - Optimize existing code
- **UI/UX** - Improve user interface and experience

### Before You Start

1. **Check existing issues** - Look for similar problems or requests
2. **Create an issue** - Discuss your idea before implementing
3. **Get feedback** - Make sure your contribution is wanted
4. **Follow guidelines** - Read this document thoroughly

## 🎨 Code Style

### Bash Scripting Standards

- **Indentation**: Use 4 spaces (no tabs)
- **Line length**: Keep lines under 100 characters when possible
- **Quoting**: Always quote variables: `"$variable"`
- **Error handling**: Use `set -euo pipefail` and proper error checks
- **Functions**: Use lowercase with underscores: `function_name()`

### Code Structure

```bash
#!/bin/bash

# Script header with description
# Version and author information

set -euo pipefail

# Constants and configuration
CONSTANT_VALUE="value"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Functions
function_name() {
    local param="$1"
    # Function body
    echo "Result: $param"
}

# Main execution
main() {
    # Main logic
}

# Run main function
main "$@"
```

### Variable Naming

- **Constants**: ALL_CAPS with underscores
- **Global variables**: CamelCase or snake_case
- **Local variables**: lowercase with underscores
- **Functions**: lowercase with underscores

### Comments

- Use `#` for single-line comments
- Add function descriptions above function definitions
- Comment complex logic and non-obvious code
- Include TODO/FIXME comments for future improvements

Example:
```bash
# Download video with quality fallback mechanism
# Args:
#   $1 - Video URL
#   $2 - Preferred quality
# Returns:
#   0 on success, 1 on failure
download_with_fallback() {
    local url="$1"
    local quality="$2"
    
    # TODO: Add more quality options
    # Try primary quality first
    if ! yt-dlp --format "$quality" "$url"; then
        # Fallback to best available
        yt-dlp --format "best" "$url"
    fi
}
```

## 🧪 Testing

### Manual Testing

Before submitting changes:

1. **Basic functionality** - Test core download features
2. **Error handling** - Test with invalid URLs and inputs
3. **Edge cases** - Test boundary conditions
4. **Multiple platforms** - Test with different video sites
5. **Configuration** - Test settings and persistence
6. **Installation** - Test installation methods

### Test Cases

Create test cases for new features:

```bash
# Test different URL formats
test_urls=(
    "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    "https://youtu.be/dQw4w9WgXcQ"
    "https://www.youtube.com/playlist?list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab"
)

# Test invalid inputs
test_invalid_inputs() {
    # Test empty URL
    # Test malformed URL
    # Test non-existent video
}
```

### Shell Script Testing

Use ShellCheck for static analysis:
```bash
shellcheck -x phantom-dlp.sh
```

Common issues to avoid:
- Unquoted variables
- Unused variables
- Incorrect exit codes
- Missing error handling

## 📤 Submitting Changes

### Pull Request Process

1. **Update documentation** - Include relevant documentation changes
2. **Test thoroughly** - Ensure all functionality works
3. **Create clear commits** - Use descriptive commit messages
4. **Submit PR** - Include detailed description of changes

### Commit Message Format

Use clear, descriptive commit messages:

```
feat: add live stream recording with duration control

- Implement duration-based recording for live streams
- Add timeout mechanism for limited recordings
- Update menu with new live stream options
- Add error handling for stream unavailability

Fixes #123
```

**Commit Types:**
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes
- `refactor:` - Code refactoring
- `test:` - Adding tests
- `chore:` - Maintenance tasks

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Code refactoring

## Testing
- [ ] Tested locally
- [ ] Tested with multiple platforms
- [ ] Tested edge cases
- [ ] ShellCheck passed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes
```

## 🐛 Bug Reports

### Before Reporting

1. **Check existing issues** - Search for similar problems
2. **Test latest version** - Ensure bug exists in current version
3. **Reproduce consistently** - Verify the bug is reproducible

### Bug Report Template

```markdown
**Bug Description**
Clear description of the bug

**Steps to Reproduce**
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected Behavior**
What you expected to happen

**Actual Behavior**
What actually happened

**Environment**
- OS: [e.g., Arch Linux]
- Phantom-DLP Version: [e.g., 1.0.0]
- yt-dlp Version: [output of `yt-dlp --version`]
- Bash Version: [output of `bash --version`]

**Additional Context**
- Error messages
- Log output
- Screenshots (if applicable)
- Example URLs (if not sensitive)
```

## 💡 Feature Requests

### Before Requesting

1. **Check existing requests** - Look for similar feature requests
2. **Consider scope** - Ensure feature fits project goals
3. **Think about implementation** - Consider technical feasibility

### Feature Request Template

```markdown
**Feature Description**
Clear description of the requested feature

**Use Case**
Why is this feature needed? What problem does it solve?

**Proposed Solution**
How do you envision this feature working?

**Alternatives Considered**
Other ways to achieve the same goal

**Additional Context**
- Screenshots or mockups
- Similar features in other tools
- Technical considerations
```

## 📚 Documentation

### Documentation Standards

- **Clarity** - Write clear, concise documentation
- **Examples** - Include practical examples
- **Completeness** - Cover all features and options
- **Maintenance** - Keep documentation up-to-date

### Areas Needing Documentation

- **README.md** - Main project documentation
- **CONTRIBUTING.md** - This file
- **Code comments** - Inline documentation
- **Function documentation** - Parameter and return descriptions
- **Installation guides** - Platform-specific instructions
- **Troubleshooting** - Common issues and solutions

## 🏆 Recognition

Contributors will be recognized in:

- **Contributors section** in README.md
- **Changelog** for significant contributions
- **Special mentions** for major features or fixes

## 📞 Getting Help

If you need help with contributing:

1. **GitHub Issues** - Ask questions in issues
2. **GitHub Discussions** - Community discussions
3. **Code Review** - Request review of your changes

## 🎯 Project Goals

Keep these goals in mind when contributing:

- **User-friendly** - Maintain intuitive interface
- **Reliable** - Ensure robust error handling
- **Performant** - Optimize for speed and efficiency
- **Maintainable** - Write clean, readable code
- **Compatible** - Support multiple platforms and formats

Thank you again for contributing to Phantom-DLP! Your help makes this project better for everyone.