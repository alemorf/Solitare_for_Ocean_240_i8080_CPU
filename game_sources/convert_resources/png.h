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

#include <png.h>
#include <stdint.h>

class Png {
protected:
    bool loaded = false;
    uint32_t width = 0;
    uint32_t height = 0;
    uint8_t color_type = 0;
    uint8_t bit_depth = 0;
    int number_of_passes = 0;
    png_bytep *row_pointers = nullptr;

public:
    void load(const char *file_name);
    void save(const char *file_name) const;
    uint32_t getPixel(unsigned x, unsigned y) const;
    void setPixel(unsigned x, unsigned y, uint32_t c);
    inline uint32_t getWidth() const {
        return width;
    };
    inline uint32_t getHeight() const {
        return height;
    };
    ~Png();
};
