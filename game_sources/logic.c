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

#include "logic.h"
#include "interface.h"
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <c8080/countof.h>
#include <c8080/div16mod.h>

/* Важные стоимости карт */
static const uint8_t VALUE_ACE = 0;
static const uint8_t VALUE_KING = 12;

/* Курсор. В какую колонку переносить. */
uint8_t cursor;

/* Значение для src_cursor */
static const uint8_t NO_SELECTION = 0xFF;

/* Из какой колонки переносить */
static uint8_t src_cursor = NO_SELECTION;

/* Возвращаемое значение функции PeekCard */
static const uint8_t NO_CARD = 0xFF;

/* Стопки карт */
struct column columns[14];

static uint8_t PeekCard(uint8_t column_index) {
    struct column *c = &columns[column_index];
    uint8_t count = c->count;
    if (count == 0)
        return NO_CARD;
    return c->items[count - 1];
}

static void GetCard(uint8_t column_index) {
    struct column *c = &columns[column_index];
    uint8_t count = c->count;
    if (count == 0)
        return;
    count--;
    c->count = count;
    if (column_index != 0 && count >= 7)
        c->items[count - 1] &= ~CLOSED_CARD;
}

static bool PutCard(uint8_t column_index, uint8_t card) {
    struct column *c = &columns[column_index];
    uint8_t count = c->count;
    if (count == COUNTOF(c->items))
        return false;
    c->items[count] = card;
    c->count = count + 1;
    return true;
}

static void RewindCards(void) {
    for (;;) {
        uint8_t card = PeekCard(1);
        if (card == NO_CARD)
            break;
        PutCard(0, card | CLOSED_CARD);
        GetCard(1);
    }
    RedrawColumn(0);
    RedrawColumn(1);
}

static void NextCard(void) {
    uint8_t card = PeekCard(0);
    if (card == NO_CARD) {
        RewindCards();
    } else {
        PutCard(1, card & ~CLOSED_CARD);
        GetCard(0);
        RedrawColumn(0);
        RedrawColumn(1);
    }
}

static void MoveCards(void) {
    if (cursor == src_cursor)
        return;

    /* Игрок не может переместить карты в первые 3 стопки */
    if (cursor < 3)
        return;

    /* Какую карту перемещаем */
    struct column *from_column = &columns[src_cursor];
    uint8_t src_index = from_column->count - 1;
    if (src_index == 0xFF)
        return;
    uint8_t card = from_column->items[src_index];
    uint8_t card_suit = card / VALUES_COUNT;
    uint8_t card_value = __div_16_mod;

    /* На какую карту переместить */
    uint8_t dest_card = PeekCard(cursor); /* Может быть NO_CARD */
    uint8_t dest_suit = dest_card / VALUES_COUNT;
    uint8_t dest_value = __div_16_mod;

    /* 4 верхние стопки */
    if (cursor < 7) {
        /* В пустую стопку можно переместить только туз */
        if (dest_card == NO_CARD) {
            if (card_value != VALUE_ACE)
                return;
        } else {
            /* На карту можно положить карту, если её стоимость на 1 меньше и масть не отличается */
            if (dest_value + 1 != card_value || dest_suit != card_suit)
                return;
        }
    } else {
        /* Нижние 7 стопок */
        for (;;) {
            /* В пустую стопку можно переместить только короля */
            if (dest_card == NO_CARD) {
                if (card_value == VALUE_KING)
                    break;
            } else {
                /* На карту можно положить карту, если её стоимость на 1 больше и цвет отличается */
                if (dest_value == card_value + 1 && dest_suit / 2 != card_suit / 2)
                    break;
            }

            /* Пробуем переместить несколько карт */
            if (src_index == 0 || src_cursor < 7)
                return;
            src_index--;
            card = from_column->items[src_index];
            if (card & CLOSED_CARD)
                return; /* Скрытую карту не перемещаем */
            card_suit = card / VALUES_COUNT;
            card_value = __div_16_mod;
        }
    }

    struct column *to_column = &columns[cursor];
    uint8_t from_coumn = src_cursor;
    uint8_t from_count = from_column->count;
    uint8_t to_count = to_column->count;
    uint8_t delta = from_count - src_index;

    if (to_column->count + delta > sizeof(to_column->items))
        return;

    from_column->count = src_index;
    RedrawColumn(from_coumn);
    src_cursor = NO_SELECTION;

    MoveAnimation(from_coumn, cursor, src_index, from_count);

    memcpy(to_column->items + to_count, from_column->items + src_index, delta);
    to_column->count += delta;

    RedrawColumn(cursor);

    if (src_index != 0) {
        from_column->items[src_index - 1] &= ~CLOSED_CARD;
        RedrawColumn(from_coumn);
    }
}

