#!/usr/bin/env bash
if [ -e /sys/devices/system/cpu/amd_pstate/cpb ]; then
    CPB=$(cat /sys/devices/system/cpu/amd_pstate/cpb)
elif [ -e /sys/devices/system/cpu/cpufreq/boost ]; then
    CPB=$(cat /sys/devices/system/cpu/cpufreq/boost)
else
    echo '{"text": "❓ CPU?", "class": "unknown"}'
    exit 0
fi
GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)
if [ "$CPB" = "1" ] || [ "$GOVERNOR" = "performance" ]; then
    echo '{"text": "⚡️ TURBO", "class": "turbo"}'
else
    echo '{"text": "🧊 NORMAL", "class": "normal"}'
fi
