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

#pragma once

#include <stdint.h>

struct column {
    uint8_t count;
    uint8_t items[24];
};

extern struct column columns[14];

/* Выбранная колонка */
extern uint8_t cursor;

/* Кол-во карт одной стоимости и кол-во мастей */
static const uint8_t VALUES_COUNT = 13;
static const uint8_t SUIT_COUNT = 4;

/* Закрытая (перевернутая) карта */
static const uint8_t CLOSED_CARD = 0x80;

void Game(void);
