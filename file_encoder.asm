; Program to read a message from a file and display it in a message box

.386
.model flat, stdcall
option casemap :none

; External procedure declarations
extrn CreateFileA :PROC
extrn ReadFile :PROC
extrn CloseHandle :PROC
extrn MessageBoxA :PROC
extrn ExitProcess :PROC

; Constants
#DEFINE GENERIC_READ  0x80000000
#DEFINE OPEN_EXISTING 3
#DEFINE FILE_SHARE_READ 1
#DEFINE INVALID_HANDLE_VALUE -1

.data
    filename db "message.txt", 0   ; The name of the file to read
    msg db 256 dup(0)               ; Buffer to store read message
    bytesRead dq 0                  ; Number of bytes read
    hFile dq 0                      ; Handle for the file

.code

Start PROC
    ; Create the file handle
    invoke CreateFileA, addr filename, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL
    mov hFile, eax                  ; Store the file handle

    ; Check if the file was opened successfully
    cmp hFile, INVALID_HANDLE_VALUE
    je exit                         ; If not, exit

    ; Read from the file
    invoke ReadFile, hFile, addr msg, 256, addr bytesRead, NULL

    ; Close the file handle
    invoke CloseHandle, hFile

    ; Display the message in a message box
    invoke MessageBoxA, NULL, addr msg, addr msg, 0

exit:
    ; Exit cleanly
    invoke ExitProcess, 0
Start ENDP
End Start
