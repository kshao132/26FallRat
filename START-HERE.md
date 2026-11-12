# Sunil's Micromouse setup

## Open and build

Open this folder in VS Code (the folder containing CMakeLists.txt, not its parent).
Press Ctrl+Shift+B and choose **Build Rat** if prompted.
The compiled firmware is `build/Debug/26Fall_Rat.elf`.

Alternative from a PowerShell terminal in this folder:

```powershell
./tools/rat.ps1 -Action Build
```

The helper locates ST's installed CLI automatically, so no global PATH changes are needed.
VS Code, STM32CubeIDE extensions, ST Arm Clang 21.1.1+st.7, CMake, Ninja,
CubeProgrammer, CubeMX 6.18.1 and Teleplot are available. The Debug build was verified locally.

## What was copied and fixed

Source: https://github.com/kshao132/26FallRat
Local branch: codex/windows-setup. See GUIDE1-CHANGES.md for the portable firmware fixes.

The upstream .ioc specifies PA0 as an interrupt input and PC13 as the LED,
but the checked-in generated C omitted their GPIO initialization and EXTI handler.
This local version initializes those pins, enables EXTI0, and reads the button
from GPIOA rather than GPIOC. The firmware should light the active-low blue LED
while KEY is pressed and turn it off on release. Confirm both behaviors on the board.
The existing .ioc already stores the matching pin configuration, so regenerating
from that file should produce the GPIO setup and interrupt handler automatically.

## Flash when the board is available

1. Connect a USB data cable to the Black Pill. For this LED test, the rat's battery switch can stay off.
2. Hold BOOT0, press and release NRST, then release BOOT0.
3. In VS Code use Terminal > Run Task > List DFU devices. Expect a device on USB1.
4. Run **Flash via DFU (CubeProgrammer)**. This builds first, writes the ELF, verifies it, and starts it.
5. Press NRST if needed, then test KEY and the blue LED.

The equivalent command is `./tools/rat.ps1 -Action Flash`.
If DFU is not detected, check the cable, repeat the buttons, and inspect Device Manager.
A yellow warning on STM32 Bootloader means the DFU driver still needs installation;
use ST's CubeProgrammer driver installer as described in Guide 1.
The Windows DFU driver was subsequently installed, USB1 was detected successfully, and Sunil reported a successful upload.

CubeMX is installed at `C:/Users/sunil/AppData/Local/Programs/STM32CubeMX/STM32CubeMX.exe`.
When regenerating, CubeMX may ask to download STM32Cube FW_F4 V1.28.3; the repository already includes the drivers needed to build.

## Guide 1 hold-to-DFU

Hold KEY for one second: the LED blinks three times, then the board enters DFU.
KEY will stop controlling the LED while in DFU; this is expected.
Run List DFU devices to confirm USB1, then flash again without BOOT0.
Press NRST with BOOT0 released to return to the application without uploading.
Sunil confirmed successful uploading and USB1 detection after the hold gesture.
The persistent flag requires the .noinit NOLOAD section in STM32F411xx_FLASH.ld.

## Guide 2 is not in Kevin's current code

The upstream repository contains no motors.c, encoders.c or timer initialization.
This is not yet motor firmware or a maze solver. To implement Guide 2:

- In CubeMX open the existing 26Fall_Rat.ioc; do not create a different MCU project.
- TIM1 encoder: PA8/PA9, TI1+TI2 mode, period 65535.
- TIM3 encoder: PB4/PB5, TI1+TI2 mode, period 65535. Keep JTAG disabled.
- TIM4 PWM: PB6 right backward, PB7 right forward, PB8 left forward, PB9 left backward.
  Prescaler 0, period 19199 gives 5 kHz at the current 96 MHz timer clock.
- Add the guide's motor/encoder sources and include them in CMakeLists.txt.
- Start the encoders and PWM; initially keep all motor outputs zero.
- Add USB CDC telemetry for Teleplot, then verify wheel direction on the physical rat.

Do not assume motor direction or encoder sign until tested. Keep the wheels raised
for motor testing. The two directions of a motor must not be driven simultaneously.

## Working with Kevin

`git fetch origin` checks for updates. `git diff` shows these local fixes.
Do not overwrite local changes with a fresh download. Review Kevin's newer commits
before merging, particularly if he has a newer working copy he has not pushed.

## Club references

- Guide 1: https://docs.google.com/document/d/16gEGGteUzaCsCuK0esN5bgEJK2ViyIhN-4ntgvc8z8k/edit
- Guide 2: https://docs.google.com/document/d/1kq7jooO0kGSSXLSjOEkV4tb3_lVNwbtwT9Q4k_jFP0E/edit

