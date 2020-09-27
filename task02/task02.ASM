; Попов Игорь БПИ 194
; Вариант 19
; Условие: Массив В, полученный из массива А заменой нулевых
;          элементов, предшествующих первому отрицательному, единицей

format PE console
entry start

include 'win32a.inc'

;--------------------------------------------------------------------------
section '.data' data readable writable

        strVecSize   db 'Enter array size:  ', 0
        strIncorSize db 'Incorrect size of vector = %d', 10, 0
        strVecElemI  db 'A[%d] = ', 0
        strScanInt   db '%d', 0
        strA  db 'Array A:', 10, 0
        strB  db 'Array B', 10, 0
        strVecElemOutA  db 'A[%d] = %d', 10, 0
        strVecElemOutB  db 'B[%d] = %d', 10, 0
        p db 'pause',0

        vec_size     dd 0
        sum          dd 0
        i            dd ?
        tmp          dd ?
        tmpStack     dd ?
        A          rd 100
        B          rd 100

;--------------------------------------------------------------------------
section '.code' code readable executable
start:
; 1) Считывание массива А
        call VectorInput
; 2) Создание массива В
        call GenerateArray
; 3) Вывод Массивов
        call VectorOut
finish:
        call [getch]

        push 0
        call [ExitProcess]

;--------------------------------------------------------------------------
VectorInput:
        push strVecSize
        call [printf]
        add esp, 4

        push vec_size
        push strScanInt
        call [scanf]
        add esp, 8

        mov eax, [vec_size]
        cmp eax, 0
        jg  getVector
; fail size
        push vec_size
        push strIncorSize
        call [printf]
        push 0
        call [ExitProcess]
getVector:
        xor ecx, ecx
        mov ebx, A
getVecLoop:
        mov [tmp], ebx
        cmp ecx, [vec_size]
        jge endInputVector

        ; input element
        mov [i], ecx
        push ecx
        push strVecElemI
        call [printf]
        add esp, 8

        push ebx
        push strScanInt
        call [scanf]
        add esp, 8

        mov ecx, [i]
        inc ecx
        mov ebx, [tmp]
        add ebx, 4
        jmp getVecLoop
endInputVector:
        ret
;--------------------------------------------------------------------------
GenerateArray:
        mov ecx, [vec_size] ;счетчик по массиву
        mov esi, A          ;Источник(массив А)
        mov edi, B          ;Получатель(массив В)
cycle:
        mov eax, [esi]
        cmp eax,0
        je equal            ;Равен нулю
        cmp eax,0
        jle copy            ;Меньше нуля(первое отрицательне число)
        mov [edi], eax      ;Копирование элемента если он не 0
        jmp endif
        ;замена 0 на 1
        equal:
                mov eax, 1
                mov [edi], eax
        endif:
                add  edi,4
                add  esi,4
        loop cycle
jmp endi
;Обычное копирование массива А после встречи первого отрицательного числа
copy:
        mov eax, [esi]
        mov [edi], eax
        add  edi,4
        add  esi,4
        loop copy
endi:

endSumVector:
        ret
;--------------------------------------------------------------------------
VectorOut:

                push strB
                call [printf]
                mov [tmpStack], esp
                xor ecx, ecx            ;
                mov ebx, B
        putVecLoop:
                mov [tmp], ebx
                cmp ecx, [vec_size]
                je endOutputVectorB
                mov [i], ecx
                push dword [ebx]
                push ecx
                push strVecElemOutB
                call [printf]
                mov ecx, [i]
                inc ecx
                mov ebx, [tmp]
                add ebx, 4
                jmp putVecLoop
        endOutputVectorB:
                mov esp, [tmpStack]

                push strA
                call [printf]
                mov [tmpStack], esp
                xor ecx, ecx            ;
                mov ebx, A
        putVecLoop2:
                mov [tmp], ebx
                cmp ecx, [vec_size]
                je endOutputVector2
                mov [i], ecx
                push dword [ebx]
                push ecx
                push strVecElemOutA
                call [printf]
                mov ecx, [i]
                inc ecx
                mov ebx, [tmp]
                add ebx, 4
                jmp putVecLoop2
        endOutputVector2:
                cinvoke system,p
;-------------------------------third act - including HeapApi--------------------------
                                                 
section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch',\
           system,'system'