format PE console

entry Start

include 'win32a.inc'

section '.data' data readable writable

            strA db 'Enter A: ', 0
            strB db 'Enter B: ', 0
            strOp db 'Enter operation: ', 0

            resStr db 'Result: %d', 0 ; вывод результата %d = Число
            resMod db '/%d', 0 ; атображение смешанной дроби

            spaceStr db ' %d', 0 ; строка с пробелом
            emptyStr db '%d', 0  ; оставляется число

            infinity db 'infinity', 0 ; бесконечность при делении на 0
            point db ',', 0  ;запитая при делении целой части от вещественной

            A dd ? ; обьявление переменной с ограничением dd
            B dd ?
            C dd ?
            NULL = 0 ; вместо null будет 0

section '.code' code readable executable ; создание секции где и будет работать код

        Start:
               push strA  ; данные по метки strA
               call [printf]

               push A ; делаем ввод с клавиатуры
               push spaceStr
               call [scanf]

               push strB  ; данные по метки strA
               call [printf]

               push B ; делаем ввод с клавиатуры
               push spaceStr
               call [scanf]

               push strOp   ;считываем операцию
               call [printf]

               call [getch]

               cmp eax, 43 ; (43 = +) если тут 0 то преход срабатывает в jne notAdd тоесть к финишу, если 1 то нет
               jne notAdd
                   mov ecx, [A]
                   add ecx, [B]

                   push ecx ; выводим результат на экран
                   push resStr
                   call [printf]

                   jmp finish ; выход с программы
                 notAdd:

                 cmp eax, 45 ; (45 = -)
                 jne notSub
                     mov ecx, [A]
                     sub ecx, [B]

                     push ecx
                     push resStr
                     call [printf]

                     jmp finish
                 notSub:

                 cmp eax, 42
                 jne notMul
                    mov ecx, [A]
                    imul ecx, [B]

                    push ecx
                    push resStr
                    call[printf]

                    jmp finish
                 notMul:

                cmp eax, 47
                jne notDiv
                   mov eax, [A]
                   mov ecx, [B]
                   mov edx, 0

                   cmp[B], 0
                   jne notNullDiv1
                       push infinity
                       call[printf]

                       jmp finish
                   notNullDiv1:

                   div ecx
                   mov [C], edx

                   push eax
                   push resStr
                   call [printf]

                   push point  ; Точки после запятой
                   call [printf]

                   mov ebx, 0
                   lp:

                         mov eax, [C]
                         mov ecx, [B]
                         imul eax, 10

                         mov edx, 0
                         div ecx
                         mov [C], edx

                         push eax
                         push emptyStr
                         call [printf]


                   add ebx, 1
                   cmp ebx, 3
                   jne lp
                   jmp finish
                notDiv:



                 finish:

                 call [getch]   ; чтобы окно программы сраху не хакрылось

                 push NULL
                 call [ExitProcess]




section '.idata' import data readable ; функции импортируеммые из других библиоитек (название idata)

            library kernel, 'kernel32.dll',\ ;импортируеммые библиотеки
                    msvcrt, 'msvcrt.dll'

            import kernel,\
                   ExitProcess, 'ExitProcess' ; импортируем функию из kernel

            import msvcrt,\
                   printf, 'printf',\
                   scanf, 'scanf',\
                   getch, '_getch'