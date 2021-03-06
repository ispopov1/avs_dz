format PE console

entry Start

include 'win32a.inc'

section '.data' data readable writable

            strA db 'Enter A: ', 0
            strB db 'Enter B: ', 0
            strOp db 'Enter operation: ', 0

            resStr db 'Result: %d', 0 ; ����� ���������� %d = �����
            resMod db '/%d', 0 ; ����������� ��������� �����

            spaceStr db ' %d', 0 ; ������ � ��������
            emptyStr db '%d', 0  ; ����������� �����

            infinity db 'infinity', 0 ; ������������� ��� ������� �� 0
            point db ',', 0  ;������� ��� ������� ����� ����� �� ������������

            A dd ? ; ���������� ���������� � ������������ dd
            B dd ?
            C dd ?
            NULL = 0 ; ������ null ����� 0

section '.code' code readable executable ; �������� ������ ��� � ����� �������� ���

        Start:
               push strA  ; ������ �� ����� strA
               call [printf]

               push A ; ������ ���� � ����������
               push spaceStr
               call [scanf]

               push strB  ; ������ �� ����� strA
               call [printf]

               push B ; ������ ���� � ����������
               push spaceStr
               call [scanf]

               push strOp   ;��������� ��������
               call [printf]

               call [getch]

               cmp eax, 43 ; (43 = +) ���� ��� 0 �� ������ ����������� � jne notAdd ������ � ������, ���� 1 �� ���
               jne notAdd
                   mov ecx, [A]
                   add ecx, [B]

                   push ecx ; ������� ��������� �� �����
                   push resStr
                   call [printf]

                   jmp finish ; ����� � ���������
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

                   push point  ; ����� ����� �������
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

                 call [getch]   ; ����� ���� ��������� ����� �� ���������

                 push NULL
                 call [ExitProcess]




section '.idata' import data readable ; ������� �������������� �� ������ ���������� (�������� idata)

            library kernel, 'kernel32.dll',\ ;�������������� ����������
                    msvcrt, 'msvcrt.dll'

            import kernel,\
                   ExitProcess, 'ExitProcess' ; ����������� ������ �� kernel

            import msvcrt,\
                   printf, 'printf',\
                   scanf, 'scanf',\
                   getch, '_getch'