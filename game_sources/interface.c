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

#include "interface.h"
#include <stdio.h>
#include <c8080/io.h>
#include <c8080/countof.h>
#include <string.h>
#include <stdlib.h>
#include <cpmbios.h>
#include "resources.h"
#include "ocean240.h"
#include "graph.h"
#include "logic.h"
#include "drawanimation.h"

struct ui_column {
    uint8_t x, y;
    uint8_t cursor_y;
};

static struct ui_column ui_columns[] = {
    { 4 + 36 * 0, 16 },
    { 4 + 36 * 1, 16 },
    { 4 + 36 * 2, 16 },
    { 4 + 36 * 3, 16 },
    { 4 + 36 * 4, 16 },
    { 4 + 36 * 5, 16 },
    { 4 + 36 * 6, 16 },
    { 4 + 36 * 0, 72 },
    { 4 + 36 * 1, 72 },
    { 4 + 36 * 2, 72 },
    { 4 + 36 * 3, 72 },
    { 4 + 36 * 4, 72 },
    { 4 + 36 * 5, 72 },
    { 4 + 36 * 6, 72 }
};

static const int BIG_CARD_STEP = 8;
static const int SMALL_CARD_STEP = 4;
static const int MAX_VISIBLE_CARDS = (SCREEN_HEIGHT - 72 - IMAGE_CURSOR_HEIGHT - IMAGE_CARD_HEIGHT) / BIG_CARD_STEP + 1;

static uint8_t *GetCardImage(uint8_t card_index) {
    if (card_index & CLOSED_CARD)
        return image_card_back;
    return &image_cards[card_index * IMAGE_CARD_SIZEOF];
}

static uint8_t *GetTopCardImage(uint8_t column_index) {
    struct column *c = &columns[column_index];
    if (c->count == 0)
        return image_rect;
    return GetCardImage(c->items[c->count - 1]);
}

void InitScreen(void) {
    out(PORT_SCROLL_X, PORT_SCROLL_X__DEFAULT);
    out(PORT_SCROLL_Y, PORT_SCROLL_Y__DEFAULT);
    out(PORT_COLOR, PORT_COLOR__COLOR_MODE | 1);
}

void Redraw(void) {
    DrawImage8(0, 0, IMAGE_TITLE_HEIGHT, image_title);

    unsigned x, y;
    for (y = IMAGE_TITLE_HEIGHT; y < SCREEN_HEIGHT; y += IMAGE_BACKGROUND_HEIGHT) {
        uint8_t h = (y < SCREEN_HEIGHT - IMAGE_BACKGROUND_HEIGHT) ? IMAGE_BACKGROUND_HEIGHT : (SCREEN_HEIGHT - y);
        for (x = 0; x < SCREEN_WIDTH_PIXELS; x += IMAGE_BACKGROUND_WIDTH)
            DrawImage8(x, y, h, image_background);
    }
}

void RedrawColumn(uint8_t column_index) {
    struct ui_column *ui = &ui_columns[column_index];
    uint8_t x = ui->x;
    uint8_t y = ui->y;

    if (column_index >= 7) {
        struct column *c = &columns[column_index];
        uint8_t *p = c->items;
        uint8_t i = c->count;

        if (i > MAX_VISIBLE_CARDS) {
            uint8_t j = (i - MAX_VISIBLE_CARDS) * 2;
            i -= j;
            do {
                DrawImage(x, y, SMALL_CARD_STEP, GetCardImage(*p));
                p++;
                y += SMALL_CARD_STEP;
                j--;
            } while (j != 0);
        }

        for (; i > 1; i--) {
            DrawImage(x, y, BIG_CARD_STEP, GetCardImage(*p));
            p++;
            y += BIG_CARD_STEP;
        }
    }

    if (column_index != 2)
        DrawImage(x, y, IMAGE_CARD_BACK_HEIGHT, GetTopCardImage(column_index));
    y += IMAGE_CARD_BACK_HEIGHT;

    ui->cursor_y = y;
    if (cursor == column_index) {
        DrawImage(x, y, IMAGE_CURSOR_HEIGHT, image_cursor);
        y += IMAGE_CURSOR_HEIGHT;
    }

    if (column_index >= 7) {
        while (y != 0) {
            uint8_t h = IMAGE_CARD_HEIGHT;
            if (y > SCREEN_HEIGHT - IMAGE_CARD_HEIGHT)
                h = 0 - y;
            DrawImage(x, y, h, image_background);
            y += h;
        }
    } else if (cursor != column_index) {
        DrawImage(x, y, IMAGE_CURSOR_HEIGHT, image_background);
    }
}

