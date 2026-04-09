# MedOS 2

MedOS is a custom Linux distribution based on Debian, designed to provide a clean, minimal, and reproducible system build.

This project allows you to generate a full root filesystem using a single build script.

---

## ⚙️ Features

- Debian-based (trixie)
- ARM64 support
- Automated root filesystem creation
- First boot user setup (username + password)
- Systemd integration
- Reproducible build system

---

## 🚀 Quick Start

Clone the repository:

```
git clone https://github.com/MedOS-Offical/MedOS-2-Build.git
cd MedOS-2-Build
```

Make the build script executable:

```
chmod +x build.sh
```

Run the build:

```
./build.sh
```

---

## 🧠 How It Works

- `build.sh` automatically:
  - Installs required tools (if missing)
  - Uses `debootstrap` to create a base system
  - Configures system files inside a chroot environment
  - Sets up a first boot user creation service

- On first boot:
  - The system will prompt for a username and password
  - A user account will be created automatically

---

## 📁 Output

After build, the root filesystem will be located in:

```
./rootfs
```

---

## ⚠️ Requirements

### Linux

- A Linux system (Ubuntu, Debian, Kali, etc.)
- Internet connection
- sudo privileges

### Windows

This project does not run natively on Windows.

To use it on Windows, you must use:

- WSL (Windows Subsystem for Linux)  
- Virtual Machine (VirtualBox, VMware, etc.)

---

## 🛠️ Notes

- This project is in early development.
- Kernel, bootloader, and image generation are not yet included.
- Designed for experimentation and learning purposes.

---

## 📌 Future Plans

- Kernel integration
- Bootable image generation
- GUI installer
- ISO creation
- Hardware support improvements

---

## 📄 License

MIT License

---

## 🤝 Contributing

Pull requests are welcome.
