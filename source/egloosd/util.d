/*--------------------------------------------------
 * egloos-d / Egloos API in D
 * License: LGPL-v2.1
 * Date: 2022.9.10
 * Authors: ZHANITEST (github.com/ZHANITEST/egloos-d)
 --------------------------------------------------*/
module egloosd.util; // Util's

import std.array: appender;
import std.datetime: Clock;
import std.string: indexOf;

/**
 * 유틸리티 모음
 */
class Util {
    /**
     * 유니코드 디코딩 유틸리티 함수 - D언어의 쓰레기스러운 유니코드 처리방식 때문에 따로 필요
     * Params: ori = \u 엔티티 포함한 문자열
     * Returns: 디코딩된 string
    */
    public static string utf8Decode(string ori) {
        import std.uni;
        string to;
        auto x = Grapheme(ori);
        for(int i=0; i<x.length; i++) {
            to ~= x[i];
        }
        return to;
    }

    /// 현재시간 ISO포맷 문자열로 취득
    public static string sysdate() {
        return Clock.currTime().toISOExtString();
    }

    /// cURL Exception 메세지 내용을 확인해 커넥션 에러인 지 체크
    public static bool isConnectionErrorMessage(const(char)[] message) {
        return indexOf(message, "Couldn't resolve host name") >= 0;
    }

    /** 숫자만 취득
     *Params: ori = 원 문자열
     *Returns: 원 문자열에서 0~9만 추출된 문자열 */
    public static string onlyNumeric(string ori) {
        auto bf = appender!string;
        foreach(char c; ori.dup) {
            int ascii = cast(int)c;
            if(ascii>=48 && ascii<=57) //if(ascii>=32 && ascii<=41)
                bf.put(c);
        }
        return bf.data;
    }
}

// 유틸클래스 테스트
unittest {
    assert(Util.utf8Decode("\uC0F4\uD478\uC758 \uC694\uC815")=="샴푸의 요정");
}