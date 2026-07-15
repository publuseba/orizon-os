#!/bin/bash
# ORIZON System Updater
[[ $EUID -ne 0 ]] && exec sudo "$0" "$@"

echo ""
echo "  ╔══════════════════════════════════╗"
echo "  ║     ORIZON APT Updater Script    ║"
echo "  ╚══════════════════════════════════╝"
echo ""
echo "  [1/3] Updating package lists..."
apt-get update -qq
echo "  [2/3] Upgrading packages..."
apt-get upgrade -y
echo "  [3/3] Cleaning up..."
apt-get autoremove -y -qq && apt-get autoclean -qq
echo ""
echo "  ✓ ORIZON updated!"
echo ""
