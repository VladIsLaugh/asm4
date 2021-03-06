.486
.model flat,stdcall
option casemap:none

include lab4.inc 	; ��������� ���� � �����������

.code
start:
	invoke GetModuleHandle, NULL	; ��������� ����� ������
	mov    hInstance,eax		; ���������
	
	invoke GetCommandLine		; ��������� ��������� �����
	mov    CommandLine,eax		;��������� 
	;(��������� ������� �� � �������, ��������������� ���� �� ������ ����� ��������� � ���������� �����)
	
	call WinMain
; ��������� ������ ��-��������� 
;WinMain � ��� �� ������ ���������� ����.
	invoke ExitProcess,eax			; �������� � �������

WinMain proc 
LOCAL wc:WNDCLASSEX	; �������� ���������-����� ���� WNDCLASSEX (���� ��� ���. ����)
LOCAL msg:MSG		; �������� ���������-����� ���� MSG (�����������)
	LOCAL hwnd:DWORD		; �������� �����  ���-�  ���� ���������� ����
	
	; ���������� ���� �����
	mov   wc.cbSize,SIZEOF WNDCLASSEX	; ������ ����� ���������
	mov   wc.style, CS_HREDRAW or CS_VREDRAW	 ; ����� ����� (���. �������)
	mov   wc.lpfnWndProc, OFFSET WndProc	; �������� �� ����. �������
	mov   wc.cbClsExtra,NULL	
	mov   wc.cbWndExtra,NULL
	push  hInstance		; �� ��� �� ������� �������� ����� ������ 
	pop   wc.hInstance	; � �������� ����
	mov   wc.hbrBackground,COLOR_BTNFACE+1	; ����� ����� (����� �������� ������, ��� ������ ���� � �����������)
	mov   wc.lpszMenuName,NULL	; ���� � ��� ����
	mov   wc.lpszClassName,OFFSET ClassName	; ������ ���� ����� �����
	
	invoke LoadIcon,NULL,IDI_ASTERISK	; ����������� ������
	mov   wc.hIcon,eax				; 
	mov   wc.hIconSm,eax
	
	invoke LoadCursor,NULL,IDC_WAIT		; ����������� ������
	mov   wc.hCursor,eax
	
	invoke RegisterClassEx, addr wc			; ���. ����� ����

	INVOKE CreateWindowEx,NULL,ADDR ClassName,ADDR AppName,\	; ���. ���������� ����
           WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
           CW_USEDEFAULT,WIDT,HEIGH,NULL,NULL,\
           hInstance,NULL
	mov   hwnd,eax					; ��������� ���� �����
	; ���. ������� ���� (������ �����, �� ������)
	
	invoke CreateWindowEx,WS_EX_CLIENTEDGE,addr szEdit,addr szEdit_text,\ ; ������ �����
			SS_BITMAP or ES_CENTER or WS_VISIBLE or WS_CHILD,\
			20,10,150,20,hwnd,0,hInstance,0
	mov hEdit,eax	
					; ��������� ����� � �����
	invoke CreateWindowEx,NULL,addr szButton,addr szButton_title,\		; ������
			BS_CENTER or WS_CHILD or WS_VISIBLE or WS_BORDER,\
			10,60,70,20,hwnd,0,hInstance,0
	mov hButton,eax		; ��������� ����� ���� � ����� hButton
	
	invoke CreateWindowEx,NULL,addr szWin,addr szWin_text,\
			ES_CENTER or WS_VISIBLE or WS_CHILD,\
			100,60,70,20,hwnd,0,hInstance,0
	mov hWin,eax
	
	
	invoke ShowWindow, hwnd,SW_SHOWNORMAL ; �������� ����
	invoke UpdateWindow, hwnd	; �������� �� ������ �������
	
	.WHILE TRUE	; ���� ��������� �����������
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

; ����. �������  ����������
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	
	mov eax,uMsg	; �������� �����������  � ������ ���, ��� ��������
	.IF eax == WM_DESTROY	; ���� ���� ���������
		invoke PostQuitMessage,NULL	; ��������� ����������� ������ ��� �������� �������
		
	.ELSEIF eax == WM_CREATE		; ���� ���� ����������� 
	
	.elseif eax == WM_COMMAND		; ���� ��������� ����� �������
		mov eax,hButton		
		.if lParam == eax			; ���������, ���� lParam  = ������ ������ (������ ���������)
			invoke GetWindowText,hEdit,addr buf,MAX_PATH	; ������� ����� � ����-������ � �������� � ����� buf
			invoke MessageBox,0,addr buf,addr szCaptin,MB_OK	; �������� 
		.endif
		mov eax,hWin
		.if lParam == eax
		invoke SetTimer,0,0,50,addr TimerOn 	
			;invoke GetWindowText,hEdit,addr buf,MAX_PATH	; ������� ����� � ����-������ � �������� � ����� buf


		.endif
	.ELSE
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam		; ���� ������ �������� ����� 䳿 �������� �������� ������� ����������� (����� �� ���������, ��� ��� �� � ������)
		ret
	.ENDIF
	
	xor eax,eax
	ret
WndProc endp
end start
