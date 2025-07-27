# Dell-G15-5530 Fan Controller

A custom **fan control tool for Dell G15 5530 laptops** — works only on this specific model.
> ⚠️ **Use at your own risk.** This tool directly interfaces with your system's EC (Embedded Controller).

 Tested and working on **Arch Linux**.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/JunaithSM/Dell-G15-5530-fan-controller.git
```

### Dependencies

Make sure you have these installed:

* `acpi`
* `acpi_call-dkms`

### Arch Linux

Install with an AUR helper like `yay`:

```bash
yay -S acpi_call-dkms
yay -S acpi
```

---

## Usage

Always run as **root** (or with `sudo`), as the script interacts with kernel-level interfaces.

```bash
cd Dell-G15-5530-fan-controller
sudo ./setup
```

```
sudo fan -h    # Show help
```
---

## Turbo Key (G-Key) Support

This binds your laptop's dedicated **G-Key** (usually called TurboKey) to control the fan profile automatically.

Run it in the background:

```bash
sudo nohup turbo &
```

---



## Notes

* `setup` configures a custom udev rule and permissions.
* `fan` lets you manually set fan speeds.
* `turbo` listens for your G-Key and toggles performance mode.


Here’s a clearer and more polished way to write that note in your `README.md`:

---
