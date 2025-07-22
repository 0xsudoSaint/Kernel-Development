Legacy x86 Kernel
A simple legacy-style x86 kernel focused on demonstrating low-level system programming concepts, built from scratch using assembly and C.

📜 Features Implemented
🛠️ Single Stage Bootloader
Boots directly from BIOS in 16-bit real mode.

Switches from unprotected 16-bit mode to 32-bit protected mode.

🎥 Basic Video Driver
Direct hardware access for screen output.

Supports basic text rendering without relying on BIOS after boot.

💾 Disk Access
Reads sectors using LBA (Logical Block Addressing).

⚡ Custom Interrupt Service Routines (ISRs) (In process)
Custom ISRs written for interrupt handling.

Manually configured the Interrupt Vector Table (IVT) for ISR dispatch.

⌨️ Keyboard and Screen I/O (in process)
Handled keyboard inputs using BIOS interrupts and polling.

Managed screen output via direct memory manipulation (VGA text mode).

🧠 Memory Segmentation and Control
Implemented basic memory segmentation.

Controlled execution flow within real-mode and protected-mode environments.

⚙️ Build & Run

To build use(from the main directory):

# build kernel
./build

# to clean binaries use (in main directory):
make clean


# Run using QEMU ( you have to be in bin directory for this)
qemu-system-x86_64 -hda os.bin

#Please not the this is just a personal project to learn more about system working , errors and omissions are expected. Also the work is in progress as of now.
