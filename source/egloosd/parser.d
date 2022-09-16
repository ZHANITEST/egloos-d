/*--------------------------------------------------
 * egloos-d / Egloos API in D
 * License: LGPL-v2.1
 * Date: 2022.9.10
 * Authors: ZHANITEST (github.com/ZHANITEST/egloos-d)
 --------------------------------------------------*/
module egloosd.parser; // Response Parser

import std.conv: to;
import std.json: JSONValue, JSONType, parseJSON;
import egloosd.cons;
import egloosd.exp;
public import egloosd.model;
import egloosd.util;

/**
 * JSON 파서 - Egloos service로 부터 받은 JSON응답을 파싱함
 */
class JsonResponseParser {
    /** 
     * 카테고리 응답데이터
     * See_Also: http://apicenter.egloos.com/manual_category.php
     */
    public static CategoryData[] category(string str) {
        CategoryData[] result;
        JSONValue j = parseJSON(str);

        // 파싱데이터가 있는 경우
        if(!j["category"].isNull && j["category"].type==JSONType.ARRAY) {
            JSONValue[] datas = j["category"].array;
            for(int i=0; i<datas.length; i++) {
                CategoryData e = CategoryData(
                    Util.utf8Decode(datas[i]["category_no"].str),
                    Util.utf8Decode(datas[i]["category_name"].str)
                );
                result ~= e;
            }
            return result;
        }
        else if(!j["error"].isNull)
            throw new NotFoundException(Consts.Message.NOT_FOUND);            // 응답 값의 상태가  에러인 경우
        throw new WrongJsonFormatException(Consts.Message.WRONG_JSON_FORMAT); // 그 외는 사전정의되지 않은 JSON 포맷에러
    }

    /** 
     * 포스트 목록
     * See_Also: http://apicenter.egloos.com/manual_post.php
     */
    public static PostListItemData[] postList(string str) {
        PostListItemData[] result;
        JSONValue j = parseJSON(str);

        // 파싱데이터가 있는 경우
        if(!j["post"].isNull && j["post"].type==JSONType.ARRAY) {
            JSONValue[] arr = j["post"].array;
            for(int i=0; i<arr.length; i++) {
                if(arr[i].type==JSONType.NULL || arr[i].type!=JSONType.object)
                    throw new WrongJsonFormatException(Consts.Message.WRONG_JSON_FORMAT);
                JSONValue item = arr[i].object;
                PostListItemData e = PostListItemData(
                    Util.utf8Decode(getStringWithNullSafety(item, "post_url")),
                    Util.utf8Decode(getStringWithNullSafety(item, "post_no")),
                    Util.utf8Decode(getStringWithNullSafety(item, "post_title")),
                    Util.utf8Decode(getStringWithNullSafety(item, "post_thumb")),
                    Util.utf8Decode(getStringWithNullSafety(item, "category_name")),
                    Util.utf8Decode(getStringWithNullSafety(item, "comment_count")),
                    Util.utf8Decode(getStringWithNullSafety(item, "post_hidden")),
                    Util.utf8Decode(getStringWithNullSafety(item, "post_date_created"))
                );
                result ~= e;
            }
            return result;
        }
        else if(!j["error"].isNull)
            throw new NotFoundException(Consts.Message.NOT_FOUND);            // 응답 값의 상태가  에러인 경우
        throw new WrongJsonFormatException(Consts.Message.WRONG_JSON_FORMAT); // 그 외는 사전정의되지 않은 JSON 포맷에러
        
    }

    /** 
     * 특정포스트 읽기
     * See_Also: http://apicenter.egloos.com/manual_category.php
     */
    public static PostData post(string str) {
        JSONValue j = parseJSON(str);
        if(j["post"].type() == JSONType.object) {
            JSONValue v =  j["post"].object;
            PostData result = PostData(
                Util.utf8Decode(getStringWithNullSafety(v, "post_title")),
                Util.utf8Decode(getStringWithNullSafety(v, "post_no")),
                Util.utf8Decode(getStringWithNullSafety(v, "post_content")),
                Util.utf8Decode(getStringWithNullSafety(v, "category_name")),
                Util.utf8Decode(getStringWithNullSafety(v, "category_no")),
                Util.utf8Decode(getStringWithNullSafety(v, "post_nick")),
                Util.utf8Decode(getStringWithNullSafety(v, "comment_count")),
                Util.utf8Decode(getStringWithNullSafety(v, "trackback_count")),
                Util.utf8Decode(getStringWithNullSafety(v, "post_hidden")),
                Util.utf8Decode(getStringWithNullSafety(v, "comment_enabled")),
                Util.utf8Decode(getStringWithNullSafety(v, "trackback_enabled")),
                Util.utf8Decode(getStringWithNullSafety(v, "post_date_created")),
                Util.utf8Decode(getStringWithNullSafety(v, "post_date_modified")),
                Util.utf8Decode(getStringWithNullSafety(v, "post_tags")) 
            );
            return result;
        }
        else if(!j["error"].isNull)
            throw new NotFoundException(Consts.Message.NOT_FOUND);            // 응답 값의 상태가  에러인 경우
        throw new WrongJsonFormatException(Consts.Message.WRONG_JSON_FORMAT); // 그 외는 사전정의되지 않은 JSON 포맷에러
    }

    /**
     * 해당 키로 str 취득
     * Params: 
     *  v = JSONValue
     *  key = 키 값
     */
    private static getStringWithNullSafety(JSONValue v, string key) {
        JSONType thisType = v[key].type();
        switch(thisType) {
        case JSONType.NULL:
            return "";
        case JSONType.string:
            return v[key].str;
        case JSONType.integer:
            return v[key].integer.to!string;
        default: throw new SystemException("해당 타입은 str, null 혹은 interger가 아닙니다 ["~key~"]");
        }
    }
}