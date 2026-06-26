#!/usr/bin/env bash
if [ -e /sys/devices/system/cpu/amd_pstate/cpb ]; then
    CPB=$(cat /sys/devices/system/cpu/amd_pstate/cpb)
elif [ -e /sys/devices/system/cpu/cpufreq/boost ]; then
    CPB=$(cat /sys/devices/system/cpu/cpufreq/boost)
fi
if [ "$CPB" = "1" ]; then
    sudo /run/current-system/sw/bin/perfil-cpu normal
else
    sudo /run/current-system/sw/bin/perfil-cpu turbo
fi
pkill -RTMIN+5 waybar 2>/dev/null
