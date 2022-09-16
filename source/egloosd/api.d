/*--------------------------------------------------
 * egloos-d / Egloos API in D
 * License: LGPL-v2.1
 * Date: 2022.9.10
 * Authors: ZHANITEST (github.com/ZHANITEST/egloos-d)
 --------------------------------------------------*/
module egloosd.api; // Egloos API

import std.array: appender, split;
import std.conv: to;
import std.datetime: Duration, dur;
import std.file: isFile, exists;
import std.format: format;
import std.stdio: writef;
import std.string: trim=strip, indexOf;
import std.net.curl;
import egloosd.cons;
import egloosd.exp;
public import egloosd.model;
import egloosd.parser;
import egloosd.util;

/** 
 * Egloos Open API
 * See_Also: http://apicenter.egloos.com
 * Examples:
 * --------------------------------------------------
 * EgloosAPI client = new EgloosAPI("help"); // Only input doman name
 * assert(client.category().length > 0);
 * --------------------------------------------------
 */
class EgloosAPI {
    /// 서브도메인 -  예 `example.egloos.com 의 도메인은 example 임`
    private string _blogDomain = "";
    @property string blogDomain() {
        return this._blogDomain = "";
    }
    /*출력포맷 - xml 또는 json
    private string _format = "";
    @property void format(string format) {
        this._format = format;
    }
    @property string format() {
        return this._format;
    }*/

    /**
     * 생성자
     * Params:
     *  blogDomain = 서브도메인 - 예 `example.egloos.com의 도메인은 example 임`
     */
    this(string blogDomain) { /*, string format*/
        this._blogDomain = blogDomain;
        //this._format = format;
    }

    /**
     * 카테고리 목록 취득
     * Returns: 카테고리 응답 데이터
     * See_Also: http://apicenter.egloos.com/manual_category.php
     * Throws: EgloosApiException
     */
    CategoryData[] category() {
        string url = Consts.API.GET_CATEGORY.format(_blogDomain);
        EzGet client = new EzGet(url);
        string html = client.perform();
        return JsonResponseParser.category(html);
    }

    /**
     * 포스트 목록
     * Params: 
     *  page = 페이지번호[page] Optional(디폴트=1)
     *  cateNo = 카테고리번호[category_no] Optional 	 
     * Returns: 글목록 데이터
     * See_Also: http://apicenter.egloos.com/manual_post.php
     */
    PostListItemData[] postList(string page, string cateNo) {
        string url = Consts.API.GET_POST_LIST.format(_blogDomain,
            Util.onlyNumeric(page),
            Util.onlyNumeric(cateNo));
        EzGet client = new EzGet(url);
        string html = client.perform();
        return JsonResponseParser.postList(html);
    }

    /**
     * 특정포스트 읽기
     * Params: 
     *   postNo = 포스트 번호(post_no) 
     * Returns: 포스트 데이터
     * See_Also: http://apicenter.egloos.com/manual_post.php
     */
    PostData post(string postNo) {
        string url = Consts.API.GET_POST_READ.format(_blogDomain, postNo);
        EzGet client = new EzGet(url);
        string html = client.perform();
        return JsonResponseParser.post(html);
    }

    // 클라이언트 통합테스트 - 목업데이터로 할려다가 그냥 리얼로 함
    // - 이글루스 서버 문제로 Timeout이 많이 발생하는 점 참고
    unittest {
        auto client = new EgloosAPI("help"); // 이글루스 도움말 (https://help.egloos.com)
        
        // category 메소드 테스트
        CategoryData[] cates = client.category();
        assert(cates.length > 0);

        // post 메소드 테스트
        PostData post = client.post("2922");
        assert(post.title == "이글루스 블로깅 API 란?");

        // postList 메소드
        // - 페이지 1장 / 카테고리번호 3번(이글루스란?)
        // - 예상 값: 글 개수 6개
        PostListItemData[] items = client.postList("1", "3");
        assert(items.length==6);
    }
}

/**
 * GET용 Low-Level HTTP 클라이언트 래퍼
 */
class EzGet {
    private int status = 0;
    private string url = "";
    private string html = "";
    private HTTP client;
    private immutable(Duration) timeout = Consts.System.TIMEOUT_DURATION;
    
    /**
     * HTTP Low-Level 기본 클라이언트 취득
     * Params: url  = URL경로
     */
    this(string url) {
        this.url = url;
        this.client = HTTP(this.url);
        bool http = false;
        bool https = false;
        if(indexOf(this.url, "https://")==0)
            https = true;
        else if(indexOf(this.url, "http://")==0)
            http = true;
        if(!https && !http)
            throw new SystemException(Consts.Message.WRONG_URL_FORMAT.format(url)); // HTTPS, HTTP 형태의 스키마가 아니면
        if(https) {
            if(!exists(Consts.System.CURL_CERT_PATH) || !isFile(Consts.System.CURL_CERT_PATH))
                throw new SystemException(Consts.Message.PLEASE_DOWNLOAD_CERT); // 존재하지 않거나 파일이 없다면...
            this.client.caInfo(Consts.System.CURL_CERT_PATH);
        }
            
        this.client.addRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8");
        this.client.addRequestHeader("Accept-Charset",  /*"utf-8, iso-8859-1;q=0.5"*/ "ko-KR,ko;q=0.8,en-US;q=0.5,en;q=0.3");
        this.client.addRequestHeader("Accept-Language", "ko-KR,ko;q=0.8,en-US;q=0.5,en;q=0.3");

        int indexForSplit = https ? 8:7;
        this.client.addRequestHeader("Host", url[indexForSplit..$].split("/")[0]);  // Set Header
        this.client.dataTimeout = this.timeout;
        this.client.onReceive = (ubyte[] data) {
            this.html = trim(cast(string)data);
            if(html.length <= 0)
                throw new EmptyResponseException(Consts.Message.GET_EMPTY_RESPONSE.format(url));
            this.html = Util.utf8Decode(this.html);
            this.status = this.client.statusLine().code;
            return data.length;
        };
    }

    /** Request */ 
    public string perform() {
        version(unittest) {
            writef("[%s] GET@REQ - %s...\n", Util.sysdate, this.url);
        }
        try {
            this.client.perform();
        } catch(std.net.curl.CurlTimeoutException e) {
            throw new NetworkTimeoutException(Consts.Message.TIMEOUT.format(Util.sysdate(), this.url));
        } catch(std.net.curl.CurlException e) {
            if(Util.isConnectionErrorMessage(e.message))
                throw new NetworkConnectionException(Consts.Message.NETWORK_CONNECTION.format(Util.sysdate(), this.url));
            throw e;
        }
        version(unittest) {
            writef("[%s] GET@RES - %s (%d)\n", Util.sysdate, this.url, this.status);
        }
        return this.html;
    }

    unittest {
        EzGet testClient = new EzGet("https://api.egloos.com/request_token");
        testClient.client.verbose(true);
        string resHtml = testClient.perform();
        assert(testClient.status==500, testClient.status.to!string);
    }
}