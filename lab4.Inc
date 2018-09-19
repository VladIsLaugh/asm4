 include windows.inc
   include user32.inc
   include kernel32.inc
   
   includelib user32.lib
   includelib kernel32.lib


WinMain proto 

.data
	WIDT			dd 500	
	HEIGH			dd 310
   ClassName 		db "MainWinClass",0	;ім'я класу нового вікна
   AppName  		db "Main Window",0	; заголовок батьківського вікна
   szEdit			db 'Edit',0		;стандартний клас вікна (стрічка вводу)
   szEdit_text		db 'My Text',0		; вміст вікна
   
   szButton			db 'Button',0		;стандартний клас вікна (кнопка)
   szButton_title	db 'Clik me',0		; вміст вікна
   
   szWin		db 'Button',0
   szWin_text	db 'Push me',0
   
   buf			db MAX_PATH dup(0)	; буфер куди ми будемо писати вміст вікна-стрічки
   szCaptin		db 'Title.....',0		; заголовок MessageBox'а
   
   	x			dd 	100
	y			dd	60
	i			dd 	0
	j			dd  -20
.data?
   hInstance 	dd ?				;змінна для хендлу модуля
   CommandLine 	dd ?				;змінна для хендл командного рядка
   hEdit		dd ?				;змінна для хендлу рядка-стрічки
   hButton		dd ?				; змінна для хендлу кнопки
   hWin			dd ?
