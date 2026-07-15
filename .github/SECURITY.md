# Security Policy

## Supported Versions

Orizon-OS tracks Ubuntu LTS releases. Security fixes are provided for the
following:

| Version / Base | Supported |
|---|---|
| Ubuntu 24.04 LTS and newer | ✅ |
| Ubuntu 23.10 and older | ❌ |

## Reporting a Vulnerability

Because `install-kde.sh` runs with `sudo` and modifies system configuration,
security issues in the installer or bundled configs (e.g. a script that
downloads a resource over an insecure connection, overly-permissive file
permissions, or a config that weakens the system's security posture) should
be reported privately rather than as a public issue.

**Please do not open a public GitHub issue for security vulnerabilities.**

Instead:

1. Use GitHub's [private vulnerability reporting](https://github.com/publuseba/orizon-os/security/advisories/new)
   feature (Security tab → Report a vulnerability), or
2. Contact a maintainer directly through their GitHub profile.

Please include:

- A description of the vulnerability and its potential impact
- Steps to reproduce (a fresh Ubuntu VM snapshot is ideal for this)
- Any relevant script output or logs

## What to Expect

- Acknowledgment of your report within a reasonable time frame
- An assessment of severity and, if valid, a plan for a fix
- Credit in the release notes once a fix is published (unless you prefer to
  remain anonymous)

## Scope

This policy covers the install script, bundled configuration files, and
theme/branding assets in this repository. It does not cover vulnerabilities
in Ubuntu itself or in upstream KDE/Plasma packages — those should be
reported to the respective upstream projects.
