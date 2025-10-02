# AtiScript: Arch Linux Install 🚀

This tool is a set of shell scripts that help automate the setup of Arch Linux systems. You can easily install your favorite packages, enable services, and keep your system updated. All with simple commands. This tool is useful for new installations, making routine tasks faster and more consistent.

## Prerequisites ✅

- 🐧 Arch Linux (or Arch-based distribution)
- 🔒 sudo/root access
- 🛠️ `git` and `base-devel` packages are required if you intend to build `yay` from the AUR

## Usage ⚙️

Run the script with one of the following options:

| Option                            | Description                                                                                      |
| --------------------------------- | ------------------------------------------------------------------------------------------------ |
| `-h`, `--help`                    | Display the help message                                                                         |
| `-f`, `--full`                    | Perform a full setup (update system, install package manager, install packages, enable services) |
| `-p`, `--partial`                 | Perform a partial setup (update system, install package manager)                                 |
| `-U`, `--update`                  | Update the system                                                                                |
| `-M`, `--install-package-manager` | Install the AUR package manager (`yay`)                                                          |
| `-P`, `--install-packages`        | Install all packages listed in `packages.conf`                                                   |
| `-S`, `--enable-services`         | Enable services listed in `packages.conf`                                                        |

You can combine options as needed. For example, to update the system and install packages only, you can run:

```bash
sudo ./run.sh -U -P
```

## Installation 📦

1. 📥 Clone this repository to your machine.

2. 🔓 Make the main script executable (if necessary):

```bash
chmod +x run.sh
```

3. ✍️ Edit `packages.conf` to add or remove packages and services according to your needs.

4. ▶️ Run the script with the desired option (example: full setup):

```bash
sudo ./run.sh -f
```
