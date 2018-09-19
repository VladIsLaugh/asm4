.486
.model flat,stdcall
option casemap:none

include lab4.inc 	; підключаємо файл з заголовками

.code
start:
	invoke GetModuleHandle, NULL	; визначаємо хендл модуля
	mov    hInstance,eax		; збережемо
	
	invoke GetCommandLine		; визначаємо командний рядок
	mov    CommandLine,eax		;збережемо 
	;(попередня команда не є потрібна, використовується якщо ми хочемо брати параметри з командного рядка)
	
	call WinMain
; викликаємо власну під-процедуру 
;WinMain в ній ми будемо створювати вікна.
	invoke ExitProcess,eax			; виходимо з процесу

WinMain proc 
LOCAL wc:WNDCLASSEX	; локальна структура-змінна типу WNDCLASSEX (інфа про нов. клас)
LOCAL msg:MSG		; локальна структура-змінна типу MSG (повідомлення)
	LOCAL hwnd:DWORD		; локальна змінна  хар-є  хенд баківського вікна
	
	; заповнюємо поля класу…
	mov   wc.cbSize,SIZEOF WNDCLASSEX	; задаємо розмір структури
	mov   wc.style, CS_HREDRAW or CS_VREDRAW	 ; стиль класу (див. довідник)
	mov   wc.lpfnWndProc, OFFSET WndProc	; вказівник на проц. обробки
	mov   wc.cbClsExtra,NULL	
	mov   wc.cbWndExtra,NULL
	push  hInstance		; ну тут ми копіюємо значення хенду модуля 
	pop   wc.hInstance	; у відповідне поле
	mov   wc.hbrBackground,COLOR_BTNFACE+1	; хендл щитки (можна створити самому, або задати одну з стандартних)
	mov   wc.lpszMenuName,NULL	; меню у нас немає
	mov   wc.lpszClassName,OFFSET ClassName	; задаємо нову назву класу
	
	invoke LoadIcon,NULL,IDI_ASTERISK	; Завантажуємо іконку
	mov   wc.hIcon,eax				; 
	mov   wc.hIconSm,eax
	
	invoke LoadCursor,NULL,IDC_WAIT		; Завантажуємо курсор
	mov   wc.hCursor,eax
	
	invoke RegisterClassEx, addr wc			; ств. новий клас

	INVOKE CreateWindowEx,NULL,ADDR ClassName,ADDR AppName,\	; ств. батьківське вікно
           WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
           CW_USEDEFAULT,WIDT,HEIGH,NULL,NULL,\
           hInstance,NULL
	mov   hwnd,eax					; збережемо його хендл
	; ств. дочірні вікна (стрічка вводу, та кнопку)
	
	invoke CreateWindowEx,WS_EX_CLIENTEDGE,addr szEdit,addr szEdit_text,\ ; стрічка вводу
			SS_BITMAP or ES_CENTER or WS_VISIBLE or WS_CHILD,\
			20,10,150,20,hwnd,0,hInstance,0
	mov hEdit,eax	
					; збережемо хендл в змінну
	invoke CreateWindowEx,NULL,addr szButton,addr szButton_title,\		; кнопка
			BS_CENTER or WS_CHILD or WS_VISIBLE or WS_BORDER,\
			10,60,70,20,hwnd,0,hInstance,0
	mov hButton,eax		; збережемо хендл вікна у змінну hButton
	
	invoke CreateWindowEx,NULL,addr szWin,addr szWin_text,\
			ES_CENTER or WS_VISIBLE or WS_CHILD,\
			100,60,70,20,hwnd,0,hInstance,0
	mov hWin,eax
	
	
	invoke ShowWindow, hwnd,SW_SHOWNORMAL ; показуємо вікно
	invoke UpdateWindow, hwnd	; обновимо на всякий випадок
	
	.WHILE TRUE	; цикл перехвану повідомлення
		invoke GetMessage, ADDR msg,NULL,0,0
		.BREAK .IF (!eax)
		invoke TranslateMessage, ADDR msg
		invoke DispatchMessage, ADDR msg
	.ENDW
	
	mov     eax,msg.wParam
	ret
WinMain endp

TimerOn proc
	invoke MoveWindow,hWin,x,y,70,20,TRUE
	mov ecx, i
	add y,ecx
	inc i
	;mov ebx, 20
	.if i==20
		mov i, -19
		dec ebx
	.endif
	ret

TimerOn endp

; проц. обробки  повідомлень
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	
	mov eax,uMsg	; запишемо повідомлення  у регістр еах, для простоти
	.IF eax == WM_DESTROY	; якщо вікно знищується
		invoke PostQuitMessage,NULL	; відправити повідомлення системі про закриття прогами
		
	.ELSEIF eax == WM_CREATE		; якщо вікно створюється 
	
	.elseif eax == WM_COMMAND		; якщо виконання якась команда
		mov eax,hButton		
		.if lParam == eax			; перевіримо, якщо lParam  = хендлу кнопки (кнопка натиснута)
			invoke GetWindowText,hEdit,addr buf,MAX_PATH	; візьмемо текст з вікна-стрічки і запишемо у буфер buf
			invoke MessageBox,0,addr buf,addr szCaptin,MB_OK	; виведемо 
		.endif
		mov eax,hWin
		.if lParam == eax
		invoke SetTimer,0,0,50,addr TimerOn 	
			;invoke GetWindowText,hEdit,addr buf,MAX_PATH	; візьмемо текст з вікна-стрічки і запишемо у буфер buf


		.endif
	.ELSE
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam		; якщо небуло виконано жодної дії виконати системну обробку повідомлення (тобто не реагувати, або так як в системі)
		ret
	.ENDIF
	
	xor eax,eax
	ret
WndProc endp
end start
