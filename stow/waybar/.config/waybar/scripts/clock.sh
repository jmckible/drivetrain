#!/bin/bash
# Custom clock script for waybar
# Shows date/time without leading zeros (e.g., "February 1" not "February 01", "9:29 AM" not "09:29 AM")
# This is a temporary workaround until waybar supports %-d and %-I format in built-in clock module
# See waybar config.jsonc for details and TODO to revert when fixed
date '+%A %B %-d %-I:%M %p'
