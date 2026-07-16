# mpv portable_config

This repository contains personal configuration files for [Zhongfly's Windows mpv build](https://github.com/zhongfly/mpv-winbuild) stored in `portable_config` folder of mpv binary's root directory.

The author intends to achieve two goals with this `README.md`:

1. Document the plugins the author relies on.

2. Provide specific recommendations and references concerning the use of mpv in a Windows environment.

## How does `portable_config` work?

[According to mpv documentation:](https://mpv.io/manual/master/#files-on-windows)

> If a directory named portable_config next to the mpv.exe exists, all config will be loaded from this directory only. Watch later config files and cache files are written to this directory as well. (This exists on Windows only and is redundant with $MPV_HOME. However, since Windows is very scripting unfriendly, a wrapper script just setting $MPV_HOME, like you could do it on other systems, won't work. portable_config is provided for convenience to get around this restriction.)

mpv on Windows can be ran from arbitrary locations without being registered to the system, and `portable_config` makes Windows mpv truly portable by allowing your custom settings and scripts to move with your mpv binary.

Even if one does not intend to use mpv like a portable app, `portable_config` should be considerably easier for most users to locate unless they forget where they placed their mpv binary.

The benefits of an easy-to-find quick-to-reach configuration location should not be understated:
* Reduces cognitive load when experimenting settings with an extremely customisable and extensible player. 
* On the rare occasion mpv fails to play a previously playable file, the author's go-to solution is clearing the `cache` and/or `watch_later`.

## Scripts

### [Thumbfast](https://github.com/po5/thumbfast)

A high-performance on-the-fly thumbnailer to fix mpv's lack of native thumbnailer support.

#### Components
* script-opts\thumbfast.conf
* scripts\thumbfast.lua
* scripts\osc.lua
  
As the author prefers the vanilla mpv OSC (On Screen Controller), `osc.lua` is used to adapt thumbfast to work with the vanilla OSC.