    device zxspectrum48 ; It has nothing to do with ZX Spectrum 48K, it is needed for the sjasmplus compiler.
    org 100h
__begin:
__entry:
main:
        ld   de, __bss
        xor  a
__init_loop:
        ld   (de), a
        inc  de
        ld   hl, 10000h - __end
        add  hl, de
        jp   nc, __init_loop

; 332  main(void) {
; 333     puts(
; 334         "\x1B71iGRA \"pASXQNS kOSYNKA\"\n"
	ld hl, __c_0
	call puts
l_0:
; 335         "DLQ KOMPX@TERA oKEAN 240\n"
; 336         "\x1B70(c) 12-12-2024 Alemorf\n"
; 337         "aleksey.f.morozov@gmail.com\n"
; 338         "\n"
; 339         "\x1B71nAVMITE L@BU@ KLAWI[U\x1B70\n");
; 340 
; 341     while (!cpmBiosConSt())
	call cpmbiosconst
	or a
	jp nz, l_1
; 342         rand();
	call rand
	jp l_0
l_1:
; 343 
; 344     InitScreen();
	call initscreen
; 345     Redraw();
	call redraw
; 346     Game();
	call game
; 347     puts("\x1B60");
	ld hl, __c_1
	jp puts
puts:
; 21  puts(const char *text)
	ld (__a_1_puts), hl
l_2:
; 22 {
; 23     while(*text != 0) {
	ld hl, (__a_1_puts)
	ld a, (hl)
	or a
	ret z
; 24         putchar((uint8_t)*text++);
	inc hl
	ld (__a_1_puts), hl
	dec hl
	ld a, (hl)
	ld l, a
	ld h, 0
	call putchar
	jp l_2
cpmbiosconst:
; 20  __fastcall cpmBiosConSt(void) {

        ld hl, (1)
        ld l, 6
        jp hl
    
	ret
rand:
; 22  rand(void) {
; 23     __rand_seed ^= (__rand_seed << 13);
	ld hl, (__rand_seed)
	ld h, l
	ld l, 0
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ex hl, de
	ld hl, (__rand_seed)
	call __o_xor_16
	ld (__rand_seed), hl
; 24     __rand_seed ^= (__rand_seed >> 9);
	ld de, 9
	call __o_shr_u16
	ex hl, de
	ld hl, (__rand_seed)
	call __o_xor_16
	ld (__rand_seed), hl
; 25     __rand_seed ^= (__rand_seed << 7);
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ex hl, de
	ld hl, (__rand_seed)
	call __o_xor_16
	ld (__rand_seed), hl
; 26     return __rand_seed;
	ret
initscreen:
; 69  InitScreen(void) {
; 70     out(PORT_SCROLL_X, PORT_SCROLL_X__DEFAULT);
	ld a, 194
	ld (__a_1_out), a
	ld a, 7
	call out
; 71     out(PORT_SCROLL_Y, PORT_SCROLL_Y__DEFAULT);
	ld a, 192
	ld (__a_1_out), a
	xor a
	call out
; 72     out(PORT_COLOR, PORT_COLOR__COLOR_MODE | 1);
	ld a, 225
	ld (__a_1_out), a
	ld a, 65
	jp out
redraw:
; 75  Redraw(void) {
; 76     DrawImage8(0, 0, IMAGE_TITLE_HEIGHT, image_title);
	xor a
	ld (__a_1_drawimage8), a
	ld (__a_2_drawimage8), a
	ld a, 8
	ld (__a_3_drawimage8), a
	ld hl, image_title
	call drawimage8
; 77 
; 78     unsigned x, y;
; 79     for (y = IMAGE_TITLE_HEIGHT; y < SCREEN_HEIGHT; y += IMAGE_BACKGROUND_HEIGHT) {
	ld hl, 8
	ld (__s_redraw + 2), hl
l_4:
	ld hl, (__s_redraw + 2)
	ld de, 256
	call __o_sub_16
	ret nc
; 80         uint8_t h = (y < SCREEN_HEIGHT - IMAGE_BACKGROUND_HEIGHT) ? IMAGE_BACKGROUND_HEIGHT : (SCREEN_HEIGHT - y);
	ld hl, (__s_redraw + 2)
	ld de, 208
	call __o_sub_16
	jp nc, l_7
	ld hl, 48
	jp l_8
l_7:
	ld hl, (__s_redraw + 2)
	ld de, 256
	ex hl, de
	call __o_sub_16
l_8:
	ld a, l
	ld (__s_redraw + 4), a
; 81         for (x = 0; x < SCREEN_WIDTH_PIXELS; x += IMAGE_BACKGROUND_WIDTH)
	ld hl, 0
	ld (__s_redraw + 0), hl
l_9:
	ld hl, (__s_redraw + 0)
	ld de, 256
	call __o_sub_16
	jp nc, l_11
; 82             DrawImage8(x, y, h, image_background);
	ld a, (__s_redraw + 0)
	ld (__a_1_drawimage8), a
	ld a, (__s_redraw + 2)
	ld (__a_2_drawimage8), a
	ld a, (__s_redraw + 4)
	ld (__a_3_drawimage8), a
	ld hl, image_background
	call drawimage8
l_10:
	ld hl, (__s_redraw + 0)
	ld de, 32
	add hl, de
	ld (__s_redraw + 0), hl
	jp l_9
l_11:
l_5:
	ld hl, (__s_redraw + 2)
	ld de, 48
	add hl, de
	ld (__s_redraw + 2), hl
	jp l_4
game:
; 260  Game(void) {
; 261     NewGame();
	call newgame
l_12:
; 262     for (;;) {
; 263         switch (GetKey()) {
	call getkey
	sub 32
	jp z, l_17
	sub 18
	jp z, l_16
	sub 15
	jp z, l_23
	sub 3
	jp z, l_22
	sub 10
	jp z, l_19
	sub 3
	ret z
	sub 2
	jp z, l_20
	sub 4
	jp z, l_21
	jp l_15
l_23:
; 264             case 'A':
; 265                 if (cursor == 0 || cursor == 7)
	ld a, (cursor)
	or a
	jp z, l_26
	cp 7
	jp nz, l_24
l_26:
; 266                     MoveCursor(6);
	ld a, 6
	call movecursor
	jp l_15
l_24:
; 267                 else
; 268                     MoveCursor(-1);
	ld a, -1
	call movecursor
	jp l_15
l_22:
; 269                 break;
; 270             case 'D':
; 271                 if (cursor == 6 || cursor == 13)
	ld a, (cursor)
	cp 6
	jp z, l_29
	cp 13
	jp nz, l_27
l_29:
; 272                     MoveCursor(-6);
	ld a, -6
	call movecursor
	jp l_15
l_27:
; 273                 else
; 274                     MoveCursor(1);
	ld a, 1
	call movecursor
	jp l_15
l_21:
l_20:
; 275                 break;
; 276             case 'W':
; 277             case 'S':
; 278                 if (cursor >= 7)
	ld a, (cursor)
	cp 7
	jp c, l_30
; 279                     MoveCursor(-7);
	ld a, -7
	call movecursor
	jp l_15
l_30:
; 280                 else
; 281                     MoveCursor(7);
	ld a, 7
	call movecursor
	jp l_15
l_19:
; 282                 break;
; 283             case 'N':
; 284                 Game();
	jp game
l_17:
; 285                 return;
; 286             case 'Q':
; 287                 return;
; 288             case ' ':
; 289                 Click();
	call click
; 290                 if ((uint8_t)(columns[3].count + columns[4].count + columns[5].count + columns[6].count) >=
	ld a, (((columns) + (100)) + (0))
	ld hl, ((columns) + (75)) + (0)
	add (hl)
	ld hl, ((columns) + (125)) + (0)
	add (hl)
	ld hl, ((columns) + (150)) + (0)
	add (hl)
	cp 52
	jp c, l_15
; 291                     VALUES_COUNT * SUIT_COUNT) {
; 292                     WinAnimation();
	call winanimation
; 293                     Game();
	jp game
l_16:
; 294                     return;
; 295                 }
; 296                 break;
; 297             case '2':
; 298                 WinAnimation();
	call winanimation
; 299                 Game();
	jp game
l_15:
l_13:
	jp l_12
l_14:
	ret
putchar:
; 45  putchar(int c) {
	ld (__a_1_putchar), hl
; 46     if (c == 0x0A)
	ld de, 10
	call __o_xor_16
	jp nz, l_34
; 47         cpmBiosConOut(0x0D);
	ld a, 13
	call cpmbiosconout
l_34:
; 48     cpmBiosConOut(c);
	ld a, (__a_1_putchar)
	call cpmbiosconout
; 49     return 0;
	ld hl, 0
	ret
out:
; 20  out(uint8_t port, uint8_t value) {

__a_2_out = __a_2_out
__a_1_out = $ + 1
        out (0), a
    
	ret
drawimage8:
; 19  DrawImage8(uint8_t x, uint8_t y, uint8_t h, const void *image) {
	ld (__a_4_drawimage8), hl

        ; Ширина в C
        ld   c, (hl)
        inc  hl
        ex   hl, de

        ; Сохранение SP
        ld   hl, 0
        add  hl, sp
        ld   (drawimage8_sp), hl

        ; Адрес изображения в SP
        ex   hl, de
        ld   sp, hl

        ; Вычисление старшей части адреса из координаты X
__a_1_drawimage8 = $ + 1
        ld   a, 0
        rrca
        rrca
        and  0FEh
        or   0C0h
        ld   (drawimage8_h), a

        ; Координата Y это младшая часть адреса видеопамяти
__a_2_drawimage8 = $ + 1
        ld   l, 0

        ; Высота изображения в B
__a_3_drawimage8 = $ + 1
        ld   b, 0

        ; Подключение видеопамяти
        ld   a, 10h
        out  (0C1h), a

        ; Основной цикл
drawimage8_l1:
drawimage8_h = $ + 1
            ld   h, 0
            ld   a, c
drawimage8_l0:
                pop  de
                ld   (hl), e
                inc  h
                ld   (hl), d
                inc  h
                pop  de
                ld   (hl), e
                inc  h
                ld   (hl), d
                inc  h
                dec  a
            jp   nz, drawimage8_l0
            inc  l
            dec  b
        jp   nz, drawimage8_l1

        ; Отключение видеопамяти
        xor  a
        out  (0C1h), a

        ; Восстановление регистра SP
drawimage8_sp = $ + 1
        ld   sp, 0
    
	ret
newgame:
; 181  void NewGame(void) {
; 182     uint8_t items[VALUES_COUNT * SUIT_COUNT];
; 183 
; 184     memset(columns, 0, sizeof(columns));
	ld hl, columns
	ld (__a_1_memset), hl
	xor a
	ld (__a_2_memset), a
	ld hl, 350
	call memset
; 185 
; 186     /* Помещаем все карты в колоду */
; 187     uint8_t i;
; 188     for (i = 0; i < COUNTOF(items); i++)
	xor a
	ld (__s_newgame + 52), a
l_36:
	ld a, (__s_newgame + 52)
	cp 52
	jp nc, l_38
; 189         items[i] = i | CLOSED_CARD;
	or 128
	ld hl, (__s_newgame + 52)
	ld h, 0
	ld de, __s_newgame + 0
	add hl, de
	ld (hl), a
l_37:
	ld a, (__s_newgame + 52)
	inc a
	ld (__s_newgame + 52), a
	jp l_36
l_38:
; 190 
; 191     /* Перемешиваем карты */
; 192     for (i = 0; i < COUNTOF(items) - 1; i++) {
	xor a
	ld (__s_newgame + 52), a
l_39:
	ld a, (__s_newgame + 52)
	cp 51
	jp nc, l_41
; 193         uint8_t j = rand() % COUNTOF(items);
	call rand
	ld de, 52
	call __o_mod_u16
	ld a, l
	ld (__s_newgame + 53), a
; 194         uint8_t t = items[j];
	ld hl, (__s_newgame + 53)
	ld h, 0
	ld de, __s_newgame + 0
	add hl, de
	ld a, (hl)
	ld (__s_newgame + 54), a
; 195         items[j] = items[i];
	ld hl, (__s_newgame + 52)
	ld h, 0
	add hl, de
	ld a, (hl)
	ld hl, (__s_newgame + 53)
	ld h, 0
	add hl, de
	ld (hl), a
; 196         items[i] = t;
	ld a, (__s_newgame + 54)
	ld hl, (__s_newgame + 52)
	ld h, 0
	add hl, de
	ld (hl), a
l_40:
	ld a, (__s_newgame + 52)
	inc a
	ld (__s_newgame + 52), a
	jp l_39
l_41:
; 197     }
; 198 
; 199     uint8_t n = COUNTOF(items);
	ld a, 52
	ld (__s_newgame + 53), a
; 200     /* Раскладываем на 7 столбцов */
; 201     for (i = 0; i < 7; i++) {
	xor a
	ld (__s_newgame + 52), a
l_42:
	ld a, (__s_newgame + 52)
	cp 7
	jp nc, l_44
; 202         columns[i + 7].count = i + 1;
	inc a
	ld hl, (__s_newgame + 52)
	ld h, 0
	ld de, 7
	add hl, de
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, columns
	add hl, de
	ld (hl), a
; 203         uint8_t j;
; 204         uint8_t *p = columns[i + 7].items;
	ld hl, (__s_newgame + 52)
	ld h, 0
	ld de, 7
	add hl, de
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, columns
	add hl, de
	inc hl
	ld (__s_newgame + 55), hl
; 205         for (j = 0; j < i; j++) {
	xor a
	ld (__s_newgame + 54), a
l_45:
	ld a, (__s_newgame + 54)
	ld hl, __s_newgame + 52
	cp (hl)
	jp nc, l_47
; 206             n--;
	ld a, (__s_newgame + 53)
	dec a
	ld (__s_newgame + 53), a
; 207             *p++ = items[n];
	ld hl, (__s_newgame + 53)
	ld h, 0
	ld de, __s_newgame + 0
	add hl, de
	ld a, (hl)
	ld hl, (__s_newgame + 55)
	inc hl
	ld (__s_newgame + 55), hl
	dec hl
	ld (hl), a
l_46:
	ld a, (__s_newgame + 54)
	inc a
	ld (__s_newgame + 54), a
	jp l_45
l_47:
; 208         }
; 209         n--;
	ld a, (__s_newgame + 53)
	dec a
	ld (__s_newgame + 53), a
; 210         *p++ = items[n] & ~CLOSED_CARD;
	ld hl, (__s_newgame + 53)
	ld h, 0
	ld de, __s_newgame + 0
	add hl, de
	ld a, (hl)
	and 127
	ld hl, (__s_newgame + 55)
	inc hl
	ld (__s_newgame + 55), hl
	dec hl
	ld (hl), a
l_43:
	ld a, (__s_newgame + 52)
	inc a
	ld (__s_newgame + 52), a
	jp l_42
l_44:
; 211     }
; 212 
; 213     columns[0].count = n;
	ld a, (__s_newgame + 53)
	ld (((columns) + (0)) + (0)), a
; 214     memcpy(columns[0].items, items, n);
	ld hl, ((columns) + (0)) + (1)
	ld (__a_1_memcpy), hl
	ld hl, __s_newgame + 0
	ld (__a_2_memcpy), hl
	ld hl, (__s_newgame + 53)
	ld h, 0
	call memcpy
; 215 
; 216     RedrawAllColumns();
	call redrawallcolumns
; 217     src_cursor = NO_SELECTION;
	ld a, 255
	ld (src_cursor), a
	ret
getkey:
; 309  GetKey(void) {
l_48:
; 310     while (!cpmBiosConSt())
	call cpmbiosconst
	or a
	jp nz, l_49
; 311         rand();
	call rand
	jp l_48
l_49:
; 312 
; 313     uint8_t c = getchar();
	call getchar
	ld a, l
	ld (__s_getkey + 0), a
; 314 
; 315     if (c >= 'a' && c <= 'z')
	cp 97
	jp c, l_50
	ld a, 122
	ld hl, __s_getkey + 0
	cp (hl)
	jp c, l_50
; 316         return c - ('a' - 'A');
	ld a, (__s_getkey + 0)
	add 224
	ret
l_50:
; 317 
; 318     switch (c) {
	ld a, (__s_getkey + 0)
	sub 8
	jp z, l_56
	sub 16
	jp z, l_55
	dec a
	jp z, l_54
	dec a
	jp z, l_53
	jp l_52
l_56:
; 319         case KEY_LEFT:
; 320             return 'A';
	ld a, 65
	ret
l_55:
; 321         case KEY_RIGHT:
; 322             return 'D';
	ld a, 68
	ret
l_54:
; 323         case KEY_UP:
; 324             return 'W';
	ld a, 87
	ret
l_53:
; 325         case KEY_DOWN:
; 326             return 'S';
	ld a, 83
	ret
l_52:
; 327     }
; 328 
; 329     return c;
	ld a, (__s_getkey + 0)
	ret
movecursor:
; 251  void MoveCursor(int8_t delta) {
	ld (__a_1_movecursor), a
; 252     if (cursor == src_cursor)
	ld a, (src_cursor)
	ld hl, cursor
	cp (hl)
	jp nz, l_57
; 253         DrawSrcCursor(cursor);
	ld a, (cursor)
	call drawsrccursor
	jp l_58
l_57:
; 254     else
; 255         HideCursor(cursor);
	ld a, (cursor)
	call hidecursor
l_58:
; 256     cursor += delta;
	ld a, (__a_1_movecursor)
	ld hl, cursor
	add (hl)
	ld (cursor), a
; 257     DrawCursor(cursor);
	jp drawcursor
click:
; 228  void Click(void) {
; 229     /* Нажатие на верхнюю левую стопку */
; 230     if (cursor == 0) {
	ld a, (cursor)
	or a
	jp nz, l_59
; 231         HideSrcCursor();
	call hidesrccursor
; 232         NextCard();
	jp nextcard
l_59:
; 233         return;
; 234     }
; 235 
; 236     /* Третья верхняя стопку не используется */
; 237     if (cursor == 2)
	cp 2
	ret z
; 238         return;
; 239 
; 240     /* Выбор карты */
; 241     if (src_cursor == NO_SELECTION) {
	ld a, (src_cursor)
	cp 255
	jp nz, l_63
; 242         src_cursor = cursor;
	ld a, (cursor)
	ld (src_cursor), a
	ret
l_63:
; 243         return;
; 244     }
; 245 
; 246     /* Перемещение карты между стопками */
; 247     MoveCards();
	call movecards
; 248     HideSrcCursor();
	jp hidesrccursor
winanimation:
; 255  WinAnimation(void) {
l_65:
; 256     do {
; 257         uint8_t i = rand() % SUIT_COUNT;
	call rand
	ld de, 4
	call __o_mod_u16
	ld a, l
	ld (__s_winanimation + 0), a
; 258 
; 259         struct column *c = &columns[i + 3];
	ld hl, (__s_winanimation + 0)
	ld h, 0
	inc hl
	inc hl
	inc hl
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, columns
	add hl, de
	ld (__s_winanimation + 1), hl
; 260         if (c->count == 0)
	ld a, (hl)
	or a
	jp z, l_66
; 261             continue;
; 262 
; 263         uint8_t *card = GetCardImage(c->items[c->count - 1] & ~CLOSED_CARD);
	ld l, (hl)
	ld h, 0
	dec hl
	ex hl, de
	ld hl, (__s_winanimation + 1)
	inc hl
	add hl, de
	ld a, (hl)
	and 127
	call getcardimage
	ld (__s_winanimation + 3), hl
; 264         c->count--;
	ld hl, (__s_winanimation + 1)
	ld a, (hl)
	dec a
	ld (hl), a
; 265 
; 266         /* Вычисление скорости */
; 267         int16_t dx = ((uint8_t)rand() % 64) + 64;
	call rand
	ld a, l
	ld l, a
	ld h, 0
	ld de, 64
	call __o_mod_u16
	ld de, 64
	add hl, de
	ld (__s_winanimation + 5), hl
; 268         if (rand() & 1)
	call rand
	ld de, 1
	call __o_and_16
	ld a, h
	or l
	jp z, l_70
; 269             dx = -dx;
	ld hl, (__s_winanimation + 5)
	call __o_minus_16
	ld (__s_winanimation + 5), hl
l_70:
; 270         int16_t dy = -256 + (uint8_t)rand() % 256;
	call rand
	ld a, l
	ld l, a
	ld h, 0
	ld de, 256
	call __o_mod_u16
	ld de, 65280
	add hl, de
	ld (__s_winanimation + 7), hl
; 271 
; 272         /* Вычисление положения карты */
; 273         static const int FIXED_POINT = 7;
; 274         uint16_t x = (144 + 36 * i) << FIXED_POINT;
	ld hl, (__s_winanimation + 0)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	ld de, 144
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	ld (__s_winanimation + 9), hl
; 275         uint16_t y = 16 << FIXED_POINT;
	ld hl, 2048
	ld (__s_winanimation + 11), hl
l_72:
; 276 
; 277         for (;;) {
; 278             /* Рисование карты на экране */
; 279             uint16_t gx = (x + (1 << (FIXED_POINT - 1))) >> FIXED_POINT;
	ld hl, (__s_winanimation + 9)
	ld de, 64
	add hl, de
	ld de, 7
	call __o_shr_u16
	ld (__s_winanimation + 13), hl
; 280             uint8_t gy = (y + (1 << (FIXED_POINT - 1))) >> FIXED_POINT;
	ld hl, (__s_winanimation + 11)
	ld de, 64
	add hl, de
	ld de, 7
	call __o_shr_u16
	ld a, l
	ld (__s_winanimation + 15), a
; 281             DrawImage(gx - IMAGE_CARD_BACK_WIDTH, gy, IMAGE_CARD_HEIGHT, card);
	ld hl, (__s_winanimation + 13)
	ld de, 65504
	add hl, de
	ld (__a_1_drawimage), hl
	ld (__a_2_drawimage), a
	ld a, 48
	ld (__a_3_drawimage), a
	ld hl, (__s_winanimation + 3)
	call drawimage
; 282 
; 283             /* Изменение скорости */
; 284             dy -= dy / 256;
	ld hl, (__s_winanimation + 7)
	ld de, 256
	call __o_div_i16
	ex hl, de
	ld hl, (__s_winanimation + 7)
	call __o_sub_16
; 285             dy += 32;
	ld de, 32
	add hl, de
	ld (__s_winanimation + 7), hl
; 286 
; 287             /* Изменение положения */
; 288             y += dy;
	ex hl, de
	ld hl, (__s_winanimation + 11)
	add hl, de
	ld (__s_winanimation + 11), hl
; 289             x += dx;
	ld hl, (__s_winanimation + 5)
	ex hl, de
	ld hl, (__s_winanimation + 9)
	add hl, de
	ld (__s_winanimation + 9), hl
; 290 
; 291             /* Отскок от нижней границы экрана */
; 292             static const uint16_t max_y = (SCREEN_HEIGHT - IMAGE_CARD_HEIGHT) << FIXED_POINT;
; 293             if (y >= max_y) {
	ld hl, (__s_winanimation + 11)
	ld de, 26624
	call __o_sub_16
	jp c, l_75
; 294                 y = max_y;
	ld hl, 26624
	ld (__s_winanimation + 11), hl
; 295                 dy = -dy;
	ld hl, (__s_winanimation + 7)
	call __o_minus_16
	ld (__s_winanimation + 7), hl
; 296                 if (cpmBiosConSt())
	call cpmbiosconst
	or a
	jp nz, l_74
l_75:
; 297                     break;
; 298             }
; 299 
; 300             /* Если карта за пределами экрана - выход */
; 301             if (x >= (SCREEN_WIDTH_PIXELS + IMAGE_CARD_BACK_WIDTH) << FIXED_POINT)
	ld hl, (__s_winanimation + 9)
	ld de, 36864
	call __o_sub_16
	jp nc, l_74
l_73:
	jp l_72
l_74:
l_66:
; 302                 break;
; 303         }
; 304     } while (!cpmBiosConSt());
	call cpmbiosconst
	or a
	jp z, l_65
l_67:
; 305     cpmBiosConIn();
	call cpmbiosconin
; 306     Redraw();
	jp redraw
cpmbiosconout:
; 36  void __fastcall cpmBiosConOut(uint8_t c) {
	ld (__a_1_cpmbiosconout), a

        ld c, a
        ld hl, (1)
        ld l, 0Ch
        jp hl
    
	ret
memset:
; 20  *__fastcall memset(void *destination, uint8_t byte, size_t size) {
	ld (__a_3_memset), hl
; 21     (void)destination;
	ld hl, (__a_1_memset)
; 22     (void)byte;
	ld a, (__a_2_memset)
; 23     (void)size;
	ld hl, (__a_3_memset)

        ex hl, de             ; de = size
        ld hl, (__a_1_memset) ; hl = destination
        inc d                 ; enter loop
        xor a
        or e
        ld a, (__a_2_memset)  ; bc = byte
        jp z, memset_2
memset_1:
        ld (hl), a
        inc hl
        inc bc
        dec e               ; end loop
        jp nz, memset_1
memset_2:
        dec d
        jp nz, memset_1
        ld hl, (__a_1_memset) ; return destination
    
	ret
memcpy:
; 20  *__fastcall memcpy(void *destination, const void *source, size_t size) {
	ld (__a_3_memcpy), hl
; 21     (void)destination;
	ld hl, (__a_1_memcpy)
; 22     (void)source;
	ld hl, (__a_2_memcpy)
; 23     (void)size;
	ld hl, (__a_3_memcpy)

        push bc
        ex hl, de             ; de = size
        ld hl, (__a_2_memcpy) ; bc = source
        ld c, l
        ld b, h
        ld hl, (__a_1_memcpy) ; hl = destination
        inc d                 ; enter loop
        xor a
        or e
        jp z, memcpy_2
memcpy_1:
        ld a, (bc)
        ld (hl), a
        inc hl
        inc bc
        dec e                 ; end loop
        jp nz, memcpy_1
memcpy_2:
        dec d
        jp nz, memcpy_1
        pop bc
        ld hl, (__a_1_memcpy) ; return destination
    
	ret
redrawallcolumns:
; 137  RedrawAllColumns(void) {
; 138     uint8_t i;
; 139     for (i = 0; i < COUNTOF(ui_columns); i++)
	xor a
	ld (__s_redrawallcolumns + 0), a
l_81:
	ld a, (__s_redrawallcolumns + 0)
	cp 14
	ret nc
; 140         RedrawColumn(i);
	call redrawcolumn
l_82:
	ld a, (__s_redrawallcolumns + 0)
	inc a
	ld (__s_redrawallcolumns + 0), a
	jp l_81
getchar:
; 34  getchar() {
; 35     return cpmBiosConIn();
	call cpmbiosconin
	ld l, a
	ld h, 0
	ret
drawsrccursor:
; 152  DrawSrcCursor(uint8_t column_index) {
	ld (__a_1_drawsrccursor), a
; 153     DrawCursorInt(column_index, image_src_cursor);
	ld (__a_1_drawcursorint), a
	ld hl, image_src_cursor
	jp drawcursorint
hidecursor:
; 156  HideCursor(uint8_t column_index) {
	ld (__a_1_hidecursor), a
; 157     DrawCursorInt(column_index, image_background);
	ld (__a_1_drawcursorint), a
	ld hl, image_background
	jp drawcursorint
drawcursor:
; 148  DrawCursor(uint8_t column_index) {
	ld (__a_1_drawcursor), a
; 149     DrawCursorInt(column_index, image_cursor);
	ld (__a_1_drawcursorint), a
	ld hl, image_cursor
	jp drawcursorint
hidesrccursor:
; 220  void HideSrcCursor(void) {
; 221     if (src_cursor == NO_SELECTION)
	ld a, (src_cursor)
	cp 255
	ret z
; 222         return;
; 223     if (src_cursor != cursor)
	ld a, (cursor)
	ld hl, src_cursor
	cp (hl)
	jp z, l_86
; 224         HideCursor(src_cursor);
	ld a, (src_cursor)
	call hidecursor
l_86:
; 225     src_cursor = NO_SELECTION;
	ld a, 255
	ld (src_cursor), a
	ret
nextcard:
; 85  void NextCard(void) {
; 86     uint8_t card = PeekCard(0);
	xor a
	call peekcard
	ld (__s_nextcard + 0), a
; 87     if (card == NO_CARD) {
	cp 255
	jp nz, l_88
; 88         RewindCards();
	jp rewindcards
l_88:
; 89     } else {
; 90         PutCard(1, card & ~CLOSED_CARD);
	ld a, 1
	ld (__a_1_putcard), a
	ld a, (__s_nextcard + 0)
	and 127
	call putcard
; 91         GetCard(0);
	xor a
	call getcard
; 92         RedrawColumn(0);
	xor a
	call redrawcolumn
; 93         RedrawColumn(1);
	ld a, 1
	jp redrawcolumn
movecards:
; 97  void MoveCards(void) {
; 98     if (cursor == src_cursor)
	ld a, (src_cursor)
	ld hl, cursor
	cp (hl)
	ret z
; 99         return;
; 100 
; 101     /* Игрок не может переместить карты в первые 3 стопки */
; 102     if (cursor < 3)
	ld a, (cursor)
	cp 3
	ret c
; 103         return;
; 104 
; 105     /* Какую карту перемещаем */
; 106     struct column *from_column = &columns[src_cursor];
	ld hl, (src_cursor)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, columns
	add hl, de
	ld (__s_movecards + 0), hl
; 107     uint8_t src_index = from_column->count - 1;
	ld a, (hl)
	dec a
	ld (__s_movecards + 2), a
; 108     if (src_index == 0xFF)
	cp 255
	ret z
; 109         return;
; 110     uint8_t card = from_column->items[src_index];
	ld hl, (__s_movecards + 2)
	ld h, 0
	ex hl, de
	ld hl, (__s_movecards + 0)
	inc hl
	add hl, de
	ld a, (hl)
	ld (__s_movecards + 3), a
; 111     uint8_t card_suit = card / VALUES_COUNT;
	ld hl, (__s_movecards + 3)
	ld h, 0
	ld de, 13
	call __o_div_u16
	ld a, l
	ld (__s_movecards + 4), a
; 112     uint8_t card_value = __div_16_mod;
	ld a, (__div_16_mod)
	ld (__s_movecards + 5), a
; 113 
; 114     /* На какую карту переместить */
; 115     uint8_t dest_card = PeekCard(cursor); /* Может быть NO_CARD */
	ld a, (cursor)
	call peekcard
	ld (__s_movecards + 6), a
; 116     uint8_t dest_suit = dest_card / VALUES_COUNT;
	ld hl, (__s_movecards + 6)
	ld h, 0
	ld de, 13
	call __o_div_u16
	ld a, l
	ld (__s_movecards + 7), a
; 117     uint8_t dest_value = __div_16_mod;
	ld a, (__div_16_mod)
	ld (__s_movecards + 8), a
; 118 
; 119     /* 4 верхние стопки */
; 120     if (cursor < 7) {
	ld a, (cursor)
	cp 7
	jp nc, l_96
; 121         /* В пустую стопку можно переместить только туз */
; 122         if (dest_card == NO_CARD) {
	ld a, (__s_movecards + 6)
	cp 255
	jp nz, l_98
; 123             if (card_value != VALUE_ACE)
	ld a, (__s_movecards + 5)
	or a
	ret nz
	jp l_97
l_98:
; 124                 return;
; 125         } else {
; 126             /* На карту можно положить карту, если её стоимость на 1 меньше и масть не отличается */
; 127             if (dest_value + 1 != card_value || dest_suit != card_suit)
	ld hl, (__s_movecards + 5)
	ld h, 0
	ex hl, de
	ld hl, (__s_movecards + 8)
	ld h, 0
	inc hl
	call __o_xor_16
	ret nz
	ld a, (__s_movecards + 4)
	ld hl, __s_movecards + 7
	cp (hl)
	ret nz
	jp l_97
l_96:
l_105:
; 128                 return;
; 129         }
; 130     } else {
; 131         /* Нижние 7 стопок */
; 132         for (;;) {
; 133             /* В пустую стопку можно переместить только короля */
; 134             if (dest_card == NO_CARD) {
	ld a, (__s_movecards + 6)
	cp 255
	jp nz, l_108
; 135                 if (card_value == VALUE_KING)
	ld a, (__s_movecards + 5)
	cp 12
	jp z, l_107
	jp l_109
l_108:
; 136                     break;
; 137             } else {
; 138                 /* На карту можно положить карту, если её стоимость на 1 больше и цвет отличается */
; 139                 if (dest_value == card_value + 1 && dest_suit / 2 != card_suit / 2)
	ld hl, (__s_movecards + 5)
	ld h, 0
	inc hl
	ex hl, de
	ld hl, (__s_movecards + 8)
	ld h, 0
	call __o_xor_16
	jp nz, l_112
	ld hl, (__s_movecards + 4)
	ld h, 0
	ld de, 1
	call __o_shr_u16
	push hl
	ld hl, (__s_movecards + 7)
	ld h, 0
	ld de, 1
	call __o_shr_u16
	pop de
	call __o_xor_16
	jp nz, l_107
l_112:
l_109:
; 140                     break;
; 141             }
; 142 
; 143             /* Пробуем переместить несколько карт */
; 144             if (src_index == 0 || src_cursor < 7)
	ld a, (__s_movecards + 2)
	or a
	ret z
	ld a, (src_cursor)
	cp 7
	ret c
; 145                 return;
; 146             src_index--;
	ld a, (__s_movecards + 2)
	dec a
	ld (__s_movecards + 2), a
; 147             card = from_column->items[src_index];
	ld hl, (__s_movecards + 2)
	ld h, 0
	ex hl, de
	ld hl, (__s_movecards + 0)
	inc hl
	add hl, de
	ld a, (hl)
	ld (__s_movecards + 3), a
; 148             if (card & CLOSED_CARD)
	and 128
	ret nz
; 149                 return; /* Скрытую карту не перемещаем */
; 150             card_suit = card / VALUES_COUNT;
	ld hl, (__s_movecards + 3)
	ld h, 0
	ld de, 13
	call __o_div_u16
	ld a, l
	ld (__s_movecards + 4), a
; 151             card_value = __div_16_mod;
	ld a, (__div_16_mod)
	ld (__s_movecards + 5), a
l_106:
	jp l_105
l_107:
l_97:
; 152         }
; 153     }
; 154 
; 155     struct column *to_column = &columns[cursor];
	ld hl, (cursor)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, columns
	add hl, de
	ld (__s_movecards + 9), hl
; 156     uint8_t from_coumn = src_cursor;
	ld a, (src_cursor)
	ld (__s_movecards + 11), a
; 157     uint8_t from_count = from_column->count;
	ld hl, (__s_movecards + 0)
	ld a, (hl)
	ld (__s_movecards + 12), a
; 158     uint8_t to_count = to_column->count;
	ld hl, (__s_movecards + 9)
	ld a, (hl)
	ld (__s_movecards + 13), a
; 159     uint8_t delta = from_count - src_index;
	ld a, (__s_movecards + 12)
	ld hl, __s_movecards + 2
	sub (hl)
	ld (__s_movecards + 14), a
; 160 
; 161     if (to_column->count + delta > sizeof(to_column->items))
	ld hl, (__s_movecards + 14)
	ld h, 0
	ex hl, de
	ld hl, (__s_movecards + 9)
	ld l, (hl)
	ld h, 0
	add hl, de
	ld de, 25
	call __o_sub_16
	ret nc
; 162         return;
; 163 
; 164     from_column->count = src_index;
	ld a, (__s_movecards + 2)
	ld hl, (__s_movecards + 0)
	ld (hl), a
; 165     RedrawColumn(from_coumn);
	ld a, (__s_movecards + 11)
	call redrawcolumn
; 166     src_cursor = NO_SELECTION;
	ld a, 255
	ld (src_cursor), a
; 167 
; 168     MoveAnimation(from_coumn, cursor, src_index, from_count);
	ld a, (__s_movecards + 11)
	ld (__a_1_moveanimation), a
	ld a, (cursor)
	ld (__a_2_moveanimation), a
	ld a, (__s_movecards + 2)
	ld (__a_3_moveanimation), a
	ld a, (__s_movecards + 12)
	call moveanimation
; 169 
; 170     memcpy(to_column->items + to_count, from_column->items + src_index, delta);
	ld hl, (__s_movecards + 13)
	ld h, 0
	ex hl, de
	ld hl, (__s_movecards + 9)
	inc hl
	add hl, de
	ld (__a_1_memcpy), hl
	ld hl, (__s_movecards + 2)
	ld h, 0
	ex hl, de
	ld hl, (__s_movecards + 0)
	inc hl
	add hl, de
	ld (__a_2_memcpy), hl
	ld hl, (__s_movecards + 14)
	ld h, 0
	call memcpy
; 171     to_column->count += delta;
	ld hl, (__s_movecards + 9)
	ld a, (__s_movecards + 14)
	add (hl)
	ld (hl), a
; 172 
; 173     RedrawColumn(cursor);
	ld a, (cursor)
	call redrawcolumn
; 174 
; 175     if (src_index != 0) {
	ld a, (__s_movecards + 2)
	or a
	ret z
; 176         from_column->items[src_index - 1] &= ~CLOSED_CARD;
	ld hl, (__s_movecards + 2)
	ld h, 0
	dec hl
	ex hl, de
	ld hl, (__s_movecards + 0)
	inc hl
	add hl, de
	ld a, (hl)
	and 127
	ld (hl), a
; 177         RedrawColumn(from_coumn);
	ld a, (__s_movecards + 11)
	jp redrawcolumn
getcardimage:
; 56  uint8_t *GetCardImage(uint8_t card_index) {
	ld (__a_1_getcardimage), a
; 57     if (card_index & CLOSED_CARD)
	and 128
	jp z, l_123
; 58         return image_card_back;
	ld hl, image_card_back
	ret
l_123:
; 59     return &image_cards[card_index * IMAGE_CARD_SIZEOF];
	ld hl, (__a_1_getcardimage)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, image_cards
	add hl, de
	ret
drawimage:
; 88  DrawImage(int16_t x, uint8_t y, uint8_t height, const void *image) {

        ; Сохранение ширины
        ld   a, (hl)
        inc  hl
        add  a
        ld   (drawimage_w), a
        add  a
        ld   (DrawImage_BPL), a

        ; Сохранение адреса изображения
        ld   (__a_4_drawimage), hl

        ; *** Настройка команд сдвига и битовых масок ***
        ld   a, (__a_1_drawimage) ; x
        and  7
        sub  4
        jp   nc, DrawImage_Shift4567
        add  2
        jp   c, DrawImage_Shift23
        inc  a
        jp   z, DrawImage_Shift1
DrawImage_Shift0:
        ld   hl, 0000h              ; NOP + NOP
        ld   de, hl                 ; NOP + NOP
        ld   a, (0FFh << 0) & 0FFh
        jp   DrawImage_Shift
DrawImage_Shift1:
        ld   hl, 0007h              ; RLCA + NOP
        ld   d, h                   ; NOP
        ld   e, h                   ; NOP
        ld   a, (0FFh << 1) & 0FFh
        jp   DrawImage_Shift
DrawImage_Shift23:
        jp   nz, DrawImage_Shift3
DrawImage_Shift2:
        ld   hl, 0700h              ; RLCA + NOP
        ld   de, hl                 ; RLCA + NOP
        ld   a, (0FFh << 2) & 0FFh
        jp   DrawImage_Shift
DrawImage_Shift3:
        ld   hl, 0707h              ; RLCA + RLCA
        ld   de, 0007h              ; RLCA + NOP
        ld   a, (0FFh << 3) & 0FFh
        jp   DrawImage_Shift
DrawImage_Shift4567:
        sub  2
        jp   nc, DrawImage_Shift67
        inc  a
        jp   z, DrawImage_Shift5
DrawImage_Shift4:
        ld   hl, 0707h              ; RLCA + RLCA
        ld   de, hl                 ; RLCA + RLCA
        ld   a, (0FFh << 4) & 0FFh
        jp   DrawImage_Shift
DrawImage_Shift5:
        ld   hl, 0F0Fh              ; RRCA + RRCA
        ld   de, 000Fh              ; RRCA + NOP
        ld   a, (0FFh << 5) & 0FFh
        jp   DrawImage_Shift
DrawImage_Shift67:
        jp   nz, DrawImage_Shift7
DrawImage_Shift6:
        ld   hl, 0F00h              ; RRCA + NOP
        ld   de, hl                 ; RRCA + NOP
        ld   a, (0FFh << 6) & 0FFh
        jp   DrawImage_Shift
DrawImage_Shift7:
        ld   hl, 000Fh              ; RRCA + NOP
        ld   d, h                   ; NOP
        ld   e, h                   ; NOP
        ld   a, (0FFh << 7) & 0FFh
DrawImage_Shift:
        ld   (DrawImage_Rotate0), hl
        ld   (DrawImage_Rotate1), hl
        ld   (DrawImage_Rotate2), hl
        ld   (DrawImage_Rotate3), hl
        ex   hl, de
        ld   (DrawImage_Rotate0 + 2), hl
        ld   (DrawImage_Rotate1 + 2), hl
        ld   (DrawImage_Rotate2 + 2), hl
        ld   (DrawImage_Rotate3 + 2), hl
        ld   (DrawImage_Mask0), a
        ld   (DrawImage_Mask1), a
        ld   (DrawImage_Mask2), a
        ld   (DrawImage_Mask3), a
        cpl
        ld   (DrawImage_InvMask0), a
        ld   (DrawImage_InvMask1), a
        ld   (DrawImage_InvMask2), a
        ld   (DrawImage_InvMask3), a
        ld   (DrawImage_InvMask4), a
        ld   (DrawImage_InvMask5), a

        ; *** Если изображение частично или полностью за краем экрана ***

        ; Может быть X за пределами экрана?
        ld   a, (__a_1_drawimage + 1)
        or   a
        jp   z, DrawImage_NoLeftClip
        cp   0FFh
        ret  nz

        ; Вычисление кол-ва невидимых байт слева
        ld   a, (__a_1_drawimage) ; x
        rrca
        rrca
        rrca
        cpl
        inc a
        and  01Fh
        ld   b, a

        ; Уменьшение ширины на невидимую часть
        ld   a, (drawimage_w)
        sub  b
        ret  c
        ld   (drawimage_w), a

        ; Увеличение адреса изображения на невидимую часть
        ld   hl, (__a_4_drawimage)
        ld   a, l
        add  b
        add  b
        ld   l, a
        ld   a, h
        adc  0
        ld   h, a
        ld   (__a_4_drawimage), hl

        ; Выключение вывода первого байта
        ld   hl, DrawImage_LineCroppedLeft
        ld   (DrawImage_LineAddr), hl

        ; Включение вывода последнего байта
        ld   a, 077h  ; ld (hl), a

        ld   d, 0C0h  ; Адрес в видеопамяти
        jp   DrawImage_NoClip

DrawImage_NoLeftClip:
        ; Включение вывода первого байта
        ld   hl, DrawImage_Line
        ld   (DrawImage_LineAddr), hl

        ; Вычисление кол-ва невидимых байт справа
        ld   a, (__a_1_drawimage) ; x
        rrca
        rrca
        rrca
        or   0E0h
        ld   e, a
        add  a
        ld   d, a ; Адрес в видеопамяти

        ; Уменьшение ширины на невидимую часть
        ld   a, e
        ld   hl, drawimage_w ; width8
        add  (hl)
        ld   a, 077h  ; Включение вывода последнего байта - ld (hl), a
        jp   nc, DrawImage_NoClip
        xor  a
        sub  e
        ld   (hl), a

        ; Выключение вывода последнего байта
        xor  a  ; NOP
DrawImage_NoClip:
        ld   (DrawImage_LastByte0), a
        ld   (DrawImage_LastByte1), a

        ; *** Вывод изображения ***

__a_2_drawimage = $ + 1
        ld   e, 0  ; y

__a_4_drawimage = $ + 1
        ld   hl, 0  ; image
        ex   hl, de

        ld   a, 10h
        out  (0C1h), a

__a_3_drawimage = $ + 1
        ld   b, 0  ; height
DrawImage_Loop:
        push bc
        push hl
        push de
drawimage_w = $ + 1
        ld   c, 0

DrawImage_LineAddr = $ + 1
        jp   DrawImage_Line
DrawImage_Line:

        ; Для объединения первого байта изображения с содержимым видеопамяти
        ld   a, (hl)
DrawImage_InvMask0 = $ + 1
        and  0
        ld   (DrawImage_Data0), a
        inc  h
        ld   a, (hl)
DrawImage_InvMask1 = $ + 1
        and  0
        ld   (DrawImage_Data1), a
        dec  h

        ; Вывод изображения

DrawImage_MiddleBytes:
        ld   a, (de)
        inc  de
DrawImage_Rotate0 = $
        rlca
        rlca
        rlca
        rlca
        ld   b, a
DrawImage_Mask0 = $ + 1
        and  0
DrawImage_Data0 = $ + 1
        or   0
        ld   (hl), a
        inc  h
        ld   a, b
DrawImage_InvMask2 = $ + 1
        and  0
        ld   (DrawImage_Data0), a

        ld   a, (de)
        inc  de
DrawImage_Rotate1:
        rlca
        rlca
        rlca
        rlca
        ld   b, a
DrawImage_Mask1 = $ + 1
        and  0
DrawImage_Data1 = $ + 1
        or   0
        ld   (hl), a
        inc  h
        ld   a, b
DrawImage_InvMask3 = $ + 1
        and  0
        ld   (DrawImage_Data1), a

        dec  c
        jp   nz, DrawImage_MiddleBytes

        ; Объединение последнего байта изображения с содержимым видеопамяти

DrawImage_LastByte:
        ld   a, (DrawImage_Data0)
        ld   b, a
        ld   a, (hl)
DrawImage_Mask2 = $ + 1
        and  0
        or   b
DrawImage_LastByte0 = $
        ld   (hl), a
        inc  h
        ld   a, (DrawImage_Data1)
        ld   b, a
        ld   a, (hl)
DrawImage_Mask3 = $ + 1
        and  0
        or   b
DrawImage_LastByte1 = $
        ld   (hl), a
        pop  de
DrawImage_BPL = $ + 1
        ld   hl, 0
        add  hl, de
        ex   de, hl
        pop  hl
        pop  bc
        inc  l
        dec  b
        jp   nz, DrawImage_Loop

        xor  a
        out  (0C1h), a
        ret

DrawImage_LineCroppedLeft:
        ; Подготовка к выводу изображения обрезанного левым краем экрана

        dec  de
        dec  de
        ld   a, (de)
        inc  de        
DrawImage_Rotate2 = $
        rlca
        rlca
        rlca
        rlca
DrawImage_InvMask4 = $ + 1
        and  0
        ld   (DrawImage_Data0), a
        ld   a, (de)
        inc  de
DrawImage_Rotate3 = $
        rlca
        rlca
        rlca
        rlca
DrawImage_InvMask5 = $ + 1
        and  0
        ld   (DrawImage_Data1), a

        ld   a, c
        or   a
        jp   z, DrawImage_LastByte

        jp   DrawImage_MiddleBytes
    
	ret
cpmbiosconin:
; 20  __fastcall cpmBiosConIn(void) {

        ld hl, (1)
        ld l, 7
        jp hl
    
	ret
redrawcolumn:
; 86  RedrawColumn(uint8_t column_index) {
	ld (__a_1_redrawcolumn), a
; 87     struct ui_column *ui = &ui_columns[column_index];
	ld hl, (__a_1_redrawcolumn)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	ld de, ui_columns
	add hl, de
	ld (__s_redrawcolumn + 0), hl
; 88     uint8_t x = ui->x;
	ld a, (hl)
	ld (__s_redrawcolumn + 2), a
; 89     uint8_t y = ui->y;
	inc hl
	ld a, (hl)
	ld (__s_redrawcolumn + 3), a
; 90 
; 91     if (column_index >= 7) {
	ld a, (__a_1_redrawcolumn)
	cp 7
	jp c, l_125
; 92         struct column *c = &columns[column_index];
	ld hl, (__a_1_redrawcolumn)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, columns
	add hl, de
	ld (__s_redrawcolumn + 4), hl
; 93         uint8_t *p = c->items;
	inc hl
	ld (__s_redrawcolumn + 6), hl
; 94         uint8_t i = c->count;
	ld hl, (__s_redrawcolumn + 4)
	ld a, (hl)
	ld (__s_redrawcolumn + 8), a
; 95 
; 96         if (i > MAX_VISIBLE_CARDS) {
	cp 18
	jp c, l_127
; 97             uint8_t j = (i - MAX_VISIBLE_CARDS) * 2;
	add 239
	add a
	ld (__s_redrawcolumn + 9), a
; 98             i -= j;
	ld a, (__s_redrawcolumn + 8)
	ld hl, __s_redrawcolumn + 9
	sub (hl)
	ld (__s_redrawcolumn + 8), a
l_129:
; 99             do {
; 100                 DrawImage(x, y, SMALL_CARD_STEP, GetCardImage(*p));
	ld hl, (__s_redrawcolumn + 2)
	ld h, 0
	ld (__a_1_drawimage), hl
	ld a, (__s_redrawcolumn + 3)
	ld (__a_2_drawimage), a
	ld a, 4
	ld (__a_3_drawimage), a
	ld hl, (__s_redrawcolumn + 6)
	ld a, (hl)
	call getcardimage
	call drawimage
; 101                 p++;
	ld hl, (__s_redrawcolumn + 6)
	inc hl
	ld (__s_redrawcolumn + 6), hl
; 102                 y += SMALL_CARD_STEP;
	ld a, (__s_redrawcolumn + 3)
	add 4
	ld (__s_redrawcolumn + 3), a
; 103                 j--;
	ld a, (__s_redrawcolumn + 9)
	dec a
	ld (__s_redrawcolumn + 9), a
l_130:
; 104             } while (j != 0);
	ld a, (__s_redrawcolumn + 9)
	or a
	jp nz, l_129
l_131:
l_127:
l_132:
; 105         }
; 106 
; 107         for (; i > 1; i--) {
	ld a, (__s_redrawcolumn + 8)
	cp 2
	jp c, l_134
; 108             DrawImage(x, y, BIG_CARD_STEP, GetCardImage(*p));
	ld hl, (__s_redrawcolumn + 2)
	ld h, 0
	ld (__a_1_drawimage), hl
	ld a, (__s_redrawcolumn + 3)
	ld (__a_2_drawimage), a
	ld a, 8
	ld (__a_3_drawimage), a
	ld hl, (__s_redrawcolumn + 6)
	ld a, (hl)
	call getcardimage
	call drawimage
; 109             p++;
	ld hl, (__s_redrawcolumn + 6)
	inc hl
	ld (__s_redrawcolumn + 6), hl
; 110             y += BIG_CARD_STEP;
	ld a, (__s_redrawcolumn + 3)
	add 8
	ld (__s_redrawcolumn + 3), a
l_133:
	ld a, (__s_redrawcolumn + 8)
	dec a
	ld (__s_redrawcolumn + 8), a
	jp l_132
l_134:
l_125:
; 111         }
; 112     }
; 113 
; 114     if (column_index != 2)
	ld a, (__a_1_redrawcolumn)
	cp 2
	jp z, l_135
; 115         DrawImage(x, y, IMAGE_CARD_BACK_HEIGHT, GetTopCardImage(column_index));
	ld hl, (__s_redrawcolumn + 2)
	ld h, 0
	ld (__a_1_drawimage), hl
	ld a, (__s_redrawcolumn + 3)
	ld (__a_2_drawimage), a
	ld a, 48
	ld (__a_3_drawimage), a
	ld a, (__a_1_redrawcolumn)
	call gettopcardimage
	call drawimage
l_135:
; 116     y += IMAGE_CARD_BACK_HEIGHT;
	ld a, (__s_redrawcolumn + 3)
	add 48
	ld (__s_redrawcolumn + 3), a
; 117 
; 118     ui->cursor_y = y;
	ld hl, (__s_redrawcolumn + 0)
	inc hl
	inc hl
	ld (hl), a
; 119     if (cursor == column_index) {
	ld a, (__a_1_redrawcolumn)
	ld hl, cursor
	cp (hl)
	jp nz, l_137
; 120         DrawImage(x, y, IMAGE_CURSOR_HEIGHT, image_cursor);
	ld hl, (__s_redrawcolumn + 2)
	ld h, 0
	ld (__a_1_drawimage), hl
	ld a, (__s_redrawcolumn + 3)
	ld (__a_2_drawimage), a
	ld a, 8
	ld (__a_3_drawimage), a
	ld hl, image_cursor
	call drawimage
; 121         y += IMAGE_CURSOR_HEIGHT;
	ld a, (__s_redrawcolumn + 3)
	add 8
	ld (__s_redrawcolumn + 3), a
l_137:
; 122     }
; 123 
; 124     if (column_index >= 7) {
	ld a, (__a_1_redrawcolumn)
	cp 7
	jp c, l_139
l_141:
; 125         while (y != 0) {
	ld a, (__s_redrawcolumn + 3)
	or a
	ret z
; 126             uint8_t h = IMAGE_CARD_HEIGHT;
	ld a, 48
	ld (__s_redrawcolumn + 4), a
; 127             if (y > SCREEN_HEIGHT - IMAGE_CARD_HEIGHT)
	ld a, (__s_redrawcolumn + 3)
	cp 209
	jp c, l_143
; 128                 h = 0 - y;
	xor a
	ld hl, __s_redrawcolumn + 3
	sub (hl)
	ld (__s_redrawcolumn + 4), a
l_143:
; 129             DrawImage(x, y, h, image_background);
	ld hl, (__s_redrawcolumn + 2)
	ld h, 0
	ld (__a_1_drawimage), hl
	ld a, (__s_redrawcolumn + 3)
	ld (__a_2_drawimage), a
	ld a, (__s_redrawcolumn + 4)
	ld (__a_3_drawimage), a
	ld hl, image_background
	call drawimage
; 130             y += h;
	ld a, (__s_redrawcolumn + 4)
	ld hl, __s_redrawcolumn + 3
	add (hl)
	ld (__s_redrawcolumn + 3), a
	jp l_141
l_142:
	ret
l_139:
; 131         }
; 132     } else if (cursor != column_index) {
	ld hl, cursor
	cp (hl)
	jp z, l_145
; 133         DrawImage(x, y, IMAGE_CURSOR_HEIGHT, image_background);
	ld hl, (__s_redrawcolumn + 2)
	ld h, 0
	ld (__a_1_drawimage), hl
	ld a, (__s_redrawcolumn + 3)
	ld (__a_2_drawimage), a
	ld a, 8
	ld (__a_3_drawimage), a
	ld hl, image_background
	jp drawimage
l_145:
	ret
drawcursorint:
; 143  void DrawCursorInt(uint8_t column_index, uint8_t *image) {
	ld (__a_2_drawcursorint), hl
; 144     struct ui_column *c = &ui_columns[column_index];
	ld hl, (__a_1_drawcursorint)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	ld de, ui_columns
	add hl, de
	ld (__s_drawcursorint + 0), hl
; 145     DrawImage(c->x, c->cursor_y, IMAGE_CURSOR_HEIGHT, image);
	ld l, (hl)
	ld h, 0
	ld (__a_1_drawimage), hl
	ld hl, (__s_drawcursorint + 0)
	inc hl
	inc hl
	ld a, (hl)
	ld (__a_2_drawimage), a
	ld a, 8
	ld (__a_3_drawimage), a
	ld hl, (__a_2_drawcursorint)
	jp drawimage
peekcard:
; 44  uint8_t PeekCard(uint8_t column_index) {
	ld (__a_1_peekcard), a
; 45     struct column *c = &columns[column_index];
	ld hl, (__a_1_peekcard)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, columns
	add hl, de
	ld (__s_peekcard + 0), hl
; 46     uint8_t count = c->count;
	ld a, (hl)
	ld (__s_peekcard + 2), a
; 47     if (count == 0)
	or a
	jp nz, l_147
	ld a, 255
	ret
l_147:
; 48         return NO_CARD;
; 49     return c->items[count - 1];
	ld hl, (__s_peekcard + 2)
	ld h, 0
	dec hl
	ex hl, de
	ld hl, (__s_peekcard + 0)
	inc hl
	add hl, de
	ld a, (hl)
	ret
rewindcards:
; 73  void RewindCards(void) {
l_149:
; 74     for (;;) {
; 75         uint8_t card = PeekCard(1);
	ld a, 1
	call peekcard
	ld (__s_rewindcards + 0), a
; 76         if (card == NO_CARD)
	cp 255
	jp z, l_151
; 77             break;
; 78         PutCard(0, card | CLOSED_CARD);
	xor a
	ld (__a_1_putcard), a
	ld a, (__s_rewindcards + 0)
	or 128
	call putcard
; 79         GetCard(1);
	ld a, 1
	call getcard
l_150:
	jp l_149
l_151:
; 80     }
; 81     RedrawColumn(0);
	xor a
	call redrawcolumn
; 82     RedrawColumn(1);
	ld a, 1
	jp redrawcolumn
putcard:
; 63  bool PutCard(uint8_t column_index, uint8_t card) {
	ld (__a_2_putcard), a
; 64     struct column *c = &columns[column_index];
	ld hl, (__a_1_putcard)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, columns
	add hl, de
	ld (__s_putcard + 0), hl
; 65     uint8_t count = c->count;
	ld a, (hl)
	ld (__s_putcard + 2), a
; 66     if (count == COUNTOF(c->items))
	cp 24
	jp nz, l_154
; 24 ;
	xor a
	ret
l_154:
; 68 ->items[count] = card;
	ld a, (__a_2_putcard)
	ld hl, (__s_putcard + 2)
	ld h, 0
	ex hl, de
	ld hl, (__s_putcard + 0)
	inc hl
	add hl, de
	ld (hl), a
; 69     c->count = count + 1;
	ld a, (__s_putcard + 2)
	inc a
	ld hl, (__s_putcard + 0)
	ld (hl), a
; 25 ;
	ld a, 1
	ret
getcard:
; 52  void GetCard(uint8_t column_index) {
	ld (__a_1_getcard), a
; 53     struct column *c = &columns[column_index];
	ld hl, (__a_1_getcard)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, columns
	add hl, de
	ld (__s_getcard + 0), hl
; 54     uint8_t count = c->count;
	ld a, (hl)
	ld (__s_getcard + 2), a
; 55     if (count == 0)
	or a
	ret z
; 56         return;
; 57     count--;
	dec a
	ld (__s_getcard + 2), a
; 58     c->count = count;
	ld (hl), a
; 59     if (column_index != 0 && count >= 7)
	ld a, (__a_1_getcard)
	or a
	ret z
	ld a, (__s_getcard + 2)
	cp 7
	ret c
; 60         c->items[count - 1] &= ~CLOSED_CARD;
	ld hl, (__s_getcard + 2)
	ld h, 0
	dec hl
	ex hl, de
	ld hl, (__s_getcard + 0)
	inc hl
	add hl, de
	ld a, (hl)
	and 127
	ld (hl), a
	ret
moveanimation:
; 164  MoveAnimation(uint8_t from_column, uint8_t to_column, uint8_t start, uint8_t height) {
	ld (__a_4_moveanimation), a
; 165     static const int CELL_SIZE = 8;
; 166 
; 167     /* Предотвращение нарушения памяти. В реальности больше карт перетаскиваться быть не может. */
; 168     if (height - start > VALUES_COUNT)
	ld hl, (__a_3_moveanimation)
	ld h, 0
	ex hl, de
	ld hl, (__a_4_moveanimation)
	ld h, 0
	call __o_sub_16
	ld de, 14
	call __o_sub_16
	jp c, l_160
; 169         height = start + VALUES_COUNT;
	ld a, (__a_3_moveanimation)
	add 13
	ld (__a_4_moveanimation), a
l_160:
; 170     const uint8_t image_height = IMAGE_CARD_BACK_HEIGHT + (height - start - 1) * BIG_CARD_STEP;
	ld a, (__a_4_moveanimation)
	ld hl, __a_3_moveanimation
	sub (hl)
	dec a
	add a
	add a
	add a
	add 48
	ld (__s_moveanimation + 0), a
; 171 
; 172     struct ui_column *c = &ui_columns[from_column];
	ld hl, (__a_1_moveanimation)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	ld de, ui_columns
	add hl, de
	ld (__s_moveanimation + 1), hl
; 173     uint8_t x0 = c->x;
	ld a, (hl)
	ld (__s_moveanimation + 3), a
; 174     uint8_t y0 = c->y;
	inc hl
	ld a, (hl)
	ld (__s_moveanimation + 4), a
; 175     if (from_column >= 7)
	ld a, (__a_1_moveanimation)
	cp 7
	jp c, l_162
; 176         y0 += BIG_CARD_STEP * start;
	ld a, (__a_3_moveanimation)
	add a
	add a
	add a
	ld hl, __s_moveanimation + 4
	add (hl)
	ld (__s_moveanimation + 4), a
l_162:
; 177 
; 178     c = &ui_columns[to_column];
	ld hl, (__a_2_moveanimation)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	ld de, ui_columns
	add hl, de
	ld (__s_moveanimation + 1), hl
; 179     uint8_t x1 = c->x;
	ld a, (hl)
	ld (__s_moveanimation + 5), a
; 180     uint8_t y1 = c->cursor_y - IMAGE_CARD_BACK_HEIGHT;
	inc hl
	inc hl
	ld a, (hl)
	add 208
	ld (__s_moveanimation + 6), a
; 181     if (to_column >= 7 && columns[to_column].count > 0)
	ld a, (__a_2_moveanimation)
	cp 7
	jp c, l_164
	ld hl, (__a_2_moveanimation)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, columns
	add hl, de
	ld a, (hl)
	or a
	jp z, l_164
; 182         y1 += CELL_SIZE;
	ld a, (__s_moveanimation + 6)
	add 8
	ld (__s_moveanimation + 6), a
l_164:
; 183 
; 184     /* Предотвращение перелета */
; 185     if (x1 < x0)
	ld a, (__s_moveanimation + 5)
	ld hl, __s_moveanimation + 3
	cp (hl)
	jp nc, l_166
; 186         if (x1 % CELL_SIZE != 0)
	ld hl, (__s_moveanimation + 5)
	ld h, 0
	ld de, 8
	call __o_mod_u16
	ld a, h
	or l
	jp z, l_168
; 187             x1 += CELL_SIZE;
	ld a, (__s_moveanimation + 5)
	add 8
	ld (__s_moveanimation + 5), a
l_168:
l_166:
; 188 
; 189     /* Предотвращение вылета за границу экрана */
; 190     uint8_t max_y = SCREEN_HEIGHT - image_height;
	xor a
	ld hl, __s_moveanimation + 0
	sub (hl)
	ld (__s_moveanimation + 7), a
; 191     if (y0 > max_y)
	ld hl, __s_moveanimation + 4
	cp (hl)
	jp nc, l_170
; 192         y0 = max_y;
	ld (__s_moveanimation + 4), a
l_170:
; 193     if (y1 > max_y)
	ld a, (__s_moveanimation + 7)
	ld hl, __s_moveanimation + 6
	cp (hl)
	jp nc, l_172
; 194         y1 = max_y;
	ld (__s_moveanimation + 6), a
l_172:
; 195 
; 196     /* Смещение целой части */
; 197     static const int FIXED_POINT = 8;
; 198 
; 199     /* Вычисление вектора */
; 200     int16_t dx = abs(x1 - x0);
	ld hl, (__s_moveanimation + 3)
	ld h, 0
	ex hl, de
	ld hl, (__s_moveanimation + 5)
	ld h, 0
	call __o_sub_16
	call abs
	ld (__s_moveanimation + 8), hl
; 201     int16_t dy = abs(y1 - y0);
	ld hl, (__s_moveanimation + 4)
	ld h, 0
	ex hl, de
	ld hl, (__s_moveanimation + 6)
	ld h, 0
	call __o_sub_16
	call abs
	ld (__s_moveanimation + 10), hl
; 202     uint8_t step_count = max_u8(dx, dy) / CELL_SIZE;
	ld a, (__s_moveanimation + 8)
	ld (__a_1_max_u8), a
	ld a, (__s_moveanimation + 10)
	call max_u8
	ld l, a
	ld h, 0
	ld de, 3
	call __o_shr_u16
	ld a, l
	ld (__s_moveanimation + 12), a
; 203     if (step_count == 0)
	or a
	ret z
; 204         return;
; 205     dx = ((dx << FIXED_POINT) + step_count / 2) / step_count;
	ld hl, (__s_moveanimation + 12)
	ld h, 0
	ld de, 1
	call __o_shr_u16
	ex hl, de
	ld hl, (__s_moveanimation + 8)
	ld h, l
	ld l, 0
	add hl, de
	ex hl, de
	ld hl, (__s_moveanimation + 12)
	ld h, 0
	ex hl, de
	call __o_div_u16
	ld (__s_moveanimation + 8), hl
; 206     dy = ((dy << FIXED_POINT) + step_count / 2) / step_count;
	ld hl, (__s_moveanimation + 12)
	ld h, 0
	ld de, 1
	call __o_shr_u16
	ex hl, de
	ld hl, (__s_moveanimation + 10)
	ld h, l
	ld l, 0
	add hl, de
	ex hl, de
	ld hl, (__s_moveanimation + 12)
	ld h, 0
	ex hl, de
	call __o_div_u16
	ld (__s_moveanimation + 10), hl
; 207     if (x1 < x0)
	ld a, (__s_moveanimation + 5)
	ld hl, __s_moveanimation + 3
	cp (hl)
	jp nc, l_176
; 208         dx = -dx;
	ld hl, (__s_moveanimation + 8)
	call __o_minus_16
	ld (__s_moveanimation + 8), hl
l_176:
; 209     if (y1 < y0)
	ld a, (__s_moveanimation + 6)
	ld hl, __s_moveanimation + 4
	cp (hl)
	jp nc, l_178
; 210         dy = -dy;
	ld hl, (__s_moveanimation + 10)
	call __o_minus_16
	ld (__s_moveanimation + 10), hl
l_178:
; 211 
; 212     /* Подготовка изображения перетаскиваемой стопки карт */
; 213     static const uint8_t ANI_MAX_HEIGHT = IMAGE_CARD_BACK_HEIGHT + (VALUES_COUNT - 1) * BIG_CARD_STEP;
; 214     static const unsigned ANI_BPL = IMAGE_CARD_BACK_WIDTH / 8 * 2;
; 215     uint8_t aniImage[ANI_BPL * ANI_MAX_HEIGHT + 1];
; 216     aniImage[0] = IMAGE_CARD_BACK_WIDTH / 16;
	ld a, 2
	ld ((__s_moveanimation + 13) + (0)), a
; 217     uint8_t i;
; 218     uint8_t *dd = aniImage + 1;
	ld hl, (__s_moveanimation + 13) + (1)
	ld (__s_moveanimation + 1167), hl
; 219     uint8_t *cc = &columns[from_column].items[start];
	ld hl, (__a_1_moveanimation)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, columns
	add hl, de
	inc hl
	ex hl, de
	ld hl, (__a_3_moveanimation)
	ld h, 0
	add hl, de
	ld (__s_moveanimation + 1169), hl
; 220     for (i = start; i + 1 < height; i++) {
	ld a, (__a_3_moveanimation)
	ld (__s_moveanimation + 1166), a
l_180:
	ld hl, (__a_4_moveanimation)
	ld h, 0
	ex hl, de
	ld hl, (__s_moveanimation + 1166)
	ld h, 0
	inc hl
	call __o_sub_16
	jp nc, l_182
; 221         CopyImage(IMAGE_CARD_BACK_WIDTH, BIG_CARD_STEP, dd, GetCardImage(*cc) + 1);
	ld a, 32
	ld (__a_1_copyimage), a
	ld a, 8
	ld (__a_2_copyimage), a
	ld hl, (__s_moveanimation + 1167)
	ld (__a_3_copyimage), hl
	ld hl, (__s_moveanimation + 1169)
	ld a, (hl)
	call getcardimage
	inc hl
	call copyimage
; 222         dd += BIG_CARD_STEP * ANI_BPL;
	ld hl, (__s_moveanimation + 1167)
	ld de, 64
	add hl, de
	ld (__s_moveanimation + 1167), hl
; 223         cc++;
	ld hl, (__s_moveanimation + 1169)
	inc hl
	ld (__s_moveanimation + 1169), hl
l_181:
	ld a, (__s_moveanimation + 1166)
	inc a
	ld (__s_moveanimation + 1166), a
	jp l_180
l_182:
; 224     }
; 225     CopyImage(IMAGE_CARD_BACK_WIDTH, IMAGE_CARD_BACK_HEIGHT, dd, GetCardImage(*cc) + 1);
	ld a, 32
	ld (__a_1_copyimage), a
	ld a, 48
	ld (__a_2_copyimage), a
	ld hl, (__s_moveanimation + 1167)
	ld (__a_3_copyimage), hl
	ld hl, (__s_moveanimation + 1169)
	ld a, (hl)
	call getcardimage
	inc hl
	call copyimage
; 226 
; 227     /* Сохранения части экрана под перетаскиваемой колодой */
; 228     uint8_t px = x0;
	ld a, (__s_moveanimation + 3)
	ld (__s_moveanimation + 1171), a
; 229     uint8_t py = y0;
	ld a, (__s_moveanimation + 4)
	ld (__s_moveanimation + 1172), a
; 230     uint8_t aniBack[sizeof(aniImage)];
; 231     uint8_t aniBack2[sizeof(aniImage)];
; 232     BeginDrawAnimation(x0, y0, IMAGE_CARD_BACK_WIDTH / 16, image_height, aniBack, aniBack2);
	ld a, (__s_moveanimation + 3)
	ld (__a_1_begindrawanimation), a
	ld a, (__s_moveanimation + 4)
	ld (__a_2_begindrawanimation), a
	ld a, 2
	ld (__a_3_begindrawanimation), a
	ld a, (__s_moveanimation + 0)
	ld (__a_4_begindrawanimation), a
	ld hl, __s_moveanimation + 1173
	ld (__a_5_begindrawanimation), hl
	ld hl, __s_moveanimation + 2326
	call begindrawanimation
; 233 
; 234     uint16_t x = x0 << FIXED_POINT;
	ld hl, (__s_moveanimation + 3)
	ld h, 0
	ld h, l
	ld l, 0
	ld (__s_moveanimation + 3479), hl
; 235     uint16_t y = y0 << FIXED_POINT;
	ld hl, (__s_moveanimation + 4)
	ld h, 0
	ld h, l
	ld l, 0
	ld (__s_moveanimation + 3481), hl
l_183:
; 236     while (step_count != 0) {
	ld a, (__s_moveanimation + 12)
	or a
	jp z, l_184
; 237         step_count--;
	dec a
	ld (__s_moveanimation + 12), a
; 238 
; 239         x += dx;
	ld hl, (__s_moveanimation + 8)
	ex hl, de
	ld hl, (__s_moveanimation + 3479)
	add hl, de
	ld (__s_moveanimation + 3479), hl
; 240         y += dy;
	ld hl, (__s_moveanimation + 10)
	ex hl, de
	ld hl, (__s_moveanimation + 3481)
	add hl, de
	ld (__s_moveanimation + 3481), hl
; 241 
; 242         /* Получение целой части координат */
; 243         uint8_t gx = (x + (1 << (FIXED_POINT - 1))) >> FIXED_POINT;
	ld hl, (__s_moveanimation + 3479)
	ld de, 128
	add hl, de
	ld de, 8
	call __o_shr_u16
	ld a, l
	ld (__s_moveanimation + 3483), a
; 244         uint8_t gy = (y + (1 << (FIXED_POINT - 1))) >> FIXED_POINT;
	ld hl, (__s_moveanimation + 3481)
	ld de, 128
	add hl, de
	ld de, 8
	call __o_shr_u16
	ld a, l
	ld (__s_moveanimation + 3484), a
; 245 
; 246         DrawAnimation(gx, gy, aniImage);
	ld a, (__s_moveanimation + 3483)
	ld (__a_1_drawanimation), a
	ld a, (__s_moveanimation + 3484)
	ld (__a_2_drawanimation), a
	ld hl, __s_moveanimation + 13
	call drawanimation
; 247 
; 248         px = gx;
	ld a, (__s_moveanimation + 3483)
	ld (__s_moveanimation + 1171), a
; 249         py = gy;
	ld a, (__s_moveanimation + 3484)
	ld (__s_moveanimation + 1172), a
	jp l_183
l_184:
; 250     }
; 251 
; 252     EndDrawAnimation();
	jp enddrawanimation
gettopcardimage:
; 62  uint8_t *GetTopCardImage(uint8_t column_index) {
	ld (__a_1_gettopcardimage), a
; 63     struct column *c = &columns[column_index];
	ld hl, (__a_1_gettopcardimage)
	ld h, 0
	ld d, h
	ld e, l
	add hl, hl
	add hl, de
	add hl, hl
	add hl, hl
	add hl, hl
	add hl, de
	ld de, columns
	add hl, de
	ld (__s_gettopcardimage + 0), hl
; 64     if (c->count == 0)
	ld a, (hl)
	or a
	jp nz, l_185
; 65         return image_rect;
	ld hl, image_rect
	ret
l_185:
; 66     return GetCardImage(c->items[c->count - 1]);
	ld l, (hl)
	ld h, 0
	dec hl
	ex hl, de
	ld hl, (__s_gettopcardimage + 0)
	inc hl
	add hl, de
	ld a, (hl)
	jp getcardimage
abs:
; 20  abs(int x)
	ld (__a_1_abs), hl
; 21 {
; 22     return x >= 0 ? x : -x;
	ld de, 0
	call __o_sub_16
	jp m, l_187
	ld hl, (__a_1_abs)
	ret
l_187:
	ld hl, (__a_1_abs)
	jp __o_minus_16
max_u8:
; 160  uint8_t max_u8(uint8_t a, uint8_t b) {
	ld (__a_2_max_u8), a
; 161     return a > b ? a : b;
	ld hl, __a_1_max_u8
	cp (hl)
	jp nc, l_189
	ld hl, (__a_1_max_u8)
	ld h, 0
	jp l_190
l_189:
	ld hl, (__a_2_max_u8)
	ld h, 0
l_190:
	ld a, l
	ret
copyimage:
; 509  CopyImage(uint8_t w8, uint8_t h, void *dest, const void *src) {

__a_4_copyimage = __a_4_copyimage
        ex   hl, de ; src

__a_3_copyimage = $ + 1
        ld   hl, 0 ; dest

__a_2_copyimage = $ + 1
        ld   b, 0 ; height
copyimage_l1:
__a_1_copyimage = $ + 1
          ld   c, 0 ; width
copyimage_l0:
            ld   a, (de)
            inc  de
            ld   (hl), a
            inc  hl
            ld   a, (de)
            inc  de
            ld   (hl), a
            inc  hl
            dec  c
          jp   nz, copyimage_l0
          dec  b
        jp   nz, copyimage_l1
    
	ret
begindrawanimation:
; 34  BeginDrawAnimation(uint8_t x, uint8_t y, uint8_t w16, uint8_t h, void *back, void *back2)
	ld (__a_6_begindrawanimation), hl
; 35 {
; 36     GetImage8(x, y, w16, h, back);
	ld a, (__a_1_begindrawanimation)
	ld (__a_1_getimage8), a
	ld a, (__a_2_begindrawanimation)
	ld (__a_2_getimage8), a
	ld a, (__a_3_begindrawanimation)
	ld (__a_3_getimage8), a
	ld a, (__a_4_begindrawanimation)
	ld (__a_4_getimage8), a
	ld hl, (__a_5_begindrawanimation)
	call getimage8
; 37     *(uint8_t*)back2 = *(uint8_t*)back;
	ld hl, (__a_5_begindrawanimation)
	ld a, (hl)
	ld hl, (__a_6_begindrawanimation)
	ld (hl), a
; 38     drawanimation_restore = (uint8_t*)back + 1;
	ld hl, (__a_5_begindrawanimation)
	inc hl
	ld (drawanimation_restore), hl
; 39     drawanimation_save = (uint8_t*)back2 + 1;
	ld hl, (__a_6_begindrawanimation)
	inc hl
	ld (drawanimation_save), hl
; 40     drawanimation_width8 = w16 * 2;
	ld a, (__a_3_begindrawanimation)
	add a
	ld (drawanimation_width8), a
; 41     drawanimation_height = h;
	ld a, (__a_4_begindrawanimation)
	ld (drawanimation_height), a
; 42     drawanimation_x = x;
	ld a, (__a_1_begindrawanimation)
	ld (drawanimation_x), a
; 43     drawanimation_y = y;
	ld a, (__a_2_begindrawanimation)
	ld (drawanimation_y), a
	ret
drawanimation:
; 62  DrawAnimation(uint8_t x, uint8_t y, void *image) {
	ld (__a_3_drawanimation), hl
; 63     drawanimation_dy = y - drawanimation_y;
	ld a, (drawanimation_y)
	ld d, a
	ld a, (__a_2_drawanimation)
	sub d
	ld (drawanimation_dy), a
; 64     drawanimation_h0 = abs(drawanimation_dy);
	call __o_i8_to_i16
	call abs
	ld a, l
	ld (drawanimation_h0), a
; 65     drawanimation_h1 = drawanimation_height - drawanimation_h0;
	ld a, (drawanimation_height)
	ld hl, drawanimation_h0
	sub (hl)
	ld (drawanimation_h1), a
; 66     drawanimation_dx = x / 8 - drawanimation_x / 8;
	ld hl, (drawanimation_x)
	ld h, 0
	ld de, 3
	call __o_shr_u16
	ld a, l
	push af
	ld hl, (__a_1_drawanimation)
	ld h, 0
	ld de, 3
	call __o_shr_u16
	ld a, l
	pop de
	sub d
	ld (drawanimation_dx), a
; 67     drawanimation_w0 = abs(drawanimation_dx);
	call __o_i8_to_i16
	call abs
	ld a, l
	ld (drawanimation_w0), a
; 68     drawanimation_w1 = drawanimation_width8 - drawanimation_w0;
	ld a, (drawanimation_width8)
	ld hl, drawanimation_w0
	sub (hl)
	ld (drawanimation_w1), a

        ; Загрузка в BC и DE адресов буферов и обмен буферов местами
drawanimation_restore = $ + 1
        ld   hl, 0
drawanimation_save = $ + 1
        ld   de, 0
        ld   (drawanimation_save), hl
        ex   hl, de
        ld   (drawanimation_restore), hl
        ld   bc, hl

        ; Загрузка в DE` указателя на изображение
        ld   hl, (__a_3_drawanimation)
        inc  hl
        push hl

        ; Подключение видеопамяти
        ld   a, 10h
        out  (0C1h), a

        ; Продолжение зависит от направления движения
drawanimation_dx = $ + 1
        ld   a, 0
        or   a
        jp   p, DrawAnimation_Right
drawanimation_dy = $ + 1
        ld   a, 0
        or   a
        jp   p, DrawAnimation_LeftDown

DrawAnimation_LeftUp:
        ; *** Влево-вверх ***
        ; Расчет в HL адреса в видеопамяти (NEW X, NEW Y)
        ld   a, (__a_1_drawanimation)
        rrca
        rrca
        and  03Eh
        or   0C0h
        ld   hl, (__a_2_drawanimation)
        ld   h, a

        ex   hl, de
        ex   (sp), hl
        ex   hl, de

        call DrawAnimation_5

        ex   hl, de
        ex   (sp), hl
        ex   hl, de

        jp   DrawAnimation_Left

;----------------------------------------------------------------------------

DrawAnimation_LeftDown:
        ; *** Влево-вниз ***
        ; Расчет в HL адреса в видеопамяти (OLD_X, OLD_Y)
        ld   a, (drawanimation_x)
        rrca
        rrca
        and  03Eh
        or   0C0h
        ld   hl, (drawanimation_y)
        ld   h, a

        call DrawAnimation_1

        ld   a, (drawanimation_w0)
        add  a
        cpl
        inc  a
        add  h
        ld   h, a

        jp   DrawAnimation_Left

;----------------------------------------------------------------------------

DrawAnimation_Right:
        ; Выбор направления движения вверх или вниз
        ld   a, (drawanimation_dy)
        or   a
        jp   p, DrawAnimation_RightDown

        ; *** Вправо-вверх ***
DrawAnimation_RightUp:
        ; Расчет в HL адреса в видеопамяти
        ld   a, (__a_1_drawanimation)
        rrca
        rrca
        and  03Eh
        or   0C0h
        ld   hl, (__a_2_drawanimation)
        ld   h, a

        ex   hl, de
        ex   (sp), hl
        ex   hl, de

        call DrawAnimation_5

        ex   hl, de
        ex   (sp), hl
        ex   hl, de

        ld   a, (drawanimation_w0)
        cpl
        inc  a
        add  a
        add  h
        ld   h, a

        jp   DrawAnimation_Right2

;----------------------------------------------------------------------------

        ; *** Вправо-вниз ***
DrawAnimation_RightDown:
        ; Расчет в HL адреса в видеопамяти
drawanimation_x = $ + 1
        ld   a, 0
        rrca
        rrca
        and  03Eh
        or   0C0h
        ld   h, a
drawanimation_y = $ + 1
        ld   l, 0

        call DrawAnimation_1

DrawAnimation_Right2:
        ; Цикл строк H1
drawanimation_h1 = $ + 1
        ld   a, 0
DrawAnimation_Right2_RowLoop:
            ld  (DrawAnimation_Right2_A), a
            ld  (DrawAnimation_Right2_HL), hl

            ; Восстановление изображения слева. Шаг 2) W1 DE->HL.
drawanimation_w0 = $ + 1
            ld   a, 0
            or   a
            call nz, DrawAnimation_2

            ; Сохранение изображения в центре. Шаг 3.1) W2 DE->BC.
drawanimation_w1 = $ + 1
            ld   a, 0
            push hl
            ld   l, a
DrawAnimation_Right2_31:
                ld   a, (de)
                ld   (bc), a
                inc  de
                inc  bc
                ld   a, (de)
                ld   (bc), a
                inc  de
                inc  bc
                dec  l
            jp   nz, DrawAnimation_Right2_31
            pop  hl

            ; Вывод изображения в центре. Шаг 3.2) W2 DE`->HL.
            ex   hl, de
            ex   (sp), hl
            ex   hl, de
            ld   a, (drawanimation_w1)
            push bc
            ld   c, a
DrawAnimation_r3:
                ld   a, (de)
                ld   (hl), a
                inc  de
                inc  h
                ld   a, (de)
                ld   (hl), a
                inc  de
                inc  h
                dec  c
            jp   nz, DrawAnimation_r3
            pop  bc

            ; Сохранение и вывод изобаржения справа. Шаг 4) W1 HL->BC, DE`->HL.
            ld   a, (drawanimation_w0)
            or   a
            call nz, DrawAnimation_4

            ex   hl, de
            ex   (sp), hl
            ex   hl, de

            ; Конец цикла строк
DrawAnimation_Right2_A = $ + 1
            ld  a, 0
DrawAnimation_Right2_HL = $ + 1
            ld  hl, 0
            inc  l
            dec  a
        jp   nz, DrawAnimation_Right2_RowLoop

        ; Продолжение зависит от направления движения вверх или вниз
        ld   a, (drawanimation_dy)
        or   a
        jp   p, DrawAnimation_RightDown2

        ; Вправо-вверх
        call DrawAnimation_1
        jp   DrawAnimation_Exit

DrawAnimation_RightDown2:
        ; Вправо-вниз
        ld   a, (drawanimation_w0)
        add  a
        add  h
        ld   h, a
        ex   hl, de
        ex   (sp), hl
        ex   hl, de
        call DrawAnimation_5
        jp   DrawAnimation_Exit

;----------------------------------------------------------------------------
; Шаг 1. Восстановление фона. DE->HL.

DrawAnimation_1:
        push bc
drawanimation_h0 = $ + 1
        ld   b, 0
        dec  b
        inc  b
        jp   z, DrawAnimation_17
DrawAnimation_1_RowsLoop:
          push hl
drawanimation_width8 = $ + 1
          ld   c, 0
DrawAnimation_1_BytesLoop:
            ld   a, (de)
            ld   (hl), a
            inc  de
            inc  h
            ld   a, (de)
            ld   (hl), a
            inc  de
            inc  h
            dec  c
          jp   nz, DrawAnimation_1_BytesLoop
          pop  hl
          inc  l
          dec  b
        jp   nz, DrawAnimation_1_RowsLoop
DrawAnimation_17:
        pop  bc
        ret

;----------------------------------------------------------------------------
; Шаг 5. Сохранение фона и вывод изобаржения. HL->BC, DE`->HL.

DrawAnimation_5:
        ld   a, (drawanimation_h0)
        or   a
        ret  z
DrawAnimation_5_RowsLoop:
            push af
            push hl
            ld   a, (drawanimation_width8)
DrawAnimation_5_BytesLoop:
                push af
                ld   a, (hl)
                ld   (bc), a
                ld   a, (de)
                ld   (hl), a
                inc  bc
                inc  de
                inc  h
                ld   a, (hl)
                ld   (bc), a
                ld   a, (de)
                ld   (hl), a
                inc  bc
                inc  de
                inc  h
                pop  af
                dec  a
            jp   nz, DrawAnimation_5_BytesLoop
            pop  hl
            pop  af
            inc  l
            dec  a
        jp   nz, DrawAnimation_5_RowsLoop
        ret

;----------------------------------------------------------------------------
; Шаг 2. Восстановление фона. DE->HL.

DrawAnimation_2:
        push bc
        ld   c, a
DrawAnimation_2_Loop:
            ld   a, (de)
            ld   (hl), a
            inc  h
            inc  de
            ld   a, (de)
            ld   (hl), a
            inc  h
            inc  de
            dec  c
        jp   nz, DrawAnimation_2_Loop
        pop  bc
        ret

;----------------------------------------------------------------------------
; Шаг 4. Сохранение фона и вывод изобаржения. HL->BC, DE`->HL.

DrawAnimation_4:
            push af
            ld   a, (hl)
            ld   (bc), a
            ld   a, (de)
            ld   (hl), a
            inc  bc
            inc  de
            inc  h
            ld   a, (hl)
            ld   (bc), a
            ld   a, (de)
            ld   (hl), a
            inc  bc
            inc  de
            inc  h
            pop  af
            dec  a
        jp   nz, DrawAnimation_4
        ret

;----------------------------------------------------------------------------
; Перемещение изображения влево

DrawAnimation_Left:
            ld   a, (drawanimation_h1)
DrawAnimation_Left_RowsLoop:
            ld  (DrawAnimation_Left_A), a
            ld  (DrawAnimation_Left_HL), hl

            ex   hl, de
            ex   (sp), hl
            ex   hl, de

            ; Сохранение и вывод изобаржения слева. Шаг 4) W1 HL->BC, DE`->HL.
            ld   a, (drawanimation_w0)
            or   a
            call nz, DrawAnimation_4

            ; Вывод изображения в центре. Шаг 3.1) W2 DE`->HL.
            ld   a, (drawanimation_w1)
            push bc
            ld   c, a
DrawAnimation_q3:
                ld   a, (de)
                ld   (hl), a
                inc  de
                inc  h
                ld   a, (de)
                ld   (hl), a
                inc  de
                inc  h
                dec  c
            jp   nz, DrawAnimation_q3
            pop  bc

            ex   hl, de
            ex   (sp), hl
            ex   hl, de

            ; Сохранение изображения в центре. Шаг 3.2) W2 DE->BC.
            ld   a, (drawanimation_w1)
            push hl
            ld   l, a
DrawAnimation_q2:
                ld   a, (de)
                ld   (bc), a
                inc  de
                inc  bc
                ld   a, (de)
                ld   (bc), a
                inc  de
                inc  bc
                dec  l
            jp   nz, DrawAnimation_q2
            pop  hl

            ; Восстановление изображения справа. Шаг 2) W1 DE->HL.
            ld   a, (drawanimation_w0)
            or   a
            call nz, DrawAnimation_2

            ; Конец цикла строк
DrawAnimation_Left_A = $ + 1
            ld   a, 0
DrawAnimation_Left_HL = $ + 1
            ld   hl, 0
            inc  l
            dec  a
        jp   nz, DrawAnimation_Left_RowsLoop

        ; Продолжение зависит от направления движения вверх или вниз
        ld   a, (drawanimation_dy)
        or   a
        jp   p, DrawAnimation_LeftDown2

        ; Влево-вверх
        ld   a, (drawanimation_w0)
        add  a
        add  h
        ld   h, a
        call DrawAnimation_1
        jp   DrawAnimation_Exit

DrawAnimation_LeftDown2:
        ; Влево-вниз
        ex   hl, de
        ex   (sp), hl
        ex   hl, de
        call DrawAnimation_5

DrawAnimation_Exit:
        ; Отключение видеопамяти
        xor  a
        out  (0C1h), a

        ; Удаление из стека DE`
        pop  hl
    
; 69 
; 70     asm {
; 71         ; Загрузка в BC и DE адресов буферов и обмен буферов местами
; 72 drawanimation_restore = $ + 1
; 73         ld   hl, 0
; 74 drawanimation_save = $ + 1
; 75         ld   de, 0
; 76         ld   (drawanimation_save), hl
; 77         ex   hl, de
; 78         ld   (drawanimation_restore), hl
; 79         ld   bc, hl
; 80 
; 81         ; Загрузка в DE` указателя на изображение
; 82         ld   hl, (__a_3_drawanimation)
; 83         inc  hl
; 84         push hl
; 85 
; 86         ; Подключение видеопамяти
; 87         ld   a, 10h
; 88         out  (0C1h), a
; 89 
; 90         ; Продолжение зависит от направления движения
; 91 drawanimation_dx = $ + 1
; 92         ld   a, 0
; 93         or   a
; 94         jp   p, DrawAnimation_Right
; 95 drawanimation_dy = $ + 1
; 96         ld   a, 0
; 97         or   a
; 98         jp   p, DrawAnimation_LeftDown
; 99 
; 100 DrawAnimation_LeftUp:
; 101         ; *** Влево-вверх ***
; 102         ; Расчет в HL адреса в видеопамяти (NEW X, NEW Y)
; 103         ld   a, (__a_1_drawanimation)
; 104         rrca
; 105         rrca
; 106         and  03Eh
; 107         or   0C0h
; 108         ld   hl, (__a_2_drawanimation)
; 109         ld   h, a
; 110 
; 111         ex   hl, de
; 112         ex   (sp), hl
; 113         ex   hl, de
; 114 
; 115         call DrawAnimation_5
; 116 
; 117         ex   hl, de
; 118         ex   (sp), hl
; 119         ex   hl, de
; 120 
; 121         jp   DrawAnimation_Left
; 122 
; 123 ;----------------------------------------------------------------------------
; 124 
; 125 DrawAnimation_LeftDown:
; 126         ; *** Влево-вниз ***
; 127         ; Расчет в HL адреса в видеопамяти (OLD_X, OLD_Y)
; 128         ld   a, (drawanimation_x)
; 129         rrca
; 130         rrca
; 131         and  03Eh
; 132         or   0C0h
; 133         ld   hl, (drawanimation_y)
; 134         ld   h, a
; 135 
; 136         call DrawAnimation_1
; 137 
; 138         ld   a, (drawanimation_w0)
; 139         add  a
; 140         cpl
; 141         inc  a
; 142         add  h
; 143         ld   h, a
; 144 
; 145         jp   DrawAnimation_Left
; 146 
; 147 ;----------------------------------------------------------------------------
; 148 
; 149 DrawAnimation_Right:
; 150         ; Выбор направления движения вверх или вниз
; 151         ld   a, (drawanimation_dy)
; 152         or   a
; 153         jp   p, DrawAnimation_RightDown
; 154 
; 155         ; *** Вправо-вверх ***
; 156 DrawAnimation_RightUp:
; 157         ; Расчет в HL адреса в видеопамяти
; 158         ld   a, (__a_1_drawanimation)
; 159         rrca
; 160         rrca
; 161         and  03Eh
; 162         or   0C0h
; 163         ld   hl, (__a_2_drawanimation)
; 164         ld   h, a
; 165 
; 166         ex   hl, de
; 167         ex   (sp), hl
; 168         ex   hl, de
; 169 
; 170         call DrawAnimation_5
; 171 
; 172         ex   hl, de
; 173         ex   (sp), hl
; 174         ex   hl, de
; 175 
; 176         ld   a, (drawanimation_w0)
; 177         cpl
; 178         inc  a
; 179         add  a
; 180         add  h
; 181         ld   h, a
; 182 
; 183         jp   DrawAnimation_Right2
; 184 
; 185 ;----------------------------------------------------------------------------
; 186 
; 187         ; *** Вправо-вниз ***
; 188 DrawAnimation_RightDown:
; 189         ; Расчет в HL адреса в видеопамяти
; 190 drawanimation_x = $ + 1
; 191         ld   a, 0
; 192         rrca
; 193         rrca
; 194         and  03Eh
; 195         or   0C0h
; 196         ld   h, a
; 197 drawanimation_y = $ + 1
; 198         ld   l, 0
; 199 
; 200         call DrawAnimation_1
; 201 
; 202 DrawAnimation_Right2:
; 203         ; Цикл строк H1
; 204 drawanimation_h1 = $ + 1
; 205         ld   a, 0
; 206 DrawAnimation_Right2_RowLoop:
; 207             ld  (DrawAnimation_Right2_A), a
; 208             ld  (DrawAnimation_Right2_HL), hl
; 209 
; 210             ; Восстановление изображения слева. Шаг 2) W1 DE->HL.
; 211 drawanimation_w0 = $ + 1
; 212             ld   a, 0
; 213             or   a
; 214             call nz, DrawAnimation_2
; 215 
; 216             ; Сохранение изображения в центре. Шаг 3.1) W2 DE->BC.
; 217 drawanimation_w1 = $ + 1
; 218             ld   a, 0
; 219             push hl
; 220             ld   l, a
; 221 DrawAnimation_Right2_31:
; 222                 ld   a, (de)
; 223                 ld   (bc), a
; 224                 inc  de
; 225                 inc  bc
; 226                 ld   a, (de)
; 227                 ld   (bc), a
; 228                 inc  de
; 229                 inc  bc
; 230                 dec  l
; 231             jp   nz, DrawAnimation_Right2_31
; 232             pop  hl
; 233 
; 234             ; Вывод изображения в центре. Шаг 3.2) W2 DE`->HL.
; 235             ex   hl, de
; 236             ex   (sp), hl
; 237             ex   hl, de
; 238             ld   a, (drawanimation_w1)
; 239             push bc
; 240             ld   c, a
; 241 DrawAnimation_r3:
; 242                 ld   a, (de)
; 243                 ld   (hl), a
; 244                 inc  de
; 245                 inc  h
; 246                 ld   a, (de)
; 247                 ld   (hl), a
; 248                 inc  de
; 249                 inc  h
; 250                 dec  c
; 251             jp   nz, DrawAnimation_r3
; 252             pop  bc
; 253 
; 254             ; Сохранение и вывод изобаржения справа. Шаг 4) W1 HL->BC, DE`->HL.
; 255             ld   a, (drawanimation_w0)
; 256             or   a
; 257             call nz, DrawAnimation_4
; 258 
; 259             ex   hl, de
; 260             ex   (sp), hl
; 261             ex   hl, de
; 262 
; 263             ; Конец цикла строк
; 264 DrawAnimation_Right2_A = $ + 1
; 265             ld  a, 0
; 266 DrawAnimation_Right2_HL = $ + 1
; 267             ld  hl, 0
; 268             inc  l
; 269             dec  a
; 270         jp   nz, DrawAnimation_Right2_RowLoop
; 271 
; 272         ; Продолжение зависит от направления движения вверх или вниз
; 273         ld   a, (drawanimation_dy)
; 274         or   a
; 275         jp   p, DrawAnimation_RightDown2
; 276 
; 277         ; Вправо-вверх
; 278         call DrawAnimation_1
; 279         jp   DrawAnimation_Exit
; 280 
; 281 DrawAnimation_RightDown2:
; 282         ; Вправо-вниз
; 283         ld   a, (drawanimation_w0)
; 284         add  a
; 285         add  h
; 286         ld   h, a
; 287         ex   hl, de
; 288         ex   (sp), hl
; 289         ex   hl, de
; 290         call DrawAnimation_5
; 291         jp   DrawAnimation_Exit
; 292 
; 293 ;----------------------------------------------------------------------------
; 294 ; Шаг 1. Восстановление фона. DE->HL.
; 295 
; 296 DrawAnimation_1:
; 297         push bc
; 298 drawanimation_h0 = $ + 1
; 299         ld   b, 0
; 300         dec  b
; 301         inc  b
; 302         jp   z, DrawAnimation_17
; 303 DrawAnimation_1_RowsLoop:
; 304           push hl
; 305 drawanimation_width8 = $ + 1
; 306           ld   c, 0
; 307 DrawAnimation_1_BytesLoop:
; 308             ld   a, (de)
; 309             ld   (hl), a
; 310             inc  de
; 311             inc  h
; 312             ld   a, (de)
; 313             ld   (hl), a
; 314             inc  de
; 315             inc  h
; 316             dec  c
; 317           jp   nz, DrawAnimation_1_BytesLoop
; 318           pop  hl
; 319           inc  l
; 320           dec  b
; 321         jp   nz, DrawAnimation_1_RowsLoop
; 322 DrawAnimation_17:
; 323         pop  bc
; 324         ret
; 325 
; 326 ;----------------------------------------------------------------------------
; 327 ; Шаг 5. Сохранение фона и вывод изобаржения. HL->BC, DE`->HL.
; 328 
; 329 DrawAnimation_5:
; 330         ld   a, (drawanimation_h0)
; 331         or   a
; 332         ret  z
; 333 DrawAnimation_5_RowsLoop:
; 334             push af
; 335             push hl
; 336             ld   a, (drawanimation_width8)
; 337 DrawAnimation_5_BytesLoop:
; 338                 push af
; 339                 ld   a, (hl)
; 340                 ld   (bc), a
; 341                 ld   a, (de)
; 342                 ld   (hl), a
; 343                 inc  bc
; 344                 inc  de
; 345                 inc  h
; 346                 ld   a, (hl)
; 347                 ld   (bc), a
; 348                 ld   a, (de)
; 349                 ld   (hl), a
; 350                 inc  bc
; 351                 inc  de
; 352                 inc  h
; 353                 pop  af
; 354                 dec  a
; 355             jp   nz, DrawAnimation_5_BytesLoop
; 356             pop  hl
; 357             pop  af
; 358             inc  l
; 359             dec  a
; 360         jp   nz, DrawAnimation_5_RowsLoop
; 361         ret
; 362 
; 363 ;----------------------------------------------------------------------------
; 364 ; Шаг 2. Восстановление фона. DE->HL.
; 365 
; 366 DrawAnimation_2:
; 367         push bc
; 368         ld   c, a
; 369 DrawAnimation_2_Loop:
; 370             ld   a, (de)
; 371             ld   (hl), a
; 372             inc  h
; 373             inc  de
; 374             ld   a, (de)
; 375             ld   (hl), a
; 376             inc  h
; 377             inc  de
; 378             dec  c
; 379         jp   nz, DrawAnimation_2_Loop
; 380         pop  bc
; 381         ret
; 382 
; 383 ;----------------------------------------------------------------------------
; 384 ; Шаг 4. Сохранение фона и вывод изобаржения. HL->BC, DE`->HL.
; 385 
; 386 DrawAnimation_4:
; 387             push af
; 388             ld   a, (hl)
; 389             ld   (bc), a
; 390             ld   a, (de)
; 391             ld   (hl), a
; 392             inc  bc
; 393             inc  de
; 394             inc  h
; 395             ld   a, (hl)
; 396             ld   (bc), a
; 397             ld   a, (de)
; 398             ld   (hl), a
; 399             inc  bc
; 400             inc  de
; 401             inc  h
; 402             pop  af
; 403             dec  a
; 404         jp   nz, DrawAnimation_4
; 405         ret
; 406 
; 407 ;----------------------------------------------------------------------------
; 408 ; Перемещение изображения влево
; 409 
; 410 DrawAnimation_Left:
; 411             ld   a, (drawanimation_h1)
; 412 DrawAnimation_Left_RowsLoop:
; 413             ld  (DrawAnimation_Left_A), a
; 414             ld  (DrawAnimation_Left_HL), hl
; 415 
; 416             ex   hl, de
; 417             ex   (sp), hl
; 418             ex   hl, de
; 419 
; 420             ; Сохранение и вывод изобаржения слева. Шаг 4) W1 HL->BC, DE`->HL.
; 421             ld   a, (drawanimation_w0)
; 422             or   a
; 423             call nz, DrawAnimation_4
; 424 
; 425             ; Вывод изображения в центре. Шаг 3.1) W2 DE`->HL.
; 426             ld   a, (drawanimation_w1)
; 427             push bc
; 428             ld   c, a
; 429 DrawAnimation_q3:
; 430                 ld   a, (de)
; 431                 ld   (hl), a
; 432                 inc  de
; 433                 inc  h
; 434                 ld   a, (de)
; 435                 ld   (hl), a
; 436                 inc  de
; 437                 inc  h
; 438                 dec  c
; 439             jp   nz, DrawAnimation_q3
; 440             pop  bc
; 441 
; 442             ex   hl, de
; 443             ex   (sp), hl
; 444             ex   hl, de
; 445 
; 446             ; Сохранение изображения в центре. Шаг 3.2) W2 DE->BC.
; 447             ld   a, (drawanimation_w1)
; 448             push hl
; 449             ld   l, a
; 450 DrawAnimation_q2:
; 451                 ld   a, (de)
; 452                 ld   (bc), a
; 453                 inc  de
; 454                 inc  bc
; 455                 ld   a, (de)
; 456                 ld   (bc), a
; 457                 inc  de
; 458                 inc  bc
; 459                 dec  l
; 460             jp   nz, DrawAnimation_q2
; 461             pop  hl
; 462 
; 463             ; Восстановление изображения справа. Шаг 2) W1 DE->HL.
; 464             ld   a, (drawanimation_w0)
; 465             or   a
; 466             call nz, DrawAnimation_2
; 467 
; 468             ; Конец цикла строк
; 469 DrawAnimation_Left_A = $ + 1
; 470             ld   a, 0
; 471 DrawAnimation_Left_HL = $ + 1
; 472             ld   hl, 0
; 473             inc  l
; 474             dec  a
; 475         jp   nz, DrawAnimation_Left_RowsLoop
; 476 
; 477         ; Продолжение зависит от направления движения вверх или вниз
; 478         ld   a, (drawanimation_dy)
; 479         or   a
; 480         jp   p, DrawAnimation_LeftDown2
; 481 
; 482         ; Влево-вверх
; 483         ld   a, (drawanimation_w0)
; 484         add  a
; 485         add  h
; 486         ld   h, a
; 487         call DrawAnimation_1
; 488         jp   DrawAnimation_Exit
; 489 
; 490 DrawAnimation_LeftDown2:
; 491         ; Влево-вниз
; 492         ex   hl, de
; 493         ex   (sp), hl
; 494         ex   hl, de
; 495         call DrawAnimation_5
; 496 
; 497 DrawAnimation_Exit:
; 498         ; Отключение видеопамяти
; 499         xor  a
; 500         out  (0C1h), a
; 501 
; 502         ; Удаление из стека DE`
; 503         pop  hl
; 504     }
; 505     drawanimation_x = x;
	ld a, (__a_1_drawanimation)
	ld (drawanimation_x), a
; 506     drawanimation_y = y;
	ld a, (__a_2_drawanimation)
	ld (drawanimation_y), a
	ret
enddrawanimation:
; 46  EndDrawAnimation(void) {
; 47     DrawImage8(drawanimation_x, drawanimation_y, drawanimation_height, (uint8_t*)drawanimation_restore - 1);
	ld a, (drawanimation_x)
	ld (__a_1_drawimage8), a
	ld a, (drawanimation_y)
	ld (__a_2_drawimage8), a
	ld a, (drawanimation_height)
	ld (__a_3_drawimage8), a
	ld hl, (drawanimation_restore)
	dec hl
	jp drawimage8
getimage8:
; 409  GetImage8(uint8_t x, uint8_t y, uint8_t w16, uint8_t h, void *image) {

__a_5_getimage8 = __a_5_getimage8
        ; hl = image

        ld   a, (__a_3_getimage8)
        ld   (hl), a
        inc  hl

__a_1_getimage8 = $ + 1
        ld   a, 0 ; x
        rrca
        rrca
        and  03Eh
        or   0C0h
        ld   d, a

__a_2_getimage8 = $ + 1
        ld   e, 0 ; y

        ld   a, 10h
        out  (0C1h), a

__a_4_getimage8 = $ + 1
        ld   b, 0  ; h
getimage8_l1:
          push de
__a_3_getimage8 = $ + 1
          ld   c, 0 ; width8
getimage8_l0:
            ld   a, (de)
            inc  d
            ld   (hl), a
            inc  hl
            ld   a, (de)
            inc  d
            ld   (hl), a
            inc  hl
            ld   a, (de)
            inc  d
            ld   (hl), a
            inc  hl
            ld   a, (de)
            inc  d
            ld   (hl), a
            inc  hl
            dec  c
          jp   nz, getimage8_l0
__a_5_getimage8 = $ + 1
          pop  de
          inc  e
          dec  b
        jp   nz, getimage8_l1

        xor  a
        out  (0C1h), a
    
	ret
__o_sub_16:
    ld a, l
    sub e
    ld l, a
    ld a, h
    sbc d
    ld h, a
    ret
; Input: hl - value 1, de - value 2
; Output: hl - result

__o_and_16:
    ld a, h
    and d
    ld h, a
    ld a, l
    and e
    ld l, a
    ret
; Input: hl - value 1, de - value 2
; Output: hl - result

__o_xor_16:
    ld a, h
    xor d
    ld h, a
    ld a, l
    xor e
    ld l, a
    or h     ; Flag Z used for compare
    ret
__div_16_mod dw 0

__o_div_u16:
    push bc
    ex hl, de
    call __o_div_u16__l0
    ex hl, de
    ld (__div_16_mod), hl
    ex hl, de
    pop bc
    ret

__o_div_u16__l0:
__o_div_u16__l:
    ld a, h
    or l
    ret z
    ld bc, 0
    push bc
__o_div_u16__l1:
    ld a, e
    sub l
    ld a, d
    sbc h
    jp c, __o_div_u16__l2
    push hl
    add hl, hl
    jp nc, __o_div_u16__l1
__o_div_u16__l2:
    ld hl, 0
__o_div_u16__l3:
    pop bc
    ld a, b
    or c
    ret z
    add hl, hl
    push de
    ld a, e
    sub c
    ld e, a
    ld a, d
    sbc b
    ld d, a
    jp c, __o_div_u16__l4
    inc hl
    pop bc
    jp __o_div_u16__l3
__o_div_u16__l4:
    pop de
    jp __o_div_u16__l3
__o_div_i16:
    ld   a, h
    add  a
    jp   nc, __o_div_i16_1  ; hl - positive

    call __o_minus_16

    ld   a, d
    add  a
    jp   nc, __o_div_i16_2  ; hl - negative, de - positive

    ex   hl, de
    call __o_minus_16
    ex   hl, de

    jp   __o_div_u16 ; hl & de - negative

__o_div_i16_1:
    ld   a, d
    add  a
    jp   nc, __o_div_u16  ; hl & de - positive

    ex   hl, de
    call __o_minus_16
    ex   hl, de

__o_div_i16_2:
    call __o_div_u16
    jp   __o_minus_16
__o_mod_u16:
    push bc
    ex hl, de
    call __o_div_u16__l0
    ex hl, de
    pop bc
    ret
__o_shr_u16:
    inc e
__o_shr_u16__l1:
    dec e
    ret z
    ld a, h
    or a  ; cf = 0
    rra
    ld h, a
    ld a, l
    rra
    ld l, a
    jp __o_shr_u16__l1
__o_minus_16:
    xor a
    sub l
    ld l, a
    ld a, 0
    sbc h
    ld h, a
    ret
__o_i8_to_i16:
    ld l, a
    rla
    sbc a
    ld h, a
    ret
__c_1:
  db 27, 54, 48, 0
__c_0:
  db 27, 55, 49, 105, 71, 82, 65, 32, 34, 112, 65, 83, 88, 81, 78, 83
  db 32, 107, 79, 83, 89, 78, 75, 65, 34, 10, 68, 76, 81, 32, 75, 79
  db 77, 80, 88, 64, 84, 69, 82, 65, 32, 111, 75, 69, 65, 78, 32, 50
  db 52, 48, 10, 27, 55, 48, 40, 99, 41, 32, 49, 50, 45, 49, 50, 45
  db 50, 48, 50, 52, 32, 65, 108, 101, 109, 111, 114, 102, 10, 97, 108, 101
  db 107, 115, 101, 121, 46, 102, 46, 109, 111, 114, 111, 122, 111, 118, 64, 103
  db 109, 97, 105, 108, 46, 99, 111, 109, 10, 10, 27, 55, 49, 110, 65, 86
  db 77, 73, 84, 69, 32, 76, 64, 66, 85, 64, 32, 75, 76, 65, 87, 73
  db 91, 85, 27, 55, 48, 10, 0
image_card_back:
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 20
	db 185
	db 23
	db 184
	db 23
	db 184
	db 23
	db 184
	db 184
	db 125
	db 187
	db 124
	db 187
	db 124
	db 59
	db 188
	db 112
	db 249
	db 113
	db 250
	db 113
	db 250
	db 49
	db 186
	db 224
	db 241
	db 224
	db 241
	db 224
	db 241
	db 32
	db 177
	db 208
	db 233
	db 209
	db 235
	db 209
	db 235
	db 17
	db 171
	db 184
	db 197
	db 187
	db 199
	db 187
	db 199
	db 59
	db 135
	db 28
	db 161
	db 29
	db 163
	db 29
	db 163
	db 29
	db 163
	db 12
	db 17
	db 14
	db 17
	db 14
	db 17
	db 14
	db 145
	db 20
	db 185
	db 23
	db 184
	db 23
	db 184
	db 23
	db 184
	db 184
	db 125
	db 187
	db 124
	db 187
	db 124
	db 59
	db 188
	db 112
	db 249
	db 113
	db 250
	db 113
	db 250
	db 49
	db 186
	db 224
	db 241
	db 224
	db 241
	db 224
	db 241
	db 32
	db 177
	db 208
	db 233
	db 209
	db 235
	db 209
	db 235
	db 17
	db 171
	db 184
	db 197
	db 187
	db 199
	db 187
	db 199
	db 59
	db 135
	db 28
	db 161
	db 29
	db 163
	db 29
	db 163
	db 29
	db 163
	db 12
	db 17
	db 14
	db 17
	db 14
	db 17
	db 14
	db 145
	db 20
	db 185
	db 23
	db 184
	db 23
	db 184
	db 23
	db 184
	db 184
	db 125
	db 187
	db 124
	db 187
	db 124
	db 59
	db 188
	db 112
	db 249
	db 113
	db 250
	db 113
	db 250
	db 49
	db 186
	db 224
	db 241
	db 224
	db 241
	db 224
	db 241
	db 32
	db 177
	db 208
	db 233
	db 209
	db 235
	db 209
	db 235
	db 17
	db 171
	db 184
	db 197
	db 187
	db 199
	db 187
	db 199
	db 59
	db 135
	db 28
	db 161
	db 29
	db 163
	db 29
	db 163
	db 29
	db 163
	db 12
	db 17
	db 14
	db 17
	db 14
	db 17
	db 14
	db 145
	db 20
	db 185
	db 23
	db 184
	db 23
	db 184
	db 23
	db 184
	db 184
	db 125
	db 187
	db 124
	db 187
	db 124
	db 59
	db 188
	db 112
	db 249
	db 113
	db 250
	db 113
	db 250
	db 49
	db 186
	db 224
	db 241
	db 224
	db 241
	db 224
	db 241
	db 32
	db 177
	db 208
	db 233
	db 209
	db 235
	db 209
	db 235
	db 17
	db 171
	db 184
	db 197
	db 187
	db 199
	db 187
	db 199
	db 59
	db 135
	db 28
	db 161
	db 29
	db 163
	db 29
	db 163
	db 29
	db 163
	db 12
	db 17
	db 14
	db 17
	db 14
	db 17
	db 14
	db 145
	db 20
	db 185
	db 23
	db 184
	db 23
	db 184
	db 23
	db 184
	db 184
	db 125
	db 187
	db 124
	db 187
	db 124
	db 59
	db 188
	db 112
	db 249
	db 113
	db 250
	db 113
	db 250
	db 49
	db 186
	db 224
	db 241
	db 224
	db 241
	db 224
	db 241
	db 32
	db 177
	db 208
	db 233
	db 209
	db 235
	db 209
	db 235
	db 17
	db 171
	db 184
	db 197
	db 187
	db 199
	db 187
	db 199
	db 59
	db 135
	db 28
	db 161
	db 29
	db 163
	db 29
	db 163
	db 29
	db 163
	db 12
	db 17
	db 14
	db 17
	db 14
	db 17
	db 14
	db 145
	db 20
	db 185
	db 23
	db 184
	db 23
	db 184
	db 23
	db 184
	db 184
	db 125
	db 187
	db 124
	db 187
	db 124
	db 59
	db 188
	db 112
	db 249
	db 113
	db 250
	db 113
	db 250
	db 49
	db 186
	db 224
	db 241
	db 224
	db 241
	db 224
	db 241
	db 32
	db 177
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
image_background:
	db 2
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
image_rect:
	db 2
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 171
	db 84
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 213
	db 42
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
image_cursor:
	db 2
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 93
	db 170
	db 93
	db 170
	db 93
	db 170
	db 93
	db 93
	db 190
	db 93
	db 190
	db 93
	db 190
	db 93
	db 190
	db 190
	db 127
	db 190
	db 127
	db 190
	db 127
	db 190
	db 127
	db 127
	db 255
	db 127
	db 255
	db 127
	db 255
	db 127
	db 255
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
image_src_cursor:
	db 2
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 254
	db 255
	db 254
	db 255
	db 254
	db 255
	db 254
	db 255
	db 125
	db 254
	db 125
	db 254
	db 125
	db 254
	db 125
	db 254
	db 186
	db 125
	db 186
	db 125
	db 186
	db 125
	db 186
	db 125
	db 85
	db 186
	db 85
	db 186
	db 85
	db 186
	db 85
	db 186
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
	db 170
	db 85
image_title:
	db 16
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 7
	db 0
	db 254
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 127
	db 0
	db 230
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 128
	db 127
	db 49
	db 206
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 103
	db 0
	db 134
	db 0
	db 195
	db 0
	db 252
	db 0
	db 32
	db 0
	db 51
	db 0
	db 124
	db 0
	db 114
	db 0
	db 56
	db 0
	db 204
	db 0
	db 201
	db 0
	db 100
	db 0
	db 134
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 128
	db 127
	db 51
	db 204
	db 128
	db 127
	db 153
	db 102
	db 231
	db 24
	db 227
	db 28
	db 241
	db 14
	db 1
	db 254
	db 152
	db 103
	db 125
	db 130
	db 31
	db 224
	db 15
	db 240
	db 0
	db 103
	db 0
	db 62
	db 0
	db 153
	db 0
	db 96
	db 0
	db 38
	db 0
	db 147
	db 0
	db 121
	db 0
	db 56
	db 0
	db 147
	db 0
	db 201
	db 0
	db 201
	db 0
	db 36
	db 0
	db 63
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 128
	db 127
	db 55
	db 200
	db 128
	db 127
	db 217
	db 38
	db 108
	db 147
	db 6
	db 249
	db 155
	db 100
	db 1
	db 254
	db 216
	db 39
	db 13
	db 242
	db 51
	db 204
	db 24
	db 231
	db 0
	db 103
	db 0
	db 6
	db 0
	db 249
	db 0
	db 76
	db 0
	db 38
	db 0
	db 144
	db 0
	db 127
	db 0
	db 50
	db 0
	db 147
	db 0
	db 15
	db 0
	db 9
	db 0
	db 132
	db 0
	db 7
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 128
	db 127
	db 61
	db 194
	db 159
	db 96
	db 223
	db 32
	db 236
	db 19
	db 227
	db 28
	db 155
	db 100
	db 1
	db 254
	db 248
	db 7
	db 13
	db 242
	db 51
	db 204
	db 31
	db 224
	db 0
	db 103
	db 0
	db 50
	db 0
	db 153
	db 0
	db 204
	db 0
	db 32
	db 0
	db 147
	db 0
	db 121
	db 0
	db 38
	db 0
	db 147
	db 0
	db 73
	db 0
	db 200
	db 0
	db 36
	db 0
	db 51
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 128
	db 127
	db 57
	db 198
	db 128
	db 127
	db 217
	db 38
	db 108
	db 147
	db 54
	db 201
	db 243
	db 12
	db 1
	db 254
	db 184
	db 71
	db 13
	db 242
	db 159
	db 96
	db 25
	db 230
	db 0
	db 103
	db 0
	db 6
	db 0
	db 195
	db 0
	db 96
	db 0
	db 38
	db 0
	db 51
	db 0
	db 124
	db 0
	db 102
	db 0
	db 56
	db 0
	db 12
	db 0
	db 201
	db 0
	db 100
	db 0
	db 6
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 128
	db 127
	db 49
	db 206
	db 128
	db 127
	db 153
	db 102
	db 231
	db 24
	db 227
	db 28
	db 155
	db 100
	db 1
	db 254
	db 152
	db 103
	db 13
	db 242
	db 3
	db 252
	db 31
	db 224
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
image_cards:
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 124
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 20
	db 21
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 8
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 60
	db 60
	db 30
	db 30
	db 0
	db 128
	db 0
	db 1
	db 126
	db 126
	db 63
	db 63
	db 0
	db 128
	db 0
	db 1
	db 127
	db 127
	db 127
	db 127
	db 0
	db 128
	db 0
	db 1
	db 255
	db 255
	db 127
	db 127
	db 0
	db 128
	db 0
	db 1
	db 255
	db 255
	db 127
	db 127
	db 0
	db 128
	db 0
	db 1
	db 255
	db 255
	db 127
	db 127
	db 0
	db 128
	db 0
	db 1
	db 255
	db 255
	db 127
	db 127
	db 0
	db 128
	db 0
	db 1
	db 254
	db 254
	db 63
	db 63
	db 0
	db 128
	db 0
	db 1
	db 254
	db 254
	db 63
	db 63
	db 0
	db 128
	db 0
	db 1
	db 252
	db 252
	db 31
	db 31
	db 0
	db 128
	db 0
	db 1
	db 248
	db 248
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 240
	db 240
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 48
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 24
	db 25
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 124
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 20
	db 21
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 192
	db 192
	db 6
	db 6
	db 0
	db 128
	db 8
	db 9
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 6
	db 6
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 48
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 20
	db 21
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 192
	db 192
	db 6
	db 6
	db 0
	db 128
	db 8
	db 9
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 6
	db 6
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 6
	db 6
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 104
	db 105
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 124
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 96
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 20
	db 21
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 136
	db 137
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 124
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 12
	db 13
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 60
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 96
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 60
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 20
	db 21
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 136
	db 137
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 6
	db 6
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 12
	db 13
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 60
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 20
	db 21
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 136
	db 137
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 124
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 96
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 48
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 48
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 24
	db 25
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 20
	db 21
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 136
	db 137
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 6
	db 6
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 20
	db 21
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 136
	db 137
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 6
	db 6
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 6
	db 6
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 120
	db 121
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 96
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 20
	db 21
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 136
	db 137
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 206
	db 206
	db 230
	db 230
	db 0
	db 128
	db 0
	db 1
	db 228
	db 228
	db 79
	db 79
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 155
	db 155
	db 179
	db 179
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 249
	db 249
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 200
	db 201
	db 1
	db 1
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 3
	db 3
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 3
	db 3
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 3
	db 3
	db 0
	db 0
	db 0
	db 128
	db 204
	db 205
	db 1
	db 1
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 20
	db 21
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 136
	db 137
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 206
	db 206
	db 230
	db 230
	db 0
	db 128
	db 0
	db 1
	db 228
	db 228
	db 79
	db 79
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 155
	db 155
	db 179
	db 179
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 249
	db 249
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 27
	db 27
	db 176
	db 176
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 206
	db 206
	db 230
	db 230
	db 0
	db 128
	db 0
	db 1
	db 228
	db 228
	db 79
	db 79
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 155
	db 155
	db 179
	db 179
	db 1
	db 129
	db 128
	db 129
	db 63
	db 63
	db 249
	db 249
	db 3
	db 131
	db 128
	db 129
	db 63
	db 63
	db 248
	db 248
	db 3
	db 131
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 112
	db 113
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 96
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 96
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 216
	db 217
	db 0
	db 254
	db 0
	db 255
	db 0
	db 131
	db 252
	db 253
	db 89
	db 89
	db 107
	db 107
	db 1
	db 131
	db 252
	db 253
	db 85
	db 85
	db 171
	db 171
	db 1
	db 131
	db 248
	db 249
	db 76
	db 78
	db 200
	db 200
	db 0
	db 129
	db 112
	db 113
	db 248
	db 252
	db 127
	db 255
	db 0
	db 128
	db 32
	db 33
	db 0
	db 252
	db 0
	db 255
	db 0
	db 128
	db 0
	db 1
	db 32
	db 94
	db 0
	db 128
	db 0
	db 129
	db 0
	db 1
	db 40
	db 86
	db 0
	db 128
	db 0
	db 129
	db 0
	db 1
	db 42
	db 85
	db 0
	db 247
	db 1
	db 130
	db 0
	db 1
	db 42
	db 213
	db 0
	db 238
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 136
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 136
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 136
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 156
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 128
	db 1
	db 142
	db 0
	db 193
	db 43
	db 84
	db 0
	db 92
	db 13
	db 146
	db 192
	db 33
	db 42
	db 213
	db 0
	db 192
	db 11
	db 148
	db 64
	db 161
	db 82
	db 109
	db 128
	db 161
	db 14
	db 145
	db 192
	db 33
	db 237
	db 242
	db 225
	db 255
	db 1
	db 191
	db 0
	db 225
	db 224
	db 255
	db 255
	db 255
	db 16
	db 171
	db 32
	db 249
	db 128
	db 253
	db 63
	db 255
	db 16
	db 175
	db 80
	db 237
	db 0
	db 247
	db 0
	db 255
	db 16
	db 173
	db 160
	db 221
	db 0
	db 223
	db 0
	db 127
	db 16
	db 175
	db 64
	db 189
	db 1
	db 127
	db 0
	db 213
	db 18
	db 175
	db 128
	db 125
	db 2
	db 255
	db 128
	db 255
	db 50
	db 143
	db 4
	db 253
	db 165
	db 254
	db 170
	db 255
	db 34
	db 151
	db 8
	db 253
	db 202
	db 125
	db 255
	db 85
	db 35
	db 149
	db 20
	db 249
	db 148
	db 251
	db 170
	db 255
	db 2
	db 183
	db 40
	db 245
	db 40
	db 247
	db 170
	db 255
	db 2
	db 183
	db 68
	db 185
	db 80
	db 239
	db 170
	db 255
	db 2
	db 183
	db 180
	db 201
	db 160
	db 223
	db 252
	db 87
	db 3
	db 181
	db 136
	db 245
	db 65
	db 190
	db 169
	db 255
	db 2
	db 183
	db 84
	db 173
	db 7
	db 253
	db 69
	db 254
	db 5
	db 175
	db 20
	db 237
	db 15
	db 181
	db 74
	db 253
	db 5
	db 175
	db 84
	db 173
	db 7
	db 253
	db 150
	db 251
	db 7
	db 186
	db 20
	db 237
	db 3
	db 237
	db 47
	db 246
	db 5
	db 191
	db 84
	db 173
	db 129
	db 255
	db 94
	db 237
	db 2
	db 175
	db 20
	db 237
	db 0
	db 251
	db 189
	db 219
	db 0
	db 191
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 236
	db 237
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 184
	db 185
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 216
	db 217
	db 0
	db 128
	db 0
	db 127
	db 0
	db 128
	db 252
	db 253
	db 129
	db 193
	db 0
	db 218
	db 0
	db 128
	db 252
	db 253
	db 65
	db 225
	db 0
	db 245
	db 0
	db 129
	db 248
	db 249
	db 32
	db 176
	db 0
	db 172
	db 0
	db 129
	db 112
	db 113
	db 48
	db 120
	db 0
	db 210
	db 0
	db 129
	db 32
	db 33
	db 48
	db 120
	db 0
	db 97
	db 0
	db 129
	db 0
	db 1
	db 48
	db 248
	db 0
	db 64
	db 0
	db 131
	db 0
	db 1
	db 48
	db 248
	db 0
	db 123
	db 1
	db 131
	db 0
	db 1
	db 56
	db 124
	db 0
	db 119
	db 1
	db 131
	db 0
	db 1
	db 24
	db 92
	db 0
	db 68
	db 1
	db 131
	db 0
	db 1
	db 28
	db 62
	db 0
	db 68
	db 1
	db 131
	db 0
	db 1
	db 14
	db 47
	db 0
	db 68
	db 3
	db 135
	db 0
	db 1
	db 14
	db 31
	db 0
	db 206
	db 2
	db 134
	db 0
	db 129
	db 7
	db 23
	db 0
	db 192
	db 2
	db 134
	db 128
	db 193
	db 19
	db 59
	db 0
	db 238
	db 0
	db 133
	db 128
	db 225
	db 35
	db 123
	db 0
	db 228
	db 4
	db 141
	db 192
	db 241
	db 17
	db 237
	db 32
	db 208
	db 4
	db 141
	db 224
	db 249
	db 172
	db 82
	db 144
	db 111
	db 4
	db 141
	db 0
	db 13
	db 152
	db 103
	db 202
	db 53
	db 0
	db 143
	db 8
	db 253
	db 112
	db 143
	db 240
	db 15
	db 0
	db 143
	db 60
	db 253
	db 160
	db 92
	db 95
	db 160
	db 0
	db 157
	db 112
	db 245
	db 192
	db 51
	db 106
	db 149
	db 16
	db 173
	db 228
	db 233
	db 129
	db 111
	db 63
	db 192
	db 56
	db 167
	db 136
	db 149
	db 3
	db 223
	db 43
	db 212
	db 56
	db 182
	db 20
	db 45
	db 15
	db 191
	db 30
	db 225
	db 56
	db 183
	db 208
	db 237
	db 30
	db 126
	db 28
	db 99
	db 60
	db 179
	db 212
	db 237
	db 57
	db 249
	db 4
	db 186
	db 28
	db 155
	db 16
	db 237
	db 119
	db 247
	db 24
	db 229
	db 30
	db 185
	db 24
	db 229
	db 236
	db 239
	db 60
	db 219
	db 14
	db 157
	db 8
	db 245
	db 208
	db 222
	db 61
	db 219
	db 15
	db 172
	db 4
	db 185
	db 161
	db 191
	db 189
	db 91
	db 7
	db 158
	db 0
	db 253
	db 0
	db 122
	db 219
	db 39
	db 7
	db 175
	db 0
	db 237
	db 0
	db 234
	db 226
	db 158
	db 3
	db 151
	db 0
	db 173
	db 4
	db 239
	db 252
	db 253
	db 1
	db 171
	db 0
	db 173
	db 0
	db 171
	db 248
	db 251
	db 0
	db 149
	db 40
	db 169
	db 4
	db 175
	db 224
	db 230
	db 1
	db 171
	db 16
	db 185
	db 80
	db 254
	db 192
	db 222
	db 0
	db 151
	db 40
	db 169
	db 32
	db 174
	db 128
	db 186
	db 0
	db 175
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 60
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 216
	db 217
	db 0
	db 252
	db 0
	db 255
	db 0
	db 135
	db 252
	db 253
	db 253
	db 1
	db 255
	db 0
	db 3
	db 132
	db 252
	db 253
	db 189
	db 65
	db 170
	db 85
	db 0
	db 131
	db 248
	db 249
	db 168
	db 212
	db 170
	db 255
	db 0
	db 129
	db 112
	db 113
	db 234
	db 254
	db 127
	db 255
	db 0
	db 128
	db 32
	db 33
	db 62
	db 255
	db 0
	db 255
	db 0
	db 128
	db 0
	db 1
	db 0
	db 127
	db 0
	db 128
	db 0
	db 129
	db 0
	db 1
	db 0
	db 85
	db 0
	db 128
	db 0
	db 130
	db 0
	db 1
	db 0
	db 213
	db 0
	db 247
	db 0
	db 130
	db 0
	db 1
	db 0
	db 213
	db 0
	db 238
	db 0
	db 129
	db 0
	db 1
	db 0
	db 85
	db 0
	db 136
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 136
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 136
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 156
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 163
	db 0
	db 130
	db 0
	db 193
	db 0
	db 85
	db 0
	db 157
	db 0
	db 141
	db 0
	db 33
	db 0
	db 85
	db 0
	db 128
	db 0
	db 146
	db 0
	db 81
	db 0
	db 85
	db 0
	db 162
	db 0
	db 146
	db 0
	db 221
	db 0
	db 212
	db 0
	db 170
	db 16
	db 172
	db 8
	db 53
	db 0
	db 82
	db 0
	db 58
	db 8
	db 183
	db 12
	db 245
	db 0
	db 45
	db 160
	db 213
	db 4
	db 155
	db 144
	db 109
	db 0
	db 255
	db 32
	db 218
	db 2
	db 173
	db 80
	db 237
	db 42
	db 213
	db 80
	db 239
	db 33
	db 182
	db 168
	db 221
	db 129
	db 127
	db 18
	db 237
	db 33
	db 182
	db 160
	db 221
	db 63
	db 195
	db 168
	db 119
	db 48
	db 187
	db 164
	db 217
	db 199
	db 59
	db 139
	db 119
	db 16
	db 187
	db 84
	db 185
	db 255
	db 3
	db 75
	db 183
	db 56
	db 189
	db 68
	db 185
	db 0
	db 255
	db 84
	db 187
	db 8
	db 189
	db 72
	db 181
	db 0
	db 17
	db 68
	db 187
	db 40
	db 157
	db 72
	db 181
	db 0
	db 68
	db 36
	db 218
	db 20
	db 174
	db 168
	db 117
	db 0
	db 85
	db 36
	db 218
	db 52
	db 142
	db 136
	db 117
	db 0
	db 17
	db 42
	db 221
	db 12
	db 191
	db 148
	db 105
	db 0
	db 69
	db 162
	db 93
	db 56
	db 191
	db 144
	db 109
	db 0
	db 255
	db 18
	db 237
	db 0
	db 191
	db 148
	db 105
	db 254
	db 1
	db 19
	db 236
	db 0
	db 159
	db 144
	db 109
	db 0
	db 255
	db 210
	db 45
	db 8
	db 183
	db 212
	db 105
	db 56
	db 255
	db 18
	db 237
	db 3
	db 188
	db 144
	db 109
	db 56
	db 255
	db 214
	db 45
	db 18
	db 173
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 124
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 8
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 8
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 240
	db 240
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 248
	db 248
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 248
	db 248
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 252
	db 252
	db 31
	db 31
	db 0
	db 128
	db 0
	db 1
	db 254
	db 254
	db 63
	db 63
	db 0
	db 128
	db 0
	db 1
	db 252
	db 252
	db 31
	db 31
	db 0
	db 128
	db 0
	db 1
	db 248
	db 248
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 248
	db 248
	db 15
	db 15
	db 0
	db 128
	db 0
	db 1
	db 240
	db 240
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 224
	db 224
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 48
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 24
	db 25
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 124
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 8
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 28
	db 29
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 8
	db 9
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 48
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 8
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 28
	db 29
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 8
	db 9
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 104
	db 105
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 124
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 96
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 8
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 28
	db 29
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 8
	db 9
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 124
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 12
	db 13
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 60
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 96
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 60
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 8
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 28
	db 29
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 8
	db 9
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 12
	db 13
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 60
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 8
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 28
	db 29
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 8
	db 9
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 124
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 96
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 48
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 48
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 24
	db 25
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 8
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 28
	db 29
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 8
	db 9
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 8
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 28
	db 29
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 8
	db 9
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 128
	db 128
	db 3
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 1
	db 1
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 120
	db 121
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 96
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 8
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 28
	db 29
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 8
	db 9
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 225
	db 225
	db 0
	db 128
	db 0
	db 1
	db 132
	db 132
	db 67
	db 67
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 132
	db 132
	db 67
	db 67
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 225
	db 225
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 200
	db 201
	db 1
	db 1
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 3
	db 3
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 3
	db 3
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 3
	db 3
	db 0
	db 0
	db 0
	db 128
	db 204
	db 205
	db 1
	db 1
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 8
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 28
	db 29
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 28
	db 29
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 8
	db 9
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 225
	db 225
	db 0
	db 128
	db 0
	db 1
	db 132
	db 132
	db 67
	db 67
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 132
	db 132
	db 67
	db 67
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 225
	db 225
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 225
	db 225
	db 0
	db 128
	db 0
	db 1
	db 132
	db 132
	db 67
	db 67
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 192
	db 192
	db 7
	db 7
	db 0
	db 128
	db 0
	db 1
	db 132
	db 132
	db 67
	db 67
	db 0
	db 128
	db 0
	db 1
	db 14
	db 14
	db 225
	db 225
	db 0
	db 128
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 31
	db 31
	db 240
	db 240
	db 1
	db 129
	db 0
	db 1
	db 14
	db 14
	db 224
	db 224
	db 0
	db 128
	db 0
	db 1
	db 4
	db 4
	db 64
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 112
	db 113
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 96
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 96
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 16
	db 17
	db 0
	db 255
	db 0
	db 255
	db 0
	db 131
	db 56
	db 57
	db 90
	db 91
	db 107
	db 107
	db 1
	db 131
	db 124
	db 125
	db 86
	db 87
	db 171
	db 171
	db 1
	db 131
	db 124
	db 125
	db 76
	db 78
	db 200
	db 200
	db 0
	db 129
	db 56
	db 57
	db 248
	db 252
	db 127
	db 255
	db 0
	db 128
	db 16
	db 17
	db 0
	db 252
	db 0
	db 255
	db 0
	db 128
	db 0
	db 1
	db 32
	db 94
	db 0
	db 128
	db 0
	db 129
	db 0
	db 1
	db 40
	db 86
	db 0
	db 128
	db 0
	db 129
	db 0
	db 1
	db 42
	db 85
	db 0
	db 247
	db 1
	db 130
	db 0
	db 1
	db 42
	db 213
	db 0
	db 238
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 136
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 136
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 136
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 156
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 128
	db 1
	db 142
	db 0
	db 193
	db 43
	db 84
	db 0
	db 92
	db 13
	db 146
	db 192
	db 33
	db 42
	db 213
	db 0
	db 192
	db 11
	db 148
	db 64
	db 161
	db 82
	db 109
	db 128
	db 161
	db 14
	db 145
	db 192
	db 33
	db 237
	db 242
	db 225
	db 255
	db 1
	db 191
	db 0
	db 225
	db 224
	db 255
	db 255
	db 255
	db 16
	db 171
	db 32
	db 249
	db 128
	db 253
	db 63
	db 255
	db 16
	db 175
	db 80
	db 237
	db 0
	db 247
	db 0
	db 255
	db 16
	db 173
	db 160
	db 221
	db 0
	db 223
	db 0
	db 127
	db 16
	db 175
	db 64
	db 189
	db 1
	db 127
	db 0
	db 213
	db 18
	db 175
	db 128
	db 125
	db 2
	db 255
	db 128
	db 255
	db 50
	db 143
	db 4
	db 253
	db 165
	db 254
	db 170
	db 255
	db 34
	db 151
	db 8
	db 253
	db 202
	db 125
	db 255
	db 85
	db 35
	db 149
	db 20
	db 249
	db 148
	db 251
	db 170
	db 255
	db 2
	db 183
	db 40
	db 245
	db 40
	db 247
	db 170
	db 255
	db 2
	db 183
	db 68
	db 185
	db 80
	db 239
	db 170
	db 255
	db 2
	db 183
	db 180
	db 201
	db 160
	db 223
	db 252
	db 87
	db 3
	db 181
	db 136
	db 245
	db 65
	db 190
	db 169
	db 255
	db 2
	db 183
	db 84
	db 173
	db 7
	db 253
	db 69
	db 254
	db 5
	db 175
	db 20
	db 237
	db 15
	db 181
	db 74
	db 253
	db 5
	db 175
	db 84
	db 173
	db 7
	db 253
	db 150
	db 251
	db 7
	db 186
	db 20
	db 237
	db 3
	db 237
	db 47
	db 246
	db 5
	db 191
	db 84
	db 173
	db 129
	db 255
	db 94
	db 237
	db 2
	db 175
	db 20
	db 237
	db 0
	db 251
	db 189
	db 219
	db 0
	db 191
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 56
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 236
	db 237
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 184
	db 185
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 16
	db 17
	db 0
	db 192
	db 0
	db 127
	db 0
	db 128
	db 56
	db 57
	db 192
	db 224
	db 0
	db 218
	db 0
	db 128
	db 124
	db 125
	db 96
	db 240
	db 0
	db 245
	db 0
	db 129
	db 124
	db 125
	db 32
	db 176
	db 0
	db 172
	db 0
	db 129
	db 56
	db 57
	db 48
	db 120
	db 0
	db 210
	db 0
	db 129
	db 16
	db 17
	db 48
	db 120
	db 0
	db 97
	db 0
	db 129
	db 0
	db 1
	db 48
	db 248
	db 0
	db 64
	db 0
	db 131
	db 0
	db 1
	db 48
	db 248
	db 0
	db 123
	db 1
	db 131
	db 0
	db 1
	db 56
	db 124
	db 0
	db 119
	db 1
	db 131
	db 0
	db 1
	db 24
	db 92
	db 0
	db 68
	db 1
	db 131
	db 0
	db 1
	db 28
	db 62
	db 0
	db 68
	db 1
	db 131
	db 0
	db 1
	db 14
	db 47
	db 0
	db 68
	db 3
	db 135
	db 0
	db 1
	db 14
	db 31
	db 0
	db 206
	db 2
	db 134
	db 0
	db 129
	db 7
	db 23
	db 0
	db 192
	db 2
	db 134
	db 128
	db 193
	db 19
	db 59
	db 0
	db 238
	db 0
	db 133
	db 128
	db 225
	db 35
	db 123
	db 0
	db 228
	db 4
	db 141
	db 192
	db 241
	db 17
	db 237
	db 32
	db 208
	db 4
	db 141
	db 224
	db 249
	db 172
	db 82
	db 144
	db 111
	db 4
	db 141
	db 0
	db 13
	db 152
	db 103
	db 202
	db 53
	db 0
	db 143
	db 8
	db 253
	db 112
	db 143
	db 240
	db 15
	db 0
	db 143
	db 60
	db 253
	db 160
	db 92
	db 95
	db 160
	db 0
	db 157
	db 112
	db 245
	db 192
	db 51
	db 106
	db 149
	db 16
	db 173
	db 228
	db 233
	db 129
	db 111
	db 63
	db 192
	db 56
	db 167
	db 136
	db 149
	db 3
	db 223
	db 43
	db 212
	db 56
	db 182
	db 20
	db 45
	db 15
	db 191
	db 30
	db 225
	db 56
	db 183
	db 208
	db 237
	db 30
	db 126
	db 28
	db 99
	db 60
	db 179
	db 212
	db 237
	db 57
	db 249
	db 4
	db 186
	db 28
	db 155
	db 16
	db 237
	db 119
	db 247
	db 24
	db 229
	db 30
	db 185
	db 24
	db 229
	db 236
	db 239
	db 60
	db 219
	db 14
	db 157
	db 8
	db 245
	db 208
	db 222
	db 61
	db 219
	db 15
	db 172
	db 4
	db 185
	db 161
	db 191
	db 189
	db 91
	db 7
	db 158
	db 0
	db 253
	db 0
	db 122
	db 219
	db 39
	db 7
	db 175
	db 0
	db 237
	db 0
	db 234
	db 226
	db 158
	db 3
	db 151
	db 0
	db 173
	db 4
	db 239
	db 252
	db 253
	db 1
	db 171
	db 0
	db 173
	db 0
	db 171
	db 248
	db 251
	db 0
	db 149
	db 40
	db 169
	db 4
	db 175
	db 224
	db 230
	db 1
	db 171
	db 16
	db 185
	db 80
	db 254
	db 192
	db 222
	db 0
	db 151
	db 40
	db 169
	db 32
	db 174
	db 128
	db 186
	db 0
	db 175
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 60
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 108
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 16
	db 145
	db 0
	db 255
	db 0
	db 255
	db 0
	db 135
	db 56
	db 57
	db 255
	db 0
	db 255
	db 0
	db 3
	db 132
	db 124
	db 125
	db 191
	db 64
	db 170
	db 85
	db 0
	db 131
	db 124
	db 125
	db 171
	db 212
	db 170
	db 255
	db 0
	db 129
	db 56
	db 57
	db 235
	db 255
	db 127
	db 255
	db 0
	db 128
	db 16
	db 17
	db 62
	db 255
	db 0
	db 255
	db 0
	db 128
	db 0
	db 1
	db 0
	db 127
	db 0
	db 128
	db 0
	db 129
	db 0
	db 1
	db 0
	db 85
	db 0
	db 128
	db 0
	db 130
	db 0
	db 1
	db 0
	db 213
	db 0
	db 247
	db 0
	db 130
	db 0
	db 1
	db 0
	db 213
	db 0
	db 238
	db 0
	db 129
	db 0
	db 1
	db 0
	db 85
	db 0
	db 136
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 136
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 136
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 156
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 163
	db 0
	db 130
	db 0
	db 193
	db 0
	db 85
	db 0
	db 157
	db 0
	db 141
	db 0
	db 33
	db 0
	db 85
	db 0
	db 128
	db 0
	db 146
	db 0
	db 81
	db 0
	db 85
	db 0
	db 162
	db 0
	db 146
	db 0
	db 221
	db 0
	db 212
	db 0
	db 170
	db 16
	db 172
	db 8
	db 53
	db 0
	db 82
	db 0
	db 58
	db 8
	db 183
	db 12
	db 245
	db 0
	db 45
	db 160
	db 213
	db 4
	db 155
	db 144
	db 109
	db 0
	db 255
	db 32
	db 218
	db 2
	db 173
	db 80
	db 237
	db 42
	db 213
	db 80
	db 239
	db 33
	db 182
	db 168
	db 221
	db 129
	db 127
	db 18
	db 237
	db 33
	db 182
	db 160
	db 221
	db 63
	db 195
	db 168
	db 119
	db 48
	db 187
	db 164
	db 217
	db 199
	db 59
	db 139
	db 119
	db 16
	db 187
	db 84
	db 185
	db 255
	db 3
	db 75
	db 183
	db 56
	db 189
	db 68
	db 185
	db 0
	db 255
	db 84
	db 187
	db 8
	db 189
	db 72
	db 181
	db 0
	db 17
	db 68
	db 187
	db 40
	db 157
	db 72
	db 181
	db 0
	db 68
	db 36
	db 218
	db 20
	db 174
	db 168
	db 117
	db 0
	db 85
	db 36
	db 218
	db 52
	db 142
	db 136
	db 117
	db 0
	db 17
	db 42
	db 221
	db 12
	db 191
	db 148
	db 105
	db 0
	db 69
	db 162
	db 93
	db 56
	db 191
	db 144
	db 109
	db 0
	db 255
	db 18
	db 237
	db 0
	db 191
	db 148
	db 105
	db 254
	db 1
	db 19
	db 236
	db 0
	db 159
	db 144
	db 109
	db 0
	db 255
	db 210
	db 45
	db 8
	db 183
	db 212
	db 105
	db 56
	db 255
	db 18
	db 237
	db 3
	db 188
	db 144
	db 109
	db 56
	db 255
	db 214
	db 45
	db 18
	db 173
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 29
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 240
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 240
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 240
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 220
	db 0
	db 29
	db 0
	db 128
	db 0
	db 1
	db 0
	db 254
	db 0
	db 63
	db 0
	db 128
	db 0
	db 1
	db 0
	db 255
	db 0
	db 127
	db 0
	db 128
	db 0
	db 1
	db 0
	db 255
	db 0
	db 127
	db 0
	db 128
	db 0
	db 1
	db 0
	db 255
	db 0
	db 127
	db 0
	db 128
	db 0
	db 1
	db 0
	db 190
	db 0
	db 62
	db 0
	db 128
	db 0
	db 1
	db 0
	db 156
	db 0
	db 28
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 25
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 29
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 9
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 9
	db 0
	db 224
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 29
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 9
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 9
	db 0
	db 224
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 105
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 137
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 13
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 137
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 13
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 137
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 25
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 137
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 225
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 132
	db 0
	db 67
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 137
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 225
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 132
	db 0
	db 67
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 225
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 64
	db 0
	db 5
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 132
	db 0
	db 67
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 121
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 137
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 81
	db 0
	db 129
	db 0
	db 1
	db 0
	db 132
	db 0
	db 67
	db 0
	db 128
	db 0
	db 1
	db 0
	db 78
	db 0
	db 229
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 68
	db 0
	db 69
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 225
	db 0
	db 128
	db 0
	db 1
	db 0
	db 149
	db 0
	db 83
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 201
	db 0
	db 1
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 3
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 3
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 3
	db 0
	db 0
	db 0
	db 128
	db 0
	db 205
	db 0
	db 1
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 137
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 81
	db 0
	db 129
	db 0
	db 1
	db 0
	db 132
	db 0
	db 67
	db 0
	db 128
	db 0
	db 1
	db 0
	db 78
	db 0
	db 229
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 68
	db 0
	db 69
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 225
	db 0
	db 128
	db 0
	db 1
	db 0
	db 149
	db 0
	db 83
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 81
	db 0
	db 129
	db 0
	db 1
	db 0
	db 132
	db 0
	db 67
	db 0
	db 128
	db 0
	db 1
	db 0
	db 78
	db 0
	db 229
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 68
	db 0
	db 69
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 225
	db 0
	db 128
	db 0
	db 1
	db 0
	db 149
	db 0
	db 83
	db 0
	db 129
	db 0
	db 129
	db 0
	db 63
	db 0
	db 248
	db 0
	db 131
	db 0
	db 1
	db 0
	db 21
	db 0
	db 80
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 113
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 33
	db 0
	db 255
	db 0
	db 255
	db 0
	db 131
	db 0
	db 113
	db 90
	db 90
	db 107
	db 107
	db 1
	db 131
	db 0
	db 169
	db 84
	db 84
	db 171
	db 171
	db 1
	db 131
	db 0
	db 253
	db 76
	db 77
	db 200
	db 200
	db 0
	db 129
	db 0
	db 169
	db 248
	db 252
	db 127
	db 255
	db 0
	db 128
	db 0
	db 33
	db 0
	db 252
	db 0
	db 255
	db 0
	db 128
	db 0
	db 113
	db 32
	db 94
	db 0
	db 128
	db 0
	db 129
	db 0
	db 1
	db 40
	db 86
	db 0
	db 128
	db 0
	db 129
	db 0
	db 1
	db 42
	db 85
	db 0
	db 247
	db 1
	db 130
	db 0
	db 1
	db 42
	db 213
	db 0
	db 238
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 136
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 136
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 136
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 156
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 128
	db 1
	db 142
	db 0
	db 193
	db 43
	db 84
	db 0
	db 92
	db 13
	db 146
	db 192
	db 33
	db 42
	db 213
	db 0
	db 192
	db 11
	db 148
	db 64
	db 161
	db 82
	db 109
	db 128
	db 161
	db 14
	db 145
	db 192
	db 33
	db 237
	db 242
	db 225
	db 255
	db 1
	db 191
	db 0
	db 225
	db 224
	db 255
	db 255
	db 255
	db 16
	db 171
	db 32
	db 249
	db 128
	db 253
	db 63
	db 255
	db 16
	db 175
	db 80
	db 237
	db 0
	db 247
	db 0
	db 255
	db 16
	db 173
	db 160
	db 221
	db 0
	db 223
	db 0
	db 127
	db 16
	db 175
	db 64
	db 189
	db 1
	db 127
	db 0
	db 213
	db 18
	db 175
	db 128
	db 125
	db 2
	db 255
	db 128
	db 255
	db 50
	db 143
	db 4
	db 253
	db 165
	db 254
	db 170
	db 255
	db 34
	db 151
	db 8
	db 253
	db 202
	db 125
	db 255
	db 85
	db 35
	db 149
	db 20
	db 249
	db 148
	db 251
	db 170
	db 255
	db 2
	db 183
	db 40
	db 245
	db 40
	db 247
	db 170
	db 255
	db 2
	db 183
	db 68
	db 185
	db 80
	db 239
	db 170
	db 255
	db 2
	db 183
	db 180
	db 201
	db 160
	db 223
	db 252
	db 87
	db 3
	db 181
	db 136
	db 245
	db 65
	db 190
	db 169
	db 255
	db 2
	db 183
	db 84
	db 173
	db 7
	db 253
	db 69
	db 254
	db 5
	db 175
	db 20
	db 237
	db 15
	db 181
	db 74
	db 253
	db 5
	db 175
	db 84
	db 173
	db 7
	db 253
	db 150
	db 251
	db 7
	db 186
	db 20
	db 237
	db 3
	db 237
	db 47
	db 246
	db 5
	db 191
	db 84
	db 173
	db 129
	db 255
	db 94
	db 237
	db 2
	db 175
	db 20
	db 237
	db 0
	db 251
	db 189
	db 219
	db 0
	db 191
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 237
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 185
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 33
	db 0
	db 192
	db 0
	db 127
	db 0
	db 128
	db 0
	db 113
	db 192
	db 224
	db 0
	db 218
	db 0
	db 128
	db 0
	db 169
	db 96
	db 240
	db 0
	db 245
	db 0
	db 129
	db 0
	db 253
	db 32
	db 177
	db 0
	db 172
	db 0
	db 129
	db 0
	db 169
	db 48
	db 120
	db 0
	db 210
	db 0
	db 129
	db 0
	db 33
	db 48
	db 120
	db 0
	db 97
	db 0
	db 129
	db 0
	db 113
	db 48
	db 248
	db 0
	db 64
	db 0
	db 131
	db 0
	db 1
	db 48
	db 248
	db 0
	db 123
	db 1
	db 131
	db 0
	db 1
	db 56
	db 124
	db 0
	db 119
	db 1
	db 131
	db 0
	db 1
	db 24
	db 92
	db 0
	db 68
	db 1
	db 131
	db 0
	db 1
	db 28
	db 62
	db 0
	db 68
	db 1
	db 131
	db 0
	db 1
	db 14
	db 47
	db 0
	db 68
	db 3
	db 135
	db 0
	db 1
	db 14
	db 31
	db 0
	db 206
	db 2
	db 134
	db 0
	db 129
	db 7
	db 23
	db 0
	db 192
	db 2
	db 134
	db 128
	db 193
	db 19
	db 59
	db 0
	db 238
	db 0
	db 133
	db 128
	db 225
	db 35
	db 123
	db 0
	db 228
	db 4
	db 141
	db 192
	db 241
	db 17
	db 237
	db 32
	db 208
	db 4
	db 141
	db 224
	db 249
	db 172
	db 82
	db 144
	db 111
	db 4
	db 141
	db 0
	db 13
	db 152
	db 103
	db 202
	db 53
	db 0
	db 143
	db 8
	db 253
	db 112
	db 143
	db 240
	db 15
	db 0
	db 143
	db 60
	db 253
	db 160
	db 92
	db 95
	db 160
	db 0
	db 157
	db 112
	db 245
	db 192
	db 51
	db 106
	db 149
	db 16
	db 173
	db 228
	db 233
	db 129
	db 111
	db 63
	db 192
	db 56
	db 167
	db 136
	db 149
	db 3
	db 223
	db 43
	db 212
	db 56
	db 182
	db 20
	db 45
	db 15
	db 191
	db 30
	db 225
	db 56
	db 183
	db 208
	db 237
	db 30
	db 126
	db 28
	db 99
	db 60
	db 179
	db 212
	db 237
	db 57
	db 249
	db 4
	db 186
	db 28
	db 155
	db 16
	db 237
	db 119
	db 247
	db 24
	db 229
	db 30
	db 185
	db 24
	db 229
	db 236
	db 239
	db 60
	db 219
	db 14
	db 157
	db 8
	db 245
	db 208
	db 222
	db 61
	db 219
	db 15
	db 172
	db 4
	db 185
	db 161
	db 191
	db 189
	db 91
	db 7
	db 158
	db 0
	db 253
	db 0
	db 122
	db 219
	db 39
	db 7
	db 175
	db 0
	db 237
	db 0
	db 234
	db 226
	db 158
	db 3
	db 151
	db 0
	db 173
	db 4
	db 239
	db 252
	db 253
	db 1
	db 171
	db 0
	db 173
	db 0
	db 171
	db 248
	db 251
	db 0
	db 149
	db 40
	db 169
	db 4
	db 175
	db 224
	db 230
	db 1
	db 171
	db 16
	db 185
	db 80
	db 254
	db 192
	db 222
	db 0
	db 151
	db 40
	db 169
	db 32
	db 174
	db 128
	db 186
	db 0
	db 175
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 33
	db 0
	db 255
	db 0
	db 255
	db 0
	db 135
	db 0
	db 113
	db 254
	db 0
	db 255
	db 0
	db 3
	db 132
	db 0
	db 169
	db 188
	db 64
	db 170
	db 85
	db 0
	db 131
	db 0
	db 253
	db 168
	db 213
	db 170
	db 255
	db 0
	db 129
	db 0
	db 169
	db 232
	db 252
	db 127
	db 255
	db 0
	db 128
	db 0
	db 33
	db 62
	db 254
	db 0
	db 255
	db 0
	db 128
	db 0
	db 113
	db 0
	db 127
	db 0
	db 128
	db 0
	db 129
	db 0
	db 1
	db 0
	db 85
	db 0
	db 128
	db 0
	db 130
	db 0
	db 1
	db 0
	db 213
	db 0
	db 247
	db 0
	db 130
	db 0
	db 1
	db 0
	db 213
	db 0
	db 238
	db 0
	db 129
	db 0
	db 1
	db 0
	db 85
	db 0
	db 136
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 136
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 136
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 156
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 163
	db 0
	db 130
	db 0
	db 193
	db 0
	db 85
	db 0
	db 157
	db 0
	db 141
	db 0
	db 33
	db 0
	db 85
	db 0
	db 128
	db 0
	db 146
	db 0
	db 81
	db 0
	db 85
	db 0
	db 162
	db 0
	db 146
	db 0
	db 221
	db 0
	db 212
	db 0
	db 170
	db 16
	db 172
	db 8
	db 53
	db 0
	db 82
	db 0
	db 58
	db 8
	db 183
	db 12
	db 245
	db 0
	db 45
	db 160
	db 213
	db 4
	db 155
	db 144
	db 109
	db 0
	db 255
	db 32
	db 218
	db 2
	db 173
	db 80
	db 237
	db 42
	db 213
	db 80
	db 239
	db 33
	db 182
	db 168
	db 221
	db 129
	db 127
	db 18
	db 237
	db 33
	db 182
	db 160
	db 221
	db 63
	db 195
	db 168
	db 119
	db 48
	db 187
	db 164
	db 217
	db 199
	db 59
	db 139
	db 119
	db 16
	db 187
	db 84
	db 185
	db 255
	db 3
	db 75
	db 183
	db 56
	db 189
	db 68
	db 185
	db 0
	db 255
	db 84
	db 187
	db 8
	db 189
	db 72
	db 181
	db 0
	db 17
	db 68
	db 187
	db 40
	db 157
	db 72
	db 181
	db 0
	db 68
	db 36
	db 218
	db 20
	db 174
	db 168
	db 117
	db 0
	db 85
	db 36
	db 218
	db 52
	db 142
	db 136
	db 117
	db 0
	db 17
	db 42
	db 221
	db 12
	db 191
	db 148
	db 105
	db 0
	db 69
	db 162
	db 93
	db 56
	db 191
	db 144
	db 109
	db 0
	db 255
	db 18
	db 237
	db 0
	db 191
	db 148
	db 105
	db 254
	db 1
	db 19
	db 236
	db 0
	db 159
	db 144
	db 109
	db 0
	db 255
	db 210
	db 45
	db 8
	db 183
	db 212
	db 105
	db 56
	db 255
	db 18
	db 237
	db 3
	db 188
	db 144
	db 109
	db 56
	db 255
	db 214
	db 45
	db 18
	db 173
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 29
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 29
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 240
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 248
	db 0
	db 15
	db 0
	db 128
	db 0
	db 1
	db 0
	db 252
	db 0
	db 31
	db 0
	db 128
	db 0
	db 1
	db 0
	db 254
	db 0
	db 63
	db 0
	db 128
	db 0
	db 1
	db 0
	db 254
	db 0
	db 63
	db 0
	db 128
	db 0
	db 1
	db 0
	db 255
	db 0
	db 127
	db 0
	db 128
	db 0
	db 1
	db 0
	db 255
	db 0
	db 127
	db 0
	db 128
	db 0
	db 1
	db 0
	db 191
	db 0
	db 126
	db 0
	db 128
	db 0
	db 1
	db 0
	db 158
	db 0
	db 60
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 224
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 240
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 25
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 29
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 9
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 29
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 6
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 6
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 29
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 9
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 29
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 6
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 6
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 6
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 105
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 29
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 13
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 29
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 6
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 13
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 29
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 125
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 49
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 25
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 29
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 225
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 6
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 132
	db 0
	db 67
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 29
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 225
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 6
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 132
	db 0
	db 67
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 225
	db 0
	db 128
	db 0
	db 1
	db 0
	db 128
	db 0
	db 3
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 6
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 1
	db 0
	db 128
	db 0
	db 1
	db 0
	db 132
	db 0
	db 67
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 121
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 29
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 177
	db 0
	db 129
	db 0
	db 1
	db 0
	db 132
	db 0
	db 67
	db 0
	db 128
	db 0
	db 1
	db 0
	db 206
	db 0
	db 231
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 196
	db 0
	db 70
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 225
	db 0
	db 128
	db 0
	db 1
	db 0
	db 159
	db 0
	db 243
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 201
	db 0
	db 1
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 3
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 3
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 3
	db 0
	db 0
	db 0
	db 128
	db 0
	db 205
	db 0
	db 1
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 9
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 29
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 9
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 29
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 177
	db 0
	db 129
	db 0
	db 1
	db 0
	db 132
	db 0
	db 67
	db 0
	db 128
	db 0
	db 1
	db 0
	db 206
	db 0
	db 231
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 196
	db 0
	db 70
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 225
	db 0
	db 128
	db 0
	db 1
	db 0
	db 159
	db 0
	db 243
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 177
	db 0
	db 129
	db 0
	db 1
	db 0
	db 132
	db 0
	db 67
	db 0
	db 128
	db 0
	db 1
	db 0
	db 206
	db 0
	db 231
	db 0
	db 128
	db 0
	db 1
	db 0
	db 192
	db 0
	db 7
	db 0
	db 128
	db 0
	db 1
	db 0
	db 196
	db 0
	db 70
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 225
	db 0
	db 128
	db 0
	db 1
	db 0
	db 159
	db 0
	db 243
	db 0
	db 129
	db 0
	db 1
	db 0
	db 31
	db 0
	db 240
	db 0
	db 129
	db 0
	db 1
	db 0
	db 27
	db 0
	db 176
	db 0
	db 129
	db 0
	db 1
	db 0
	db 4
	db 0
	db 64
	db 0
	db 128
	db 0
	db 1
	db 0
	db 14
	db 0
	db 224
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 113
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 97
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 17
	db 0
	db 255
	db 0
	db 255
	db 0
	db 131
	db 0
	db 57
	db 90
	db 91
	db 107
	db 107
	db 1
	db 131
	db 0
	db 125
	db 86
	db 87
	db 171
	db 171
	db 1
	db 131
	db 0
	db 125
	db 76
	db 78
	db 200
	db 200
	db 0
	db 129
	db 0
	db 109
	db 248
	db 252
	db 127
	db 255
	db 0
	db 128
	db 0
	db 17
	db 0
	db 252
	db 0
	db 255
	db 0
	db 128
	db 0
	db 57
	db 32
	db 94
	db 0
	db 128
	db 0
	db 129
	db 0
	db 1
	db 40
	db 86
	db 0
	db 128
	db 0
	db 129
	db 0
	db 1
	db 42
	db 85
	db 0
	db 247
	db 1
	db 130
	db 0
	db 1
	db 42
	db 213
	db 0
	db 238
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 136
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 136
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 136
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 156
	db 1
	db 130
	db 0
	db 1
	db 42
	db 85
	db 0
	db 128
	db 1
	db 142
	db 0
	db 193
	db 43
	db 84
	db 0
	db 92
	db 13
	db 146
	db 192
	db 33
	db 42
	db 213
	db 0
	db 192
	db 11
	db 148
	db 64
	db 161
	db 82
	db 109
	db 128
	db 161
	db 14
	db 145
	db 192
	db 33
	db 237
	db 242
	db 225
	db 255
	db 1
	db 191
	db 0
	db 225
	db 224
	db 255
	db 255
	db 255
	db 16
	db 171
	db 32
	db 249
	db 128
	db 253
	db 63
	db 255
	db 16
	db 175
	db 80
	db 237
	db 0
	db 247
	db 0
	db 255
	db 16
	db 173
	db 160
	db 221
	db 0
	db 223
	db 0
	db 127
	db 16
	db 175
	db 64
	db 189
	db 1
	db 127
	db 0
	db 213
	db 18
	db 175
	db 128
	db 125
	db 2
	db 255
	db 128
	db 255
	db 50
	db 143
	db 4
	db 253
	db 165
	db 254
	db 170
	db 255
	db 34
	db 151
	db 8
	db 253
	db 202
	db 125
	db 255
	db 85
	db 35
	db 149
	db 20
	db 249
	db 148
	db 251
	db 170
	db 255
	db 2
	db 183
	db 40
	db 245
	db 40
	db 247
	db 170
	db 255
	db 2
	db 183
	db 68
	db 185
	db 80
	db 239
	db 170
	db 255
	db 2
	db 183
	db 180
	db 201
	db 160
	db 223
	db 252
	db 87
	db 3
	db 181
	db 136
	db 245
	db 65
	db 190
	db 169
	db 255
	db 2
	db 183
	db 84
	db 173
	db 7
	db 253
	db 69
	db 254
	db 5
	db 175
	db 20
	db 237
	db 15
	db 181
	db 74
	db 253
	db 5
	db 175
	db 84
	db 173
	db 7
	db 253
	db 150
	db 251
	db 7
	db 186
	db 20
	db 237
	db 3
	db 237
	db 47
	db 246
	db 5
	db 191
	db 84
	db 173
	db 129
	db 255
	db 94
	db 237
	db 2
	db 175
	db 20
	db 237
	db 0
	db 251
	db 189
	db 219
	db 0
	db 191
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 57
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 237
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 185
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 17
	db 0
	db 192
	db 0
	db 127
	db 0
	db 128
	db 0
	db 57
	db 192
	db 224
	db 0
	db 218
	db 0
	db 128
	db 0
	db 125
	db 96
	db 240
	db 0
	db 245
	db 0
	db 129
	db 0
	db 125
	db 32
	db 176
	db 0
	db 172
	db 0
	db 129
	db 0
	db 109
	db 48
	db 120
	db 0
	db 210
	db 0
	db 129
	db 0
	db 17
	db 48
	db 120
	db 0
	db 97
	db 0
	db 129
	db 0
	db 57
	db 48
	db 248
	db 0
	db 64
	db 0
	db 131
	db 0
	db 1
	db 48
	db 248
	db 0
	db 123
	db 1
	db 131
	db 0
	db 1
	db 56
	db 124
	db 0
	db 119
	db 1
	db 131
	db 0
	db 1
	db 24
	db 92
	db 0
	db 68
	db 1
	db 131
	db 0
	db 1
	db 28
	db 62
	db 0
	db 68
	db 1
	db 131
	db 0
	db 1
	db 14
	db 47
	db 0
	db 68
	db 3
	db 135
	db 0
	db 1
	db 14
	db 31
	db 0
	db 206
	db 2
	db 134
	db 0
	db 129
	db 7
	db 23
	db 0
	db 192
	db 2
	db 134
	db 128
	db 193
	db 19
	db 59
	db 0
	db 238
	db 0
	db 133
	db 128
	db 225
	db 35
	db 123
	db 0
	db 228
	db 4
	db 141
	db 192
	db 241
	db 17
	db 237
	db 32
	db 208
	db 4
	db 141
	db 224
	db 249
	db 172
	db 82
	db 144
	db 111
	db 4
	db 141
	db 0
	db 13
	db 152
	db 103
	db 202
	db 53
	db 0
	db 143
	db 8
	db 253
	db 112
	db 143
	db 240
	db 15
	db 0
	db 143
	db 60
	db 253
	db 160
	db 92
	db 95
	db 160
	db 0
	db 157
	db 112
	db 245
	db 192
	db 51
	db 106
	db 149
	db 16
	db 173
	db 228
	db 233
	db 129
	db 111
	db 63
	db 192
	db 56
	db 167
	db 136
	db 149
	db 3
	db 223
	db 43
	db 212
	db 56
	db 182
	db 20
	db 45
	db 15
	db 191
	db 30
	db 225
	db 56
	db 183
	db 208
	db 237
	db 30
	db 126
	db 28
	db 99
	db 60
	db 179
	db 212
	db 237
	db 57
	db 249
	db 4
	db 186
	db 28
	db 155
	db 16
	db 237
	db 119
	db 247
	db 24
	db 229
	db 30
	db 185
	db 24
	db 229
	db 236
	db 239
	db 60
	db 219
	db 14
	db 157
	db 8
	db 245
	db 208
	db 222
	db 61
	db 219
	db 15
	db 172
	db 4
	db 185
	db 161
	db 191
	db 189
	db 91
	db 7
	db 158
	db 0
	db 253
	db 0
	db 122
	db 219
	db 39
	db 7
	db 175
	db 0
	db 237
	db 0
	db 234
	db 226
	db 158
	db 3
	db 151
	db 0
	db 173
	db 4
	db 239
	db 252
	db 253
	db 1
	db 171
	db 0
	db 173
	db 0
	db 171
	db 248
	db 251
	db 0
	db 149
	db 40
	db 169
	db 4
	db 175
	db 224
	db 230
	db 1
	db 171
	db 16
	db 185
	db 80
	db 254
	db 192
	db 222
	db 0
	db 151
	db 40
	db 169
	db 32
	db 174
	db 128
	db 186
	db 0
	db 175
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 2
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 61
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 109
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 145
	db 0
	db 255
	db 0
	db 255
	db 0
	db 135
	db 0
	db 57
	db 255
	db 0
	db 255
	db 0
	db 3
	db 132
	db 0
	db 125
	db 191
	db 64
	db 170
	db 85
	db 0
	db 131
	db 0
	db 125
	db 171
	db 212
	db 170
	db 255
	db 0
	db 129
	db 0
	db 109
	db 235
	db 252
	db 127
	db 255
	db 0
	db 128
	db 0
	db 17
	db 61
	db 254
	db 0
	db 255
	db 0
	db 128
	db 0
	db 57
	db 0
	db 127
	db 0
	db 128
	db 0
	db 129
	db 0
	db 1
	db 0
	db 85
	db 0
	db 128
	db 0
	db 130
	db 0
	db 1
	db 0
	db 213
	db 0
	db 247
	db 0
	db 130
	db 0
	db 1
	db 0
	db 213
	db 0
	db 238
	db 0
	db 129
	db 0
	db 1
	db 0
	db 85
	db 0
	db 136
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 136
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 136
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 156
	db 0
	db 130
	db 0
	db 1
	db 0
	db 85
	db 0
	db 163
	db 0
	db 130
	db 0
	db 193
	db 0
	db 85
	db 0
	db 157
	db 0
	db 141
	db 0
	db 33
	db 0
	db 85
	db 0
	db 128
	db 0
	db 146
	db 0
	db 81
	db 0
	db 85
	db 0
	db 162
	db 0
	db 146
	db 0
	db 221
	db 0
	db 212
	db 0
	db 170
	db 16
	db 172
	db 8
	db 53
	db 0
	db 82
	db 0
	db 58
	db 8
	db 183
	db 12
	db 245
	db 0
	db 45
	db 160
	db 213
	db 4
	db 155
	db 144
	db 109
	db 0
	db 255
	db 32
	db 218
	db 2
	db 173
	db 80
	db 237
	db 42
	db 213
	db 80
	db 239
	db 33
	db 182
	db 168
	db 221
	db 129
	db 127
	db 18
	db 237
	db 33
	db 182
	db 160
	db 221
	db 63
	db 195
	db 168
	db 119
	db 48
	db 187
	db 164
	db 217
	db 199
	db 59
	db 139
	db 119
	db 16
	db 187
	db 84
	db 185
	db 255
	db 3
	db 75
	db 183
	db 56
	db 189
	db 68
	db 185
	db 0
	db 255
	db 84
	db 187
	db 8
	db 189
	db 72
	db 181
	db 0
	db 17
	db 68
	db 187
	db 40
	db 157
	db 72
	db 181
	db 0
	db 68
	db 36
	db 218
	db 20
	db 174
	db 168
	db 117
	db 0
	db 85
	db 36
	db 218
	db 52
	db 142
	db 136
	db 117
	db 0
	db 17
	db 42
	db 221
	db 12
	db 191
	db 148
	db 105
	db 0
	db 69
	db 162
	db 93
	db 56
	db 191
	db 144
	db 109
	db 0
	db 255
	db 18
	db 237
	db 0
	db 191
	db 148
	db 105
	db 254
	db 1
	db 19
	db 236
	db 0
	db 159
	db 144
	db 109
	db 0
	db 255
	db 210
	db 45
	db 8
	db 183
	db 212
	db 105
	db 56
	db 255
	db 18
	db 237
	db 3
	db 188
	db 144
	db 109
	db 56
	db 255
	db 214
	db 45
	db 18
	db 173
	db 0
	db 1
	db 0
	db 0
	db 0
	db 0
	db 0
	db 128
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
	db 0
	db 255
ui_columns:
	db 4
	db 16
	ds 1
	db 40
	db 16
	ds 1
	db 76
	db 16
	ds 1
	db 112
	db 16
	ds 1
	db 148
	db 16
	ds 1
	db 184
	db 16
	ds 1
	db 220
	db 16
	ds 1
	db 4
	db 72
	ds 1
	db 40
	db 72
	ds 1
	db 76
	db 72
	ds 1
	db 112
	db 72
	ds 1
	db 148
	db 72
	ds 1
	db 184
	db 72
	ds 1
	db 220
	db 72
	ds 1
src_cursor:
	db 255
__rand_seed:
	dw 1
__bss:
drawanimation_height:
	ds 1
columns:
	ds 350
cursor:
	ds 1
__static_stack:
	ds 3518
__end:
__s_begindrawanimation equ __static_stack + 6
__a_1_begindrawanimation equ __s_begindrawanimation + 0
__a_2_begindrawanimation equ __s_begindrawanimation + 1
__a_3_begindrawanimation equ __s_begindrawanimation + 2
__a_4_begindrawanimation equ __s_begindrawanimation + 3
__a_5_begindrawanimation equ __s_begindrawanimation + 4
__a_6_begindrawanimation equ __s_begindrawanimation + 6
__s_getimage8 equ __static_stack + 0
__s_drawimage8 equ __static_stack + 0
__a_4_drawimage8 equ __s_drawimage8 + 3
__s_drawanimation equ __static_stack + 2
__a_1_drawanimation equ __s_drawanimation + 0
__a_2_drawanimation equ __s_drawanimation + 1
__a_3_drawanimation equ __s_drawanimation + 2
__s_abs equ __static_stack + 0
__a_1_abs equ __s_abs + 0
__s_copyimage equ __static_stack + 1
__s_drawimage equ __static_stack + 4
__a_1_drawimage equ __s_drawimage + 0
__s_getcardimage equ __static_stack + 0
__a_1_getcardimage equ __s_getcardimage + 0
__s_gettopcardimage equ __static_stack + 1
__a_1_gettopcardimage equ __s_gettopcardimage + 2
__s_out equ __static_stack + 0
__s_redraw equ __static_stack + 5
__s_redrawcolumn equ __static_stack + 10
__a_1_redrawcolumn equ __s_redrawcolumn + 10
__s_redrawallcolumns equ __static_stack + 21
__s_drawcursorint equ __static_stack + 10
__a_1_drawcursorint equ __s_drawcursorint + 2
__a_2_drawcursorint equ __s_drawcursorint + 3
__s_drawcursor equ __static_stack + 15
__a_1_drawcursor equ __s_drawcursor + 0
__s_drawsrccursor equ __static_stack + 15
__a_1_drawsrccursor equ __s_drawsrccursor + 0
__s_hidecursor equ __static_stack + 15
__a_1_hidecursor equ __s_hidecursor + 0
__s_max_u8 equ __static_stack + 0
__a_1_max_u8 equ __s_max_u8 + 0
__a_2_max_u8 equ __s_max_u8 + 1
__s_moveanimation equ __static_stack + 14
__a_1_moveanimation equ __s_moveanimation + 3485
__a_2_moveanimation equ __s_moveanimation + 3486
__a_3_moveanimation equ __s_moveanimation + 3487
__a_4_moveanimation equ __s_moveanimation + 3488
__s_winanimation equ __static_stack + 10
__s_getkey equ __static_stack + 0
__s_puts equ __static_stack + 3
__a_1_puts equ __s_puts + 0
__s_peekcard equ __static_stack + 0
__a_1_peekcard equ __s_peekcard + 3
__s_getcard equ __static_stack + 0
__a_1_getcard equ __s_getcard + 3
__s_putcard equ __static_stack + 0
__a_1_putcard equ __s_putcard + 3
__a_2_putcard equ __s_putcard + 4
__s_rewindcards equ __static_stack + 21
__s_nextcard equ __static_stack + 22
__s_movecards equ __static_stack + 3503
__s_memcpy equ __static_stack + 0
__a_1_memcpy equ __s_memcpy + 0
__a_2_memcpy equ __s_memcpy + 2
__a_3_memcpy equ __s_memcpy + 4
__s_memset equ __static_stack + 0
__a_1_memset equ __s_memset + 0
__a_2_memset equ __s_memset + 2
__a_3_memset equ __s_memset + 3
__s_newgame equ __static_stack + 22
__s_movecursor equ __static_stack + 16
__a_1_movecursor equ __s_movecursor + 0
__s_putchar equ __static_stack + 1
__a_1_putchar equ __s_putchar + 0
__s_cpmbiosconout equ __static_stack + 0
__a_1_cpmbiosconout equ __s_cpmbiosconout + 0
    savebin "sol_.com", __begin, __bss - __begin
