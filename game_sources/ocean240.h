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

/* Порты ввода-вывода */
static const int PORT_MAPPER = 0xC1;
static const int PORT_MAPPER__ROM = 0;
static const int PORT_MAPPER__VIDEO = 0x10;

static const int PORT_SCROLL_X = 0xC2;
static const int PORT_SCROLL_X__DEFAULT = 7;

static const int PORT_SCROLL_Y = 0xC0;
static const int PORT_SCROLL_Y__DEFAULT = 0;

static const int PORT_COLOR = 0xE1;
static const int PORT_COLOR__COLOR_MODE = 0x40;
static const int PORT_COLOR__BLACK = 7;

/* Высота и ширина экрана */
static const int SCREEN_WIDTH_PIXELS = 256;
static const int SCREEN_WIDTH_BYTES = 256 / 8;
static const int SCREEN_HEIGHT = 256;

/* Коды клавиш Океан 240 */
static const int KEY_LEFT = 0x08;
static const int KEY_RIGHT = 0x18;
static const int KEY_UP = 0x19;
static const int KEY_DOWN = 0x1A;
