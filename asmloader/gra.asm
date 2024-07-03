[bits 32]                 ; Ustawia tryb na 32 bity.

call print_menu          ; Wywo³uje funkcjê wypisz_menu, która wypisuje menu wyboru
db "1. Kamien", 10, "2. Papier", 10, "3. Nozyce", 10, "Wybierz przedmiot:", 0 ; Definiuje string z opcjami do wyboru i koñczy go zerem
print_menu:
call [ebx+3*4]            ; Wywo³uje funkcjê printf do wypisania menu
add esp, 4                ; Czyœci stos po wywo³aniu funkcji (zdejmuje 4 bajty)

mov ebp, esp              ; Ustawia wskaŸnik bazowy (EBP) na wskaŸnik stosu (ESP), co jest typowym pocz¹tkiem funkcji.
sub esp, 8                ; Rezerwuje 8 bajtów na stosie dla dwóch zmiennych (po 4 bajty na zmienn¹).
lea eax, [ebp-4]          ; £aduje adres pierwszej zmiennej (4 bajty poni¿ej EBP) do rejestru EAX.
push eax                  ; Umieszcza adres pierwszej zmiennej na stosie.
call do_scan              ; Wywo³uje funkcjê do_scan, która wczytuje liczbê od u¿ytkownika.
db "%i", 0                ; Definiuje ci¹g formatu dla funkcji do_scan.

do_scan:                  ; Etykieta dla funkcji do_scan.
call [ebx+4*4]            ; Wywo³uje funkcjê scanf (lub odpowiednik), która wczytuje liczbê od u¿ytkownika.
add esp, 8                ; Czyœci stos po wywo³aniu funkcji (zdejmuje 8 bajtów).

mov eax, [ebp-4]          ; £aduje wczytan¹ wartoœæ do rejestru EAX
cmp eax, 1                ; Porównuje wartoœæ z '1'
je valid_choice           ; Skok do etykiety valid_choice jeœli równa siê '1'
cmp eax, 2                ; Porównuje wartoœæ z '2'
je valid_choice           ; Skok do etykiety valid_choice jeœli równa siê '2'
cmp eax, 3                ; Porównuje wartoœæ z '3'
je valid_choice           ; Skok do etykiety valid_choice jeœli równa siê '3'

call print_error         ; Wywo³uje funkcjê wypisz_error jeœli wartoœæ jest nieprawid³owa
db "Podano zle dane. Musisz wybrac 1, 2 lub 3.", 0xA, 0
                          ; Definiuje string z komunikatem o b³êdzie i koñczy go zerem
print_error:
call [ebx+3*4]            ; Wywo³uje funkcjê printf do wypisania b³êdu
add esp, 4                ; Czyœci stos po wywo³aniu funkcji (zdejmuje 4 bajty)
jmp final                ; Skok do koñca programu

valid_choice:             ; Etykieta dla poprawnego wyboru

RDRAND eax                ; Generuje losow¹ liczbê i zapisuje j¹ w EAX
xor edx, edx              ; Czyœci rejestr EDX
mov ecx, 3                ; Ustawia ECX na 3
div ecx                   ; Dzieli EAX przez ECX (3), wynik w EAX, reszta w EDX
add edx, 1                ; Dodaje 1 do reszty (EDX), by mieæ zakres 1-3
mov [ebp-8], edx          ; Zapisuje wynik losowania (1-3) w zmiennej na stosie

; Sprawdzenie, co zosta³o wylosowane
cmp edx, 1                ; Porównuje wylosowan¹ wartoœæ z 1
je rock                 ; Skok do etykiety kamien jeœli równa siê 1
cmp edx, 2                ; Porównuje wylosowan¹ wartoœæ z 2
je paper                 ; Skok do etykiety papier jeœli równa siê 2
cmp edx, 3                ; Porównuje wylosowan¹ wartoœæ z 3
je scissors                 ; Skok do etykiety nozyce jeœli równa siê 3

rock:
  call msg_rock         ; Wywo³uje funkcjê msg_kamien jeœli wylosowano kamieñ
  jmp check_result        ; Skok do sprawdzenia wyniku

paper:
  call msg_paper         ; Wywo³uje funkcjê msg_papier jeœli wylosowano papier
  jmp check_result        ; Skok do sprawdzenia wyniku

scissors:
  call msg_scissors         ; Wywo³uje funkcjê msg_nozyce jeœli wylosowano no¿yce
  jmp check_result        ; Skok do sprawdzenia wyniku

; Komunikaty
msg_rock:
  call print_msg_rock  ; Wywo³uje funkcjê wypisz_msg_kamien
  db "Komputer wylosowal kamien ", 0
                          ; Definiuje string z komunikatem o kamieniu
