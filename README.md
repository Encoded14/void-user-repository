# Void-User-Repository

> [!NOTE]
> This project is **not affiliated with or endorsed by the Void Linux project** or its maintainers.
It is an **unofficial community project** designed to simplify managing and building user-contributed packages using the void-packages build system.
Use at your own discretion.

## Overview
A collection of template files for building packages on Void Linux.
Includes a helper script, vay, which simplifies local package building and installation.
If you don't wish to build the packages locally, this repository also provides prebuilt binaries.

> [!WARNING]
> Prebuilt binaries have moved from releases to a branch-based system. Check below on how to update your /etc/xbps.d/ entry.

<hr>

## Installation
Currently packages are tested on / crosscompiled for the following architectures:
- x86_64
- x86_64-musl
- aarch64
- aarch64-musl

<details>
<summary><b> 🛠️ Manually building </b></summary>
  
1. Clone both this repository as well as [void-packages](https://github.com/void-linux/void-packages):

    ```
    git clone https://github.com/Encoded14/void-user-repository.git
    git clone https://github.com/void-linux/void-packages.git
    ```
2. Copy the template files from this repository into void-packages:

    ```
    cp -r void-user-repository/srcpkgs/* void-packages/srcpkgs/
    ```
3. Edit shlibs by removing the lines found in shlibs_remove and appending the lines from shlibs_append.

    ```
    cd void-packages
    nvim common/shlibs
    ```
4. Bootstrap the build system:

    ```
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

</details>

<details>
<summary><b> 📦 Prebuilt binaries </b></summary>

1. Create an entry in /etc/xbps.d/ and add this repository. (Edit the end of the link with the architecture you require from the list above). This can be done with the following command:
    ```
    echo repository=https://raw.githubusercontent.com/Encoded14/void-user-repository/repository-x86_64 | sudo tee /etc/xbps.d/20-repository-extra.conf
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

</details>

<details>
<summary><b> 🧪 The vay script </b></summary>

Automatically performs the actions needed to build the packages locally on your system.
Note: this script not only works for the extra template files provided in this repository but also for packages not distributed in the Voidlinux mirrors such as nonfree packages (discord, spotify, etc.).

> **Security conscious?**  You can review the script [here](https://raw.githubusercontent.com/Encoded14/void-user-repository/refs/heads/master/vay.sh) before running it. Furthermore, instead of symlinking the script, you can move it into a directory in your $PATH. That way you ensure it won’t change when you update this repository.

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

</details>

<hr>

## Available packages

> [!TIP]
> Want to add one of your own templates? Open a Pull request.
> 
> Need a package that is not allowed in upstream? Open an Issue.

| package | version | maintainer | notes |
|:--------|:--------|:-----------|:------|
| aquamarine                  | 0.9.5   | [Encoded14](https://github.com/Encoded14) | |
| glaze                       | 6.0.1   | [Encoded14](https://github.com/Encoded14) | |
| hyprcursor                  | 0.1.13  | [Encoded14](https://github.com/Encoded14) | |
| hyprgraphics                | 0.2.0   | [Encoded14](https://github.com/Encoded14) | |
| hypridle                    | 0.1.7   | [Encoded14](https://github.com/Encoded14) | |
| hyprland-protocols          | 0.7.0   | [Encoded14](https://github.com/Encoded14) | |
| hyprland-qt-support         | 0.1.0   | [Encoded14](https://github.com/Encoded14) | |
| hyprland-qtutils            | 0.1.5   | [Encoded14](https://github.com/Encoded14) | |
| hyprland                    | 0.51.1  | [Encoded14](https://github.com/Encoded14) | |
| hyprlang                    | 0.6.4   | [Encoded14](https://github.com/Encoded14) | |
| hyprlock                    | 0.9.2   | [Encoded14](https://github.com/Encoded14) | |
| hyprpaper                   | 0.7.5   | [Encoded14](https://github.com/Encoded14) | |
| hyprpicker                  | 0.4.5   | [Encoded14](https://github.com/Encoded14) | |
| hyprpolkitagent             | 0.1.3   | [Encoded14](https://github.com/Encoded14) | |
| hyprsunset                  | 0.3.3   | [Encoded14](https://github.com/Encoded14) | |
| hyprsysteminfo              | 0.1.3   | [Encoded14](https://github.com/Encoded14) | |
| hyprutils                   | 0.10.0  | [Encoded14](https://github.com/Encoded14) | |
| hyprwayland-scanner         | 0.4.5   | [Encoded14](https://github.com/Encoded14) | |
| xdg-desktop-portal-hyprland | 3.4.0   | [Encoded14](https://github.com/Encoded14) | |
| libspng                     | 0.7.4   | [Encoded14](https://github.com/Encoded14) | |
| sdbus-cpp                   | 2.1.0   | [Encoded14](https://github.com/Encoded14) | |
| tomlplusplus                | 3.4.0   | [Encoded14](https://github.com/Encoded14) | |
| ly                          | 1.0.3   | [Encoded14](https://github.com/Encoded14) | compatibility: x86_64 only |
| zen-browser (stable)        | 1.17.4b | [Encoded14](https://github.com/Encoded14) | compatibility: glibc only |

<hr>

### Running Hyprland

In order to run Hyprland you will need to install some additional packages which will depend on your setup, for example a [session and seat manager](https://docs.voidlinux.org/config/session-management.html) and [graphics drivers](https://docs.voidlinux.org/config/graphical-session/graphics-drivers/index.html). You may also have to add the user to the `_seatd` group. If you use an Nvidia GPU refer to the [Hyprland Wiki](https://wiki.hyprland.org/Nvidia), but keep in mind that Hyprland does not officially support Nvidia.

### Contributing
Contributions are greatly appreciated. Overall, this repository adheres to the same rules and guidelines as the [official void-packages repository](https://github.com/void-linux/void-packages/blob/master/CONTRIBUTING.md). The main difference is that here, you’re welcome to add template files for Chromium or Firefox forks if they provide additional value beyond changing certain settings or configuration files.

### Credits
[Makrennel: hyprland-void](https://github.com/Makrennel/hyprland-void): Hyprland template files  
[grvn: void-packages](https://github.com/grvn/void-packages): various template files
