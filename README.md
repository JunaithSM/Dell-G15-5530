# Dell-G15-5530
This is a fan controller for Dell G15 5530. Only for Dell G15 5530 laptop. Use at your own risk.

###### Note: It worked in arch for me.
```
git clone https://github.com/JunaithSM/Dell-G15-5530-fan-controller.git
```

## Install

```
acpi
acpi_call-dkms
```

## Usage

Allways run with `sudo`.

```
cd Dell-G15-5530
sudo ./setup 
sudo ./fan -h
```


## Turbo Key
This is will bind the key with G-Key

```
sudo nohup ./turbo &
```
