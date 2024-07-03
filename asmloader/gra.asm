[bits 32]                 ; Ustawia tryb na 32 bity.

call print_menu          ; Wywo�uje funkcj� wypisz_menu, kt�ra wypisuje menu wyboru
db "1. Kamien", 10, "2. Papier", 10, "3. Nozyce", 10, "Wybierz przedmiot:", 0 ; Definiuje string z opcjami do wyboru i ko�czy go zerem
print_menu:
call [ebx+3*4]            ; Wywo�uje funkcj� printf do wypisania menu
add esp, 4                ; Czy�ci stos po wywo�aniu funkcji (zdejmuje 4 bajty)

mov ebp, esp              ; Ustawia wska�nik bazowy (EBP) na wska�nik stosu (ESP), co jest typowym pocz�tkiem funkcji.
sub esp, 8                ; Rezerwuje 8 bajt�w na stosie dla dw�ch zmiennych (po 4 bajty na zmienn�).
lea eax, [ebp-4]          ; �aduje adres pierwszej zmiennej (4 bajty poni�ej EBP) do rejestru EAX.
push eax                  ; Umieszcza adres pierwszej zmiennej na stosie.
call do_scan              ; Wywo�uje funkcj� do_scan, kt�ra wczytuje liczb� od u�ytkownika.
db "%i", 0                ; Definiuje ci�g formatu dla funkcji do_scan.

do_scan:                  ; Etykieta dla funkcji do_scan.
call [ebx+4*4]            ; Wywo�uje funkcj� scanf (lub odpowiednik), kt�ra wczytuje liczb� od u�ytkownika.
add esp, 8                ; Czy�ci stos po wywo�aniu funkcji (zdejmuje 8 bajt�w).

mov eax, [ebp-4]          ; �aduje wczytan� warto�� do rejestru EAX
cmp eax, 1                ; Por�wnuje warto�� z '1'
je valid_choice           ; Skok do etykiety valid_choice je�li r�wna si� '1'
cmp eax, 2                ; Por�wnuje warto�� z '2'
je valid_choice           ; Skok do etykiety valid_choice je�li r�wna si� '2'
cmp eax, 3                ; Por�wnuje warto�� z '3'
je valid_choice           ; Skok do etykiety valid_choice je�li r�wna si� '3'

call print_error         ; Wywo�uje funkcj� wypisz_error je�li warto�� jest nieprawid�owa
db "Podano zle dane. Musisz wybrac 1, 2 lub 3.", 0xA, 0
                          ; Definiuje string z komunikatem o b��dzie i ko�czy go zerem
print_error:
call [ebx+3*4]            ; Wywo�uje funkcj� printf do wypisania b��du
add esp, 4                ; Czy�ci stos po wywo�aniu funkcji (zdejmuje 4 bajty)
jmp final                ; Skok do ko�ca programu

valid_choice:             ; Etykieta dla poprawnego wyboru

RDRAND eax                ; Generuje losow� liczb� i zapisuje j� w EAX
xor edx, edx              ; Czy�ci rejestr EDX
mov ecx, 3                ; Ustawia ECX na 3
div ecx                   ; Dzieli EAX przez ECX (3), wynik w EAX, reszta w EDX
add edx, 1                ; Dodaje 1 do reszty (EDX), by mie� zakres 1-3
mov [ebp-8], edx          ; Zapisuje wynik losowania (1-3) w zmiennej na stosie

; Sprawdzenie, co zosta�o wylosowane
cmp edx, 1                ; Por�wnuje wylosowan� warto�� z 1
je rock                 ; Skok do etykiety kamien je�li r�wna si� 1
cmp edx, 2                ; Por�wnuje wylosowan� warto�� z 2
je paper                 ; Skok do etykiety papier je�li r�wna si� 2
cmp edx, 3                ; Por�wnuje wylosowan� warto�� z 3
je scissors                 ; Skok do etykiety nozyce je�li r�wna si� 3

rock:
  call msg_rock         ; Wywo�uje funkcj� msg_kamien je�li wylosowano kamie�
  jmp check_result        ; Skok do sprawdzenia wyniku

paper:
  call msg_paper         ; Wywo�uje funkcj� msg_papier je�li wylosowano papier
  jmp check_result        ; Skok do sprawdzenia wyniku

scissors:
  call msg_scissors         ; Wywo�uje funkcj� msg_nozyce je�li wylosowano no�yce
  jmp check_result        ; Skok do sprawdzenia wyniku

; Komunikaty
msg_rock:
  call print_msg_rock  ; Wywo�uje funkcj� wypisz_msg_kamien
  db "Komputer wylosowal kamien ", 0
                          ; Definiuje string z komunikatem o kamieniu
