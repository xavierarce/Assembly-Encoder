.data
    filename db 'C:\Users\USER\Desktop\ESGI\Assambleur\24-09-2024\control\lorem_ipsum.txt', 0   ; File path
    buffer db 1024 dup(0)          ; Buffer to store the data read from the file
    encodedBuffer db 1024 dup(0)   ; Buffer for storing the encoded data
    bytesRead DWORD 0              ; Number of bytes read
    msgTitle db 'File Content', 0  ; Title for the MessageBox
    xorKey db 1Ah                  ; XOR key used for encoding
    originalMsg db 'Original Content: ', 0
    encodedMsg db 'Encoded Content: ', 0
    GENERIC_READ equ 80000000h
    OPEN_EXISTING equ 3
    FILE_ATTRIBUTE_NORMAL equ 80h

.code
Start proc
    ; Call CreateFileA to open the file
    lea rcx, filename              ; lpFileName (RCX)
    mov rdx, GENERIC_READ          ; dwDesiredAccess (RDX)
    xor r8, r8                     ; dwShareMode (R8)
    xor r9, r9                     ; lpSecurityAttributes (R9)
    
    sub rsp, 56                    ; Align stack
    mov dword ptr [rsp+32], OPEN_EXISTING         ; dwCreationDisposition
    mov dword ptr [rsp+40], FILE_ATTRIBUTE_NORMAL ; dwFlagsAndAttributes
    mov qword ptr [rsp+48], 0                     ; hTemplateFile
    
    call CreateFileA                ; Call CreateFileA
    add rsp, 56                     ; Clean up the stack
    test rax, rax                   ; Check if the handle is valid
    js error_exit                   ; Exit if invalid

    mov rsi, rax                    ; Save the file handle

    ; Read the file
    mov rcx, rsi                    ; File handle (RCX)
    lea rdx, buffer                 ; Buffer to store data (RDX)
    mov r8d, 1024                   ; Maximum bytes to read (R8)
    lea r9, bytesRead               ; Bytes read (R9)
    xor r10, r10                    ; No OVERLAPPED structure
    call ReadFile                   ; Call ReadFile

    ; Apply XOR encoding to the read content
    mov rcx, 0                      ; Reset counter for loop
    lea rsi, buffer                 ; Point to the original content in buffer
    lea rdi, encodedBuffer          ; Point to the encoded buffer
    lea rbx, xorKey                 ; Load XOR key

    ; Clear rcx (counter for bytes processed)
    xor rcx, rcx                    ; Clear rcx to use as loop counter

encode_loop:
    mov edx, [bytesRead]            ; Load the value of bytesRead into edx
    cmp ecx, edx                    ; Compare lower 32-bits of rcx with bytesRead
    jge display_message             ; If rcx >= bytesRead, jump to display

    mov al, [rsi + rcx]             ; Load byte from original buffer
    xor al, [rbx]                   ; XOR with the key
    mov [rdi + rcx], al             ; Store the encoded byte in encodedBuffer
    inc rcx                         ; Increment the counter
    jmp encode_loop                 ; Loop back

display_message:
    ; Display the contents in a message box
    SUB rsp, 28h           

    XOR rcx, rcx            
    LEA rdx, encodedBuffer    
    LEA r8, encodedMsg         
    XOR r9, r9              
    CALL MessageBoxA        

    XOR     rcx, rcx
    CALL ExitProcess      


    ; Close the file
    mov rcx, rsi                    ; File handle (RCX)
    call CloseHandle                ; Call CloseHandle

    ; Exit the process
    xor rcx, rcx                    ; Exit code 0 (RCX)
    call ExitProcess                ; Call ExitProcess

error_exit:
    ; Handle errors and exit
    mov rcx, -1                     ; Error exit code
    call ExitProcess                ; Call ExitProcess

extern CreateFileA : proc
extern ReadFile : proc
extern CloseHandle : proc
extern MessageBoxA : proc
extern ExitProcess : proc

Start ENDP
END
