# Guide 2 work in progress

This branch shares Sunil's current Guide 2 progress, not completed motor firmware.

## Included

- 26Fall_Rat.ioc: saved CubeMX pin, timer and peripheral settings. This is the
  STM32 configuration file to open in CubeMX on another computer.
- Core source and header changes, imported motors/encoders templates, generated
  HAL timer drivers, CMake source lists, and existing VS Code build/flash tasks.
- Guide 1 hold-to-DFU implementation and its .noinit linker section.
- Removed the temporary EXTI0 handler after CubeMX generated the official one.

## Validation and remaining work

The Debug firmware builds after removing the duplicate EXTI0 handler.
Encoder getters and motor functions are still empty templates: implement them
before using their results or attempting motor tests. A successful build does
not establish that Guide 2 is complete or works on the robot.
The .ioc contains TIM4 PWM settings, but the current main.c has no MX_TIM4_Init;
check generation and TIM4 initialization before adding the guide's PWM starts.
The right-motor comment in the imported template says forward CH1/backward CH2;
the current-year guide specifies forward CH2 (PB7)/backward CH1 (PB6).

## Kevin: get this branch

Save or commit any of your own edits first. In a terminal in your repository:

```sh
git fetch origin
git switch --track origin/sunil/guide2-wip
```

If you already have that local branch, switch to it and run git pull --ff-only.
Open the repository folder in VS Code. Open 26Fall_Rat.ioc in CubeMX to view the
same STM32 settings. Installed tools, USB drivers and firmware packages are local
software and are not uploaded to Git; CubeMX may request the matching package.
Windows tasks use PowerShell; retain/adapt your own tasks on macOS.
Review this branch against main on GitHub before merging. Reconfigure and build
after switching; generated build folders are intentionally not tracked.
