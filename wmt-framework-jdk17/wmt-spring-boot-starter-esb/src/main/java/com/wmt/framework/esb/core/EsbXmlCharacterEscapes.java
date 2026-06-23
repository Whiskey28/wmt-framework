package com.wmt.framework.esb.core;

import com.fasterxml.jackson.core.io.CharacterEscapes;
import com.fasterxml.jackson.core.io.SerializedString;

/**
 * 按行内 ESB 规范转义非法 XML 字符。
 */
class EsbXmlCharacterEscapes extends CharacterEscapes {

    private final int[] asciiEscapes;

    EsbXmlCharacterEscapes() {
        int[] escapes = standardAsciiEscapesForJSON();
        escapes['&'] = CharacterEscapes.ESCAPE_CUSTOM;
        escapes['<'] = CharacterEscapes.ESCAPE_CUSTOM;
        escapes['>'] = CharacterEscapes.ESCAPE_CUSTOM;
        escapes['\"'] = CharacterEscapes.ESCAPE_CUSTOM;
        escapes['\''] = CharacterEscapes.ESCAPE_CUSTOM;
        this.asciiEscapes = escapes;
    }

    @Override
    public int[] getEscapeCodesForAscii() {
        return asciiEscapes;
    }

    @Override
    public SerializedString getEscapeSequence(int ch) {
        return switch (ch) {
            case '&' -> new SerializedString("&amp;");
            case '<' -> new SerializedString("&lt;");
            case '>' -> new SerializedString("&gt;");
            case '\"' -> new SerializedString("&quot;");
            case '\'' -> new SerializedString("&apos;");
            default -> null;
        };
    }

}
