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

#include "graph.h"

void DrawImage8(uint8_t x, uint8_t y, uint8_t h, const void *image) {
    asm {
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
    }
}

void DrawImage(int16_t x, uint8_t y, uint8_t height, const void *image) {
    asm {
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
    }
}

void GetImage8(uint8_t x, uint8_t y, uint8_t w16, uint8_t h, void *image) {
    asm {
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
    }
}