void RedrawAllColumns(void) {
    uint8_t i;
    for (i = 0; i < COUNTOF(ui_columns); i++)
        RedrawColumn(i);
}

static void DrawCursorInt(uint8_t column_index, uint8_t *image) {
    struct ui_column *c = &ui_columns[column_index];
    DrawImage(c->x, c->cursor_y, IMAGE_CURSOR_HEIGHT, image);
}

void DrawCursor(uint8_t column_index) {
    DrawCursorInt(column_index, image_cursor);
}

void DrawSrcCursor(uint8_t column_index) {
    DrawCursorInt(column_index, image_src_cursor);
}

void HideCursor(uint8_t column_index) {
    DrawCursorInt(column_index, image_background);
}

static uint8_t max_u8(uint8_t a, uint8_t b) {
    return a > b ? a : b;
}

void MoveAnimation(uint8_t from_column, uint8_t to_column, uint8_t start, uint8_t height) {
    static const int CELL_SIZE = 8;

    /* Предотвращение нарушения памяти. В реальности больше карт перетаскиваться быть не может. */
    if (height - start > VALUES_COUNT)
        height = start + VALUES_COUNT;
    const uint8_t image_height = IMAGE_CARD_BACK_HEIGHT + (height - start - 1) * BIG_CARD_STEP;

    struct ui_column *c = &ui_columns[from_column];
    uint8_t x0 = c->x;
    uint8_t y0 = c->y;
    if (from_column >= 7)
        y0 += BIG_CARD_STEP * start;

    c = &ui_columns[to_column];
    uint8_t x1 = c->x;
    uint8_t y1 = c->cursor_y - IMAGE_CARD_BACK_HEIGHT;
    if (to_column >= 7 && columns[to_column].count > 0)
        y1 += CELL_SIZE;

    /* Предотвращение перелета */
    if (x1 < x0)
        if (x1 % CELL_SIZE != 0)
            x1 += CELL_SIZE;

    /* Предотвращение вылета за границу экрана */
    uint8_t max_y = SCREEN_HEIGHT - image_height;
    if (y0 > max_y)
        y0 = max_y;
    if (y1 > max_y)
        y1 = max_y;

    /* Смещение целой части */
    static const int FIXED_POINT = 8;

    /* Вычисление вектора */
    int16_t dx = abs(x1 - x0);
    int16_t dy = abs(y1 - y0);
    uint8_t step_count = max_u8(dx, dy) / CELL_SIZE;
    if (step_count == 0)
        return;
    dx = ((dx << FIXED_POINT) + step_count / 2) / step_count;
    dy = ((dy << FIXED_POINT) + step_count / 2) / step_count;
    if (x1 < x0)
        dx = -dx;
    if (y1 < y0)
        dy = -dy;

    /* Подготовка изображения перетаскиваемой стопки карт */
    static const uint8_t ANI_MAX_HEIGHT = IMAGE_CARD_BACK_HEIGHT + (VALUES_COUNT - 1) * BIG_CARD_STEP;
    static const unsigned ANI_BPL = IMAGE_CARD_BACK_WIDTH / 8 * 2;
    uint8_t aniImage[ANI_BPL * ANI_MAX_HEIGHT + 1];
    aniImage[0] = IMAGE_CARD_BACK_WIDTH / 16;
    uint8_t i;
    uint8_t *dd = aniImage + 1;
    uint8_t *cc = &columns[from_column].items[start];
    for (i = start; i + 1 < height; i++) {
        CopyImage(IMAGE_CARD_BACK_WIDTH, BIG_CARD_STEP, dd, GetCardImage(*cc) + 1);
        dd += BIG_CARD_STEP * ANI_BPL;
        cc++;
    }
    CopyImage(IMAGE_CARD_BACK_WIDTH, IMAGE_CARD_BACK_HEIGHT, dd, GetCardImage(*cc) + 1);

    /* Сохранения части экрана под перетаскиваемой колодой */
    uint8_t px = x0;
    uint8_t py = y0;
    uint8_t aniBack[sizeof(aniImage)];
    uint8_t aniBack2[sizeof(aniImage)];
    BeginDrawAnimation(x0, y0, IMAGE_CARD_BACK_WIDTH / 16, image_height, aniBack, aniBack2);

    uint16_t x = x0 << FIXED_POINT;
    uint16_t y = y0 << FIXED_POINT;
    while (step_count != 0) {
        step_count--;

        x += dx;
        y += dy;

        /* Получение целой части координат */
        uint8_t gx = (x + (1 << (FIXED_POINT - 1))) >> FIXED_POINT;
        uint8_t gy = (y + (1 << (FIXED_POINT - 1))) >> FIXED_POINT;

        DrawAnimation(gx, gy, aniImage);

        px = gx;
        py = gy;
    }

    EndDrawAnimation();
}

