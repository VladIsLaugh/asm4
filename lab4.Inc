 include windows.inc
   include user32.inc
   include kernel32.inc
   
   includelib user32.lib
   includelib kernel32.lib


WinMain proto 

.data
	WIDT			dd 500	
	HEIGH			dd 310
   ClassName 		db "MainWinClass",0	;��'� ����� ������ ����
   AppName  		db "Main Window",0	; ��������� ������������ ����
   szEdit			db 'Edit',0		;����������� ���� ���� (������ �����)
   szEdit_text		db 'My Text',0		; ���� ����
   
   szButton			db 'Button',0		;����������� ���� ���� (������)
   szButton_title	db 'Clik me',0		; ���� ����
   
   szWin		db 'Button',0
   szWin_text	db 'Push me',0
   
   buf			db MAX_PATH dup(0)	; ����� ���� �� ������ ������ ���� ����-������
   szCaptin		db 'Title.....',0		; ��������� MessageBox'�
   
   	x			dd 	100
	y			dd	60
	i			dd 	0
	j			dd  -20
.data?
   hInstance 	dd ?				;����� ��� ������ ������
   CommandLine 	dd ?				;����� ��� ����� ���������� �����
   hEdit		dd ?				;����� ��� ������ �����-������
   hButton		dd ?				; ����� ��� ������ ������
   hWin			dd ?
