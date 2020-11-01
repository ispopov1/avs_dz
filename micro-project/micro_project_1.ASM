format PE console
entry start
;------------------------------------------
include "win32a.inc"
;-------------------------------------------
section '.rdata' data readable writeable
        title    db    "Find padovan sequnce size",0
        answer    db    "There are %d numbers in padovan sequence",10,0
        _pause    db    "pause",0
        prev_prev_value   dd    1
        prev_value    dd    1
        value    dd    1
        count    dd    3    ; первые 3 элемента(единицы) заданы сразу
;-----------------------------------------
section '.text' code executable
start:
    invoke SetConsoleTitle, title
    call Padovan
    invoke ExitProcess, 0
;------------------------------------------
    proc Padovan
    for_loop:
    xor eax, eax
    xor ebx, ebx
    mov eax, [prev_value]
    add eax, [prev_prev_value]
    ; Выход при переполнении(беззнаковом)
    jc for_end
    mov ebx, [value]
    mov [value], eax
    mov eax, [prev_value]
    mov [prev_value], ebx
    mov [prev_prev_value], eax
    inc [count]
    jmp for_loop
    for_end:
    invoke printf, answer, [count]
    invoke system, _pause
    ret
    endp
;-----------------------------
section '.idata' data readable import
    library kernel32, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

    import kernel32,\
    ExitProcess, 'ExitProcess',\
    SetConsoleTitle, 'SetConsoleTitleA'

    import msvcrt,\
    printf, 'printf',\
    system, 'system',\
    scanf, 'scanf'