print_msg_rock:
  call [ebx+3*4]          ; Wywo³uje funkcjê printf do wypisania komunikatu
  add esp, 4              ; Czyœci stos po wywo³aniu funkcji (zdejmuje 4 bajty)
  ret                     ; Powrót z funkcji

msg_paper:
  call print_msg_paper  ; Wywo³uje funkcjê wypisz_msg_papier
  db "Komputer wylosowal papier ", 0
                          ; Definiuje string z komunikatem o papierze
print_msg_paper:
  call [ebx+3*4]          ; Wywo³uje funkcjê printf do wypisania komunikatu
  add esp, 4              ; Czyœci stos po wywo³aniu funkcji (zdejmuje 4 bajty)
  ret                     ; Powrót z funkcji

msg_scissors:
  call print_msg_scissors  ; Wywo³uje funkcjê wypisz_msg_nozyce
  db "Komputer wylosowal nozyce ", 0
                          ; Definiuje string z komunikatem o no¿ycach
print_msg_scissors:
  call [ebx+3*4]          ; Wywo³uje funkcjê printf do wypisania komunikatu
  add esp, 4              ; Czyœci stos po wywo³aniu funkcji (zdejmuje 4 bajty)
  ret                     ; Powrót z funkcji

check_result:
  mov eax, [ebp-4]        ; £aduje wartoœæ wyboru u¿ytkownika do rejestru EAX
  mov edx, [ebp-8]        ; £aduje wartoœæ wyboru komputera do rejestru EDX

  CMP eax, edx            ; Porównuje wybór u¿ytkownika z wyborem komputera
  JE  draw               ; Skok do etykiety remis, jeœli wartoœci s¹ równe

  CMP eax, 1              ; Porównuje wybór u¿ytkownika z 1
  JE  EQ1                 ; Skok do EQ1, jeœli wybór to 1
  CMP eax, 2              ; Porównuje wybór u¿ytkownika z 2
  JE  EQ2                 ; Skok do EQ2, jeœli wybór to 2
  CMP eax, 3              ; Porównuje wybór u¿ytkownika z 3
  JE  EQ3                 ; Skok do EQ3, jeœli wybór to 3
        
EQ1:
  CMP edx, 2              ; Porównuje wybór komputera z 2
  JE  comp_won       ; Skok do gracz2_wygral, jeœli komputer wybra³ 2
  CMP edx, 3              ; Porównuje wybór komputera z 3
  JE  player_won       ; Skok do gracz1_wygral, jeœli komputer wybra³ 3

EQ2:
  CMP edx, 1              ; Porównuje wybór komputera z 1
  JE  player_won       ; Skok do gracz1_wygral, jeœli komputer wybra³ 1
  CMP edx, 3              ; Porównuje wybór komputera z 3
  JE  comp_won       ; Skok do gracz2_wygral, jeœli komputer wybra³ 3
 
EQ3:
  CMP edx, 1              ; Porównuje wybór komputera z 1
  JE  comp_won       ; Skok do gracz2_wygral, jeœli komputer wybra³ 1
  CMP edx, 2              ; Porównuje wybór komputera z 2
  JE  player_won       ; Skok do gracz1_wygral, jeœli komputer wybra³ 2

player_won:
  call print_player_won
                          ; Wywo³uje funkcjê wypisz_gracz1_wygral
  db "i przegral", 0xa, 0 ; Definiuje string z komunikatem, ¿e gracz 1 przegra³
  print_player_won:
  call [ebx+3*4]          ; Wywo³uje funkcjê printf do wypisania komunikatu
  add esp, 4              ; Czyœci stos po wywo³aniu funkcji (zdejmuje 4 bajty)
  jmp final              ; Skok do koñca programu
  
draw:
  call print_draw       ; Wywo³uje funkcjê wypisz_remis
  db "i mamy remis", 0xa, 0
                          ; Definiuje string z komunikatem o remisie
  print_draw:
  call [ebx+3*4]          ; Wywo³uje funkcjê printf do wypisania komunikatu
  add esp, 4              ; Czyœci stos po wywo³aniu funkcji (zdejmuje 4 bajty)
  jmp final              ; Skok do koñca programu

comp_won:
  call print_comp_won
                          ; Wywo³uje funkcjê wypisz_gracz2_wygral
  db "i wygral", 0xa, 0   ; Definiuje string z komunikatem, ¿e gracz 2 wygra³
  print_comp_won:
  call [ebx+3*4]          ; Wywo³uje funkcjê printf do wypisania komunikatu
  add esp, 4              ; Czyœci stos po wywo³aniu funkcji (zdejmuje 4 bajty)
  jmp final              ; Skok do koñca programu

final:
  push 0                  ; Umieszcza 0 na stosie, co jest wartoœci¹ zwrotu exit(0)
  call [ebx+0*4]          ; Wywo³uje funkcjê exit(0) koñcz¹c¹ program
