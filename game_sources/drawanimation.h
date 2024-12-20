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

void BeginDrawAnimation(uint8_t x, uint8_t y, uint8_t w8, uint8_t h, void *back, void *back2);
void DrawAnimation(uint8_t x, uint8_t y, void *image);
void EndDrawAnimation(void);
void CopyImage(uint8_t w8, uint8_t h, void *dest, const void *src);
