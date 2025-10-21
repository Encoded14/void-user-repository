# Void-User-Repository

## DISCLAIMER

This project is **not affiliated with or endorsed by the Void Linux project** or its maintainers.
It is an **unofficial community tool** designed to simplify managing and building user-contributed packages using the void-packages build system.
Use at your own discretion.

## Overview
A collection of template files for building packages on Void Linux.
Includes a helper script, vay, which simplifies local package building and installation.
If you dont wish to build the packages locally, this repository also provides prebuilt binaries in the releases. Information on how to easily download and install them go to [Prebuilt binaries](#prebuilt-binaries).

## The `vay` script

`vay` works similarly to AUR helpers on Arch Linux.
Automatically performs the actions needed to build the packages locally on your system.
If you prefer to do this manually go to [Manually building](#manually-building)

## Installation

1. Start by cloning this repository.
```
git clone https://github.com/Encoded14/void-user-repository.git
```
2. Change into the cloned directory:
```
cd void-user-repository
```
3. Create `~/.local/bin` if it doesn’t already exist:
```
mkdir -p ~/.local/bin
```
4. Symlink the helper script:
```
ln -sf "$(realpath vay.sh)" "$HOME/.local/bin/vay"
```
5. Run the helper by typing vay followed by one or more package names:
```
vay <package1> <package2> ...
```

## Prebuilt binaries

Currently prebuilt binary packages are provided for the following architectures:
- x86_64-glibc
- x86_64-musl

1. Create an entry in /etc/xbps.d/ and add this repository. This can be done with the following command:
```
echo repository=https://github.com/Encoded14/void-user-repository/releases/latest/download | sudo tee /etc/xbps.d/20-void-user-repository.conf
```
2. Refresh your repositories and accept the fingerprint:
```
sudo xbps-install -S
```
3. You are now able to search through all of the packages in this repository, and install them as usual:
```
xbps-query -Rs hypr
sudo xbps-install -S hyprland 
```

## Manually building
1. Clone both this repository as well as [void-packages](https://github.com/void-linux/void-packages):
```
git clone https://github.com/Encoded14/void-user-repository.git
git clone https://github.com/void-linux/void-packages.git
```
2. Copy the templates files from this repository into void-packages:
```
cp -r void-user-repository/srcpkgs/* void-packages/srcpkgs/
```
3. Edit shlibs by removing the lines found in shlibs_remove and appending the lines from shlibs_append.
4. Bootstrap the build system:
```
cd void-packages
./xbps-src binary-bootstrap
```
5. Build the packages you want:
```
./xbps-src pkg <package1> <package2> ...
```
6. Install the built packages:
```
sudo xbps-install --repository /hostdir/binpkgs/ <package1> <package2> ...
```

### Running Hyprland

In order to run Hyprland you will need to install some additional packages which will depend on your setup, for example a [session and seat manager](https://docs.voidlinux.org/config/session-management.html) and [graphics drivers](https://docs.voidlinux.org/config/graphical-session/graphics-drivers/index.html). You may also have to add the user to the `_seatd` group. If you use an Nvidia GPU refer to the [Hyprland Wiki](https://wiki.hyprland.org/Nvidia), but keep in mind that Hyprland does not officially support Nvidia.

### Contributing
Contributions are greatly appreciated. Overall, this repository adheres to the same rules and guidelines as the [official void-packages repository](https://github.com/void-linux/void-packages/blob/master/CONTRIBUTING.md). The main difference is that here, you’re welcome to add template files for Chromium or Firefox forks if they provide additional value beyond changing certain settings or configuration files.

### Credits
[Makrennel: hyprland-void](https://github.com/Makrennel/hyprland-void): Hyprland template files
