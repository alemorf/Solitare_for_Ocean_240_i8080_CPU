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
#include "fs_tools.h"
#include <algorithm>
#include <vector>
#include <map>
#include <string.h>
#include <string>
#include <iostream>
#include <filesystem>
#include <algorithm>
#include <assert.h>

static Png png;
static std::string hFile;
static std::string cFile;

static std::string ToUpper(std::string str)
{
    std::transform(str.begin(), str.end(), str.begin(), ::toupper);
    return str;
}

static void MakeCArray(const std::vector<uint8_t> &data, std::string &result) {
    static const char abc[] = "0123456789ABCDEF";
    static const unsigned CHARS_IN_LINE = 16;

    const size_t offset = result.size();
    result.resize(offset + 6 * data.size() + 4 * ((data.size() + CHARS_IN_LINE - 1) / CHARS_IN_LINE));

    const uint8_t *s = data.data();
    const uint8_t *s_end = s + data.size();
    char *d = result.data() + offset;
    while (s != s_end) {
        *d++ = ' ';
        *d++ = ' ';

        *d++ = ' ';
        for (unsigned i = 0; i < CHARS_IN_LINE && s != s_end; i++) {
            *d++ = ' ';
            *d++ = '0';
            *d++ = 'x';
            *d++ = abc[*s >> 4];
            *d++ = abc[*s & 0x0F];
            *d++ = ',';
            s++;
        }
        *d++ = '\n';
    }
    assert(d == result.data() + result.size());
}

static void WriteArray(const std::string &id, const std::vector<uint8_t> &data) {
    hFile += "extern uint8_t " + id + "[" + std::to_string(data.size()) + "];\n";
    cFile += "\nuint8_t " + id + "[" + std::to_string(data.size()) + "] = {\n";
    MakeCArray(data, cFile);
    cFile += "};\n";
}

static const uint32_t palette[4] = {
    0xFFFFFF,
    0x00FF00,
    0x000000,
    0x0000FF,
};

static uint32_t ConvertColor(const uint32_t palette[4], uint32_t color) {
    assert(palette != nullptr);
    uint32_t bestIndex = 0;
    uint32_t bestDist = UINT32_MAX;
    for (uint8_t i = 0; i < 4; i++) {
        int32_t dr = int32_t(palette[i] & 0xFF) - int32_t(color & 0xFF);
        int32_t dg = int32_t((palette[i] >> 8) & 0xFF) - int32_t((color >> 8) & 0xFF);
        int32_t db = int32_t((palette[i] >> 16) & 0xFF) - int32_t((color >> 16) & 0xFF);
        int32_t dist = dr * dr + dg * dg + db * db;
        if (dist < bestDist) {
            bestDist = dist;
            bestIndex = i;
        }
    }
    return bestIndex;
}

static void ConvertLine(unsigned x, unsigned y, uint8_t &out_a, uint8_t &out_b) {
    out_a = 0;
    out_b = 0;
    for (uint32_t ix = 0; ix < 8; ix++) {
        uint32_t color = png.getPixel(x + ix, y);
        const int c = ConvertColor(palette, color);
        if (c & 1)
            out_a |= (1 << ix);
        if (c & 2)
            out_b |= (1 << ix);
    }
}

static void ConvertImage(unsigned x, unsigned y, unsigned width, unsigned height, std::vector<uint8_t> &data) {
    assert(width % 16 == 0);

    const uint32_t bpl = width / 8;
    if (bpl == 0)
        return;

    const size_t offset = data.size();
    data.resize(offset + 1 + bpl * 2 * height);
    uint8_t *result = &data[offset];

    *result++ = bpl / 2;

    for (uint32_t iy = 0; iy < height; iy++) {
        uint32_t xx = x;
        for (uint32_t ix = 0; ix < bpl; ix++) {
            ConvertLine(xx, y, result[0], result[1]);
            xx += 8;
            result += 2;
        }
        y++;
    }

    assert(result == data.data() + data.size());
}

static void WriteImage(const char *id, unsigned x, unsigned y, unsigned width, unsigned height) {
    std::vector<uint8_t> data;
    ConvertImage(x, y, width, height, data);
    WriteArray(id, data);
    std::string macro = ToUpper(id);
    hFile += "static const int " + macro + "_WIDTH = " + std::to_string(width) + ";\n";
    hFile += "static const int " + macro + "_HEIGHT = " + std::to_string(height) + ";\n";
}

int main(void) {
    try {
        png.load("resources.png");

        hFile = "#pragma once\n\n#include <stdint.h>\n\n";
        cFile = "#include \"resources.h\"\n";

        static const unsigned CARD_WIDTH = 32;
        static const unsigned CARD_HEIGHT = 48;
        static const unsigned CURSOR_HEIGHT = 8;

        WriteImage("image_card_back", 0, 0, CARD_WIDTH, CARD_HEIGHT);
        WriteImage("image_background", 0, CARD_HEIGHT, CARD_WIDTH, CARD_HEIGHT);
        WriteImage("image_rect", 0, CARD_HEIGHT * 2, CARD_WIDTH, CARD_HEIGHT);
        WriteImage("image_cursor", 0, CARD_HEIGHT * 3, CARD_WIDTH, CURSOR_HEIGHT);
        WriteImage("image_src_cursor", 0, CARD_HEIGHT * 3 + CURSOR_HEIGHT, CARD_WIDTH, CURSOR_HEIGHT);
        WriteImage("image_title", 0, 192, 256, 8);

        static const unsigned SUIT_COUNT = 4;
        static const unsigned VALUES_COUNT = 13;

        std::vector<uint8_t> image_cards;
        for (uint32_t y = 0; y < SUIT_COUNT; y++)
            for (uint32_t x = 0; x < VALUES_COUNT; x++)
                ConvertImage(CARD_WIDTH + CARD_WIDTH * x, CARD_HEIGHT * y, CARD_WIDTH, CARD_HEIGHT, image_cards);
        WriteArray("image_cards", image_cards);
        hFile += "static const int IMAGE_CARD_HEIGHT = " + std::to_string(CARD_HEIGHT) + ";\n";
        hFile += "static const int IMAGE_CARD_SIZEOF = " + std::to_string(CARD_WIDTH / 8 * CARD_HEIGHT * 2 + 1) + ";\n";

        FsTools::SaveFile("resources.c", cFile.data(), cFile.size());
        FsTools::SaveFile("resources.h", hFile.data(), hFile.size());
    } catch (const std::exception &e) {
        std::cerr << e.what() << std::endl;
        return 1;
    }
    return 0;
}
