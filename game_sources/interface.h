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

void RedrawColumn(uint8_t column_index);
void RedrawAllColumns(void);
void DrawCursor(uint8_t column_index);
void DrawSrcCursor(uint8_t column_index);
void HideCursor(uint8_t column_index);
void MoveAnimation(uint8_t from_column, uint8_t to_column, uint8_t start, uint8_t height);
void WinAnimation(void);
uint8_t GetKey(void);
