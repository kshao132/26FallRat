# Guide 1 fixes for Kevin

These changes extend commit 88cf2bb (Ready to upload first test).
Guide 1 now includes the one-second hold-to-DFU feature. Guide 2 is not implemented.

## Copy only the firmware fixes

Copy these three files from this branch into the matching paths in your project:

- Core/Src/main.c
- Core/Src/stm32f4xx_it.c
- STM32F411xx_FLASH.ld

The firmware commits are "Fix Guide 1 button GPIO setup and interrupt handling"
and "Complete Guide 1 hold-to-DFU with persistent flag linker section".
The separate Windows tooling commit is optional; keep your existing Mac tasks if needed.

### What changed

1. main.c / MX_GPIO_Init: enable GPIOC, initialize PC13 as a push-pull output
   initially HIGH (LED off), and configure PA0 with a pull-up and interrupts
   on both rising and falling edges. Enable EXTI0 in the NVIC.
2. main.c / HAL_GPIO_EXTI_Callback: read Button_GPIO_Port (GPIOA), not GPIOC.
   Keep the existing active-low LED behavior.
3. stm32f4xx_it.c: add EXTI0_IRQHandler, forwarding Button_Pin to the HAL.

### CubeMX regeneration

The .ioc already stores the button/LED settings. CubeMX should generate their
initialization and interrupt handler when you regenerate code. Our temporary
EXTI0_IRQHandler is in USER CODE BEGIN 1. If CubeMX creates another definition,
remove the temporary one: keep exactly one EXTI0_IRQHandler in the project.
Keep the button callback in its USER CODE section.

### Validation

The Debug firmware builds successfully with ST Arm Clang 21.1.1+st.7.
Sunil reported a successful DFU upload after installing the Windows USB driver.
Confirm on your board that KEY held means LED on, and released means LED off.
Sunil also confirmed that holding KEY triggers the blinks and the board appears
as USB1 in DFU mode. Short presses retain the original LED behavior.
The linker script marks .noinit NOLOAD so the flag survives the application startup
and is not sent as RAM download data during DFU flashing.
Press NRST with BOOT0 released to return from DFU to the application.
