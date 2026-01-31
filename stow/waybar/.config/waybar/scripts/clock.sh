#!/bin/bash
# Custom clock script for waybar
# Shows time without leading zeros on single-digit hours (e.g., "9:29 AM" not "09:29 AM")
# This is a temporary workaround until waybar supports %-I format in built-in clock module
# See waybar config.jsonc for details and TODO to revert when fixed
date '+%A %B %d %-I:%M %p'