static void NewGame(void) {
    uint8_t items[VALUES_COUNT * SUIT_COUNT];

    memset(columns, 0, sizeof(columns));

    /* Помещаем все карты в колоду */
    uint8_t i;
    for (i = 0; i < COUNTOF(items); i++)
        items[i] = i | CLOSED_CARD;

    /* Перемешиваем карты */
    for (i = 0; i < COUNTOF(items) - 1; i++) {
        uint8_t j = rand() % COUNTOF(items);
        uint8_t t = items[j];
        items[j] = items[i];
        items[i] = t;
    }

    uint8_t n = COUNTOF(items);
    /* Раскладываем на 7 столбцов */
    for (i = 0; i < 7; i++) {
        columns[i + 7].count = i + 1;
        uint8_t j;
        uint8_t *p = columns[i + 7].items;
        for (j = 0; j < i; j++) {
            n--;
            *p++ = items[n];
        }
        n--;
        *p++ = items[n] & ~CLOSED_CARD;
    }

    columns[0].count = n;
    memcpy(columns[0].items, items, n);

    RedrawAllColumns();
    src_cursor = NO_SELECTION;
}

static void HideSrcCursor(void) {
    if (src_cursor == NO_SELECTION)
        return;
    if (src_cursor != cursor)
        HideCursor(src_cursor);
    src_cursor = NO_SELECTION;
}

static void Click(void) {
    /* Нажатие на верхнюю левую стопку */
    if (cursor == 0) {
        HideSrcCursor();
        NextCard();
        return;
    }

    /* Третья верхняя стопку не используется */
    if (cursor == 2)
        return;

    /* Выбор карты */
    if (src_cursor == NO_SELECTION) {
        src_cursor = cursor;
        return;
    }

    /* Перемещение карты между стопками */
    MoveCards();
    HideSrcCursor();
}

static void MoveCursor(int8_t delta) {
    if (cursor == src_cursor)
        DrawSrcCursor(cursor);
    else
        HideCursor(cursor);
    cursor += delta;
    DrawCursor(cursor);
}

void Game(void) {
    NewGame();
    for (;;) {
        switch (GetKey()) {
            case 'A':
                if (cursor == 0 || cursor == 7)
                    MoveCursor(6);
                else
                    MoveCursor(-1);
                break;
            case 'D':
                if (cursor == 6 || cursor == 13)
                    MoveCursor(-6);
                else
                    MoveCursor(1);
                break;
            case 'W':
            case 'S':
                if (cursor >= 7)
                    MoveCursor(-7);
                else
                    MoveCursor(7);
                break;
            case 'N':
                Game();
                return;
            case 'Q':
                return;
            case ' ':
                Click();
                if ((uint8_t)(columns[3].count + columns[4].count + columns[5].count + columns[6].count) >=
                    VALUES_COUNT * SUIT_COUNT) {
                    WinAnimation();
                    Game();
                    return;
                }
                break;
            case '2':
                WinAnimation();
                Game();
                return;
        }
    }
}