print_msg_rock:
  call [ebx+3*4]          ; Wywo�uje funkcj� printf do wypisania komunikatu
  add esp, 4              ; Czy�ci stos po wywo�aniu funkcji (zdejmuje 4 bajty)
  ret                     ; Powr�t z funkcji

msg_paper:
  call print_msg_paper  ; Wywo�uje funkcj� wypisz_msg_papier
  db "Komputer wylosowal papier ", 0
                          ; Definiuje string z komunikatem o papierze
print_msg_paper:
  call [ebx+3*4]          ; Wywo�uje funkcj� printf do wypisania komunikatu
  add esp, 4              ; Czy�ci stos po wywo�aniu funkcji (zdejmuje 4 bajty)
  ret                     ; Powr�t z funkcji

msg_scissors:
  call print_msg_scissors  ; Wywo�uje funkcj� wypisz_msg_nozyce
  db "Komputer wylosowal nozyce ", 0
                          ; Definiuje string z komunikatem o no�ycach
print_msg_scissors:
  call [ebx+3*4]          ; Wywo�uje funkcj� printf do wypisania komunikatu
  add esp, 4              ; Czy�ci stos po wywo�aniu funkcji (zdejmuje 4 bajty)
  ret                     ; Powr�t z funkcji

check_result:
  mov eax, [ebp-4]        ; �aduje warto�� wyboru u�ytkownika do rejestru EAX
  mov edx, [ebp-8]        ; �aduje warto�� wyboru komputera do rejestru EDX

  CMP eax, edx            ; Por�wnuje wyb�r u�ytkownika z wyborem komputera
  JE  draw               ; Skok do etykiety remis, je�li warto�ci s� r�wne

  CMP eax, 1              ; Por�wnuje wyb�r u�ytkownika z 1
  JE  EQ1                 ; Skok do EQ1, je�li wyb�r to 1
  CMP eax, 2              ; Por�wnuje wyb�r u�ytkownika z 2
  JE  EQ2                 ; Skok do EQ2, je�li wyb�r to 2
  CMP eax, 3              ; Por�wnuje wyb�r u�ytkownika z 3
  JE  EQ3                 ; Skok do EQ3, je�li wyb�r to 3
        
EQ1:
  CMP edx, 2              ; Por�wnuje wyb�r komputera z 2
  JE  comp_won       ; Skok do gracz2_wygral, je�li komputer wybra� 2
  CMP edx, 3              ; Por�wnuje wyb�r komputera z 3
  JE  player_won       ; Skok do gracz1_wygral, je�li komputer wybra� 3

EQ2:
  CMP edx, 1              ; Por�wnuje wyb�r komputera z 1
  JE  player_won       ; Skok do gracz1_wygral, je�li komputer wybra� 1
  CMP edx, 3              ; Por�wnuje wyb�r komputera z 3
  JE  comp_won       ; Skok do gracz2_wygral, je�li komputer wybra� 3
 
EQ3:
  CMP edx, 1              ; Por�wnuje wyb�r komputera z 1
  JE  comp_won       ; Skok do gracz2_wygral, je�li komputer wybra� 1
  CMP edx, 2              ; Por�wnuje wyb�r komputera z 2
  JE  player_won       ; Skok do gracz1_wygral, je�li komputer wybra� 2

player_won:
  call print_player_won
                          ; Wywo�uje funkcj� wypisz_gracz1_wygral
  db "i przegral", 0xa, 0 ; Definiuje string z komunikatem, �e gracz 1 przegra�
  print_player_won:
  call [ebx+3*4]          ; Wywo�uje funkcj� printf do wypisania komunikatu
  add esp, 4              ; Czy�ci stos po wywo�aniu funkcji (zdejmuje 4 bajty)
  jmp final              ; Skok do ko�ca programu
  
draw:
  call print_draw       ; Wywo�uje funkcj� wypisz_remis
  db "i mamy remis", 0xa, 0
                          ; Definiuje string z komunikatem o remisie
  print_draw:
  call [ebx+3*4]          ; Wywo�uje funkcj� printf do wypisania komunikatu
  add esp, 4              ; Czy�ci stos po wywo�aniu funkcji (zdejmuje 4 bajty)
  jmp final              ; Skok do ko�ca programu

comp_won:
  call print_comp_won
                          ; Wywo�uje funkcj� wypisz_gracz2_wygral
  db "i wygral", 0xa, 0   ; Definiuje string z komunikatem, �e gracz 2 wygra�
  print_comp_won:
  call [ebx+3*4]          ; Wywo�uje funkcj� printf do wypisania komunikatu
  add esp, 4              ; Czy�ci stos po wywo�aniu funkcji (zdejmuje 4 bajty)
  jmp final              ; Skok do ko�ca programu

final:
  push 0                  ; Umieszcza 0 na stosie, co jest warto�ci� zwrotu exit(0)
  call [ebx+0*4]          ; Wywo�uje funkcj� exit(0) ko�cz�c� program
