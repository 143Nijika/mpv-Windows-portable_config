# mpv portable_config

This repository contains the author's configuration files for [Zhongfly's Windows mpv build](https://github.com/zhongfly/mpv-winbuild) stored in `portable_config` folder of mpv binary's root directory.

The author intends to achieve two goals with this `README.md`:

1. Document the scripts (plugins) the author relies on.

2. Provide specific recommendations and references concerning the use of mpv in a Windows environment.

## How does `portable_config` work?

[According to mpv documentation:](https://mpv.io/manual/master/#files-on-windows)

> If a directory named portable_config next to the mpv.exe exists, all config will be loaded from this directory only. Watch later config files and cache files are written to this directory as well. (This exists on Windows only and is redundant with $MPV_HOME. However, since Windows is very scripting unfriendly, a wrapper script just setting $MPV_HOME, like you could do it on other systems, won't work. portable_config is provided for convenience to get around this restriction.)

mpv on Windows can be ran from arbitrary locations without being registered to the system, and `portable_config` makes Windows mpv truly portable by allowing your custom settings and scripts to move with your mpv binary.

Even if one does not intend to use mpv like a portable app, `portable_config` should be considerably easier for most users to locate unless they forget where they placed their mpv binary.

The benefits of an easy-to-find quick-to-reach configuration location should not be understated:
* Reduces cognitive load when experimenting settings with an extremely customisable and extensible player. 
* On the rare occasion mpv fails to play a previously playable file, the author's go-to solution is clearing the `cache` and/or `watch_later`. (This has never failed the author.)

**Anatomy of a `portable_config`**

Partial output of `tree /A` run within the terminal at `portable_config` directory:
```
C:.
+---cache
+---script-opts
+---scripts
+---shaders
\---watch_later
```
`.` in the output represents `portable_config` folder; `.lua` scripts you use go into the `scripts` folder, certain scripts support or require their own `.config` configuration files which go into the `script-opts` folder, and `.glsl` shaders go into the `shaders` folder. (In [certain exotic](https://github.com/classicjazz/mpv-config/tree/master) set-ups, you may also encounter `.hook` files within the `shaders` folder).

Regular scripts and shaders both inject code to modify the behaviour of mpv; shaders influence the graphical rendering process and scripts influence mpv functionalities.

Besides the subfolders listed above, `portable_config` also houses `mpv.conf` and `input.conf`. The former declares your mpv settings and the later declares your keyboard shortcuts. If these two files are absent, mpv follows its default internal configuration.

[mpv upstream's `input.conf`](https://github.com/mpv-player/mpv/blob/master/etc/input.conf) is the author's recommended starting point for a new mpv user seeking to configure their custom keybinds. It is also the way to understand the latest default keybind; useful to long-time users when a default keybind suddenly stops working after updating mpv (which is a rare event but the author has experienced it once concerning right-click behaviour).

[mpv upstream likewise provides a sample `mpv.conf`](https://github.com/mpv-player/mpv/blob/master/etc/mpv.conf), however this sample does not necessarily set default values unlike `input.conf`. Many samples of `mpv.conf` exist online as additional references.

Last but not least, one must not neglect [mpv documentation](https://mpv.io/manual/master/) as a valuable resource for writing their own `mpv.conf` and `input.conf`. It is of the author's opinion that a thorough yet relatively understandable documentation such as mpv's is a rarity in the world of free software.

mpv can be as simple or as complicated as you wish.

## Scripts

### [Thumbfast](https://github.com/po5/thumbfast)

A high-performance on-the-fly thumbnailer to fix mpv's lack of native thumbnailer support.

#### Components
* script-opts\thumbfast.conf
* scripts\osc.lua
* scripts\thumbfast.lua
  
As the author prefers the vanilla mpv OSC (On Screen Controller), `osc.lua` is used to adapt thumbfast to work with the vanilla OSC.