/* Game Solitaire for Ocean 240
 * Copyright (c) 2024 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdlib.h>
#include "drawanimation.h"
#include "graph.h"

static uint8_t drawanimation_height;
extern void *drawanimation_restore;
extern void *drawanimation_save;
extern uint8_t drawanimation_width8;
extern uint8_t drawanimation_x;
extern uint8_t drawanimation_y;
extern uint8_t drawanimation_h0;
extern uint8_t drawanimation_h1;
extern uint8_t drawanimation_w0;
extern uint8_t drawanimation_w1;
extern int8_t drawanimation_dx;
extern int8_t drawanimation_dy;

void BeginDrawAnimation(uint8_t x, uint8_t y, uint8_t w16, uint8_t h, void *back, void *back2)
{
    GetImage8(x, y, w16, h, back);
    *(uint8_t*)back2 = *(uint8_t*)back;
    drawanimation_restore = (uint8_t*)back + 1;
    drawanimation_save = (uint8_t*)back2 + 1;
    drawanimation_width8 = w16 * 2;
    drawanimation_height = h;
    drawanimation_x = x;
    drawanimation_y = y;
}

void EndDrawAnimation(void) {
    DrawImage8(drawanimation_x, drawanimation_y, drawanimation_height, (uint8_t*)drawanimation_restore - 1);
}

/* HL  - Экран                       W0   W1   W0
 * DE` - Изображение                +--------+
 * DE  - Сохраненное изображение    |   1    |      H0
 * BC  - Сохраняемое изображение    |   +----|---+
 *                                  | 2 | 3  | 4 |  H1
 * 1) WxH0  DE->HL                  +--------+   |
 * 2) W0xH1 DE->HL                      |   5    |  H0
 * 3) W1xH1 DE->BC, DE`->HL             +--------+
 * 4) W0xH1 HL->BC, DE`->HL
 * 5) WxH0  HL->BC, DE`->HL
 */

void DrawAnimation(uint8_t x, uint8_t y, void *image) {
    drawanimation_dy = y - drawanimation_y;
    drawanimation_h0 = abs(drawanimation_dy);
    drawanimation_h1 = drawanimation_height - drawanimation_h0;
    drawanimation_dx = x / 8 - drawanimation_x / 8;
    drawanimation_w0 = abs(drawanimation_dx);
    drawanimation_w1 = drawanimation_width8 - drawanimation_w0;

    asm {
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
    }
    drawanimation_x = x;
    drawanimation_y = y;
}

void CopyImage(uint8_t w8, uint8_t h, void *dest, const void *src) {
    asm {
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
    }
}