void WinAnimation(void) {
    do {
        uint8_t i = rand() % SUIT_COUNT;

        struct column *c = &columns[i + 3];
        if (c->count == 0)
            continue;

        uint8_t *card = GetCardImage(c->items[c->count - 1] & ~CLOSED_CARD);
        c->count--;

        /* Вычисление скорости */
        int16_t dx = ((uint8_t)rand() % 64) + 64;
        if (rand() & 1)
            dx = -dx;
        int16_t dy = -256 + (uint8_t)rand() % 256;

        /* Вычисление положения карты */
        static const int FIXED_POINT = 7;
        uint16_t x = (144 + 36 * i) << FIXED_POINT;
        uint16_t y = 16 << FIXED_POINT;

        for (;;) {
            /* Рисование карты на экране */
            uint16_t gx = (x + (1 << (FIXED_POINT - 1))) >> FIXED_POINT;
            uint8_t gy = (y + (1 << (FIXED_POINT - 1))) >> FIXED_POINT;
            DrawImage(gx - IMAGE_CARD_BACK_WIDTH, gy, IMAGE_CARD_HEIGHT, card);

            /* Изменение скорости */
            dy -= dy / 256;
            dy += 32;

            /* Изменение положения */
            y += dy;
            x += dx;

            /* Отскок от нижней границы экрана */
            static const uint16_t max_y = (SCREEN_HEIGHT - IMAGE_CARD_HEIGHT) << FIXED_POINT;
            if (y >= max_y) {
                y = max_y;
                dy = -dy;
                if (cpmBiosConSt())
                    break;
            }

            /* Если карта за пределами экрана - выход */
            if (x >= (SCREEN_WIDTH_PIXELS + IMAGE_CARD_BACK_WIDTH) << FIXED_POINT)
                break;
        }
    } while (!cpmBiosConSt());
    cpmBiosConIn();
    Redraw();
}

uint8_t GetKey(void) {
    while (!cpmBiosConSt())
        rand();

    uint8_t c = getchar();

    if (c >= 'a' && c <= 'z')
        return c - ('a' - 'A');

    switch (c) {
        case KEY_LEFT:
            return 'A';
        case KEY_RIGHT:
            return 'D';
        case KEY_UP:
            return 'W';
        case KEY_DOWN:
            return 'S';
    }

    return c;
}

void main(void) {
    puts(
        "\x1B71iGRA \"pASXQNS kOSYNKA\"\n"
        "DLQ KOMPX@TERA oKEAN 240\n"
        "\x1B70(c) 12-12-2024 Alemorf\n"
        "aleksey.f.morozov@gmail.com\n"
        "\n"
        "\x1B71nAVMITE L@BU@ KLAWI[U\x1B70\n");

    while (!cpmBiosConSt())
        rand();

    InitScreen();
    Redraw();
    Game();
    puts("\x1B60");
}
