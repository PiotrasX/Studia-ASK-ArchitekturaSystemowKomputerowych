@echo off
nasm sequence-exe.asm -o sequence-exe.o -f win32
gcc sequence-exe.o -o sequence-exe.exe -m32
sequence-exe.exe