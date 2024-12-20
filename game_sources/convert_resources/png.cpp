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

#include "png.h"
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <stdexcept>

void Png::load(const char *file_name) {
    if (loaded)
        throw std::runtime_error("Image already loaded");

    FILE *fp = fopen(file_name, "rb");
    if (!fp)
        throw std::runtime_error("Can't open file " + std::string(file_name));

    unsigned char header[8];
    if (fread(header, 1, 8, fp) != 8) {
        fclose(fp);
        throw std::runtime_error("Can't read file " + std::string(file_name));
    }

    if (png_sig_cmp(header, 0, 8)) {
        fclose(fp);
        throw std::runtime_error("File " + std::string(file_name) + " is not recognized as a PNG file");
    }

    // TODO: Надо ли освобождать память занятую объектом?
    png_structp png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png_ptr) {
        fclose(fp);
        throw std::runtime_error("png_create_read_struct failed");
    }

    // TODO: Надо ли освобождать память занятую объектом?
    png_infop info_ptr = png_create_info_struct(png_ptr);
    if (!info_ptr) {
        fclose(fp);
        throw std::runtime_error("png_create_info_struct failed");
    }

    if (setjmp(png_jmpbuf(png_ptr))) {
        fclose(fp);
        throw std::runtime_error("png_init_io failed");
    }

    png_init_io(png_ptr, fp);          // no return
    png_set_sig_bytes(png_ptr, 8);     // no return
    png_read_info(png_ptr, info_ptr);  // no return

    width = png_get_image_width(png_ptr, info_ptr);
    height = png_get_image_height(png_ptr, info_ptr);
    color_type = png_get_color_type(png_ptr, info_ptr);
    bit_depth = png_get_bit_depth(png_ptr, info_ptr);
    number_of_passes = png_set_interlace_handling(png_ptr);
    png_read_update_info(png_ptr, info_ptr);  // no return

    if (setjmp(png_jmpbuf(png_ptr))) {
        fclose(fp);
        throw std::runtime_error("png_get_rowbytes failed");
    }

    png_size_t row_size = png_get_rowbytes(png_ptr, info_ptr);

    size_t s1 = sizeof(png_bytep) * height;
    row_pointers = (png_bytep *)malloc(s1 + row_size * height);
    if (!row_pointers) {
        fclose(fp);
        throw std::runtime_error("Out of memory");
    }

    for (unsigned y = 0; y < height; y++)
        row_pointers[y] = (uint8_t *)row_pointers + s1 + row_size * y;

    png_read_image(png_ptr, row_pointers);  // no return

    fclose(fp);

    if (color_type != PNG_COLOR_TYPE_RGB && color_type != PNG_COLOR_TYPE_RGBA)
        throw std::runtime_error("Unsupported color type " + std::to_string(color_type));

    loaded = true;
}

void Png::save(const char *file_name) const {
    if (!loaded)
        throw std::runtime_error("Image not loaded");

    FILE *fp = fopen(file_name, "wb");
    if (!fp)
        throw std::runtime_error("Can't create file " + std::string(file_name));

    //! Надо ли освобождать память занятую объектом?
    png_structp png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
    if (!png_ptr) {
        fclose(fp);
        throw std::runtime_error("png_create_write_struct failed");
    }

    //! Надо ли освобождать память занятую объектом?
    png_infop info_ptr = png_create_info_struct(png_ptr);
    if (!info_ptr) {
        fclose(fp);
        throw std::runtime_error("png_create_info_struct failed");
    }

    if (setjmp(png_jmpbuf(png_ptr))) {
        fclose(fp);
        throw std::runtime_error("png_init_io failed");
    }

    png_init_io(png_ptr, fp);  // no return

    if (setjmp(png_jmpbuf(png_ptr))) {
        fclose(fp);
        throw std::runtime_error("png_write_info failed");
    }

    png_set_IHDR(png_ptr, info_ptr, width, height, bit_depth, color_type, PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_BASE,
                 PNG_FILTER_TYPE_BASE);  // no return

    png_write_info(png_ptr, info_ptr);  // no return

    if (setjmp(png_jmpbuf(png_ptr))) {
        fclose(fp);
        throw std::runtime_error("png_write_image failed");
    }

    png_write_image(png_ptr, row_pointers);  // no return

    if (setjmp(png_jmpbuf(png_ptr))) {
        fclose(fp);
        throw std::runtime_error("png_write_end failed");
    }

    png_write_end(png_ptr, NULL);  // no return;

    fclose(fp);
}

uint32_t Png::getPixel(unsigned x, unsigned y) const {
    if (x >= width || y >= height)
        return 0xFF00FF;
    switch (color_type) {
        case PNG_COLOR_TYPE_RGB:
            return (*(uint32_t *)&row_pointers[y][x * 3]) & 0xFFFFFF;
        case PNG_COLOR_TYPE_RGBA:
            return (*(uint32_t *)&row_pointers[y][x * 4]) & 0xFFFFFF;
    }
    return 0;
}

void Png::setPixel(unsigned x, unsigned y, uint32_t c) {
    uint8_t *a;
    if (x >= width || y >= height)
        return;
    switch (color_type) {
        case PNG_COLOR_TYPE_RGB:
            a = &row_pointers[y][x * 3];
            *(uint16_t *)a = c;
            *(uint8_t *)(a + 2) = c >> 16;
            break;
        case PNG_COLOR_TYPE_RGBA:
            *(uint32_t *)&row_pointers[y][x * 4] = c;
            break;
    }
}

Png::~Png() {
    free(row_pointers);
}
