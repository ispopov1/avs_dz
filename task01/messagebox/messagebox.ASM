format PE GUI 4.0
entry BeginCode

include 'win32a.inc'

section '.code' executable readable writeable

BeginCode:
        push 0
        push txtTitle
        push txtMessage
        push 0
        call [MessageBox]

        ;or alternate way of calling api's or procs
        invoke MessageBox,0,txtMessage,txtTitle,0
        invoke ExitProcess,0
        ret

section '.data' data readable writeable

txtTitle        db      'Titlebar',0
txtMessage      db      'Hello World',0

section '.idata' import data readable writeable

  library kernel,'KERNEL32.DLL',\
          user,'USER32.DLL'

  import kernel,\
         ExitProcess,'ExitProcess'

  import user,\
         MessageBox,'MessageBoxA'