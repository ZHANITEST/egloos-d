/*--------------------------------------------------
 * egloos-d / Egloos API in D
 * License: LGPL-v2.1
 * Date: 2022.9.10
 * Authors: ZHANITEST (github.com/ZHANITEST/egloos-d)
 --------------------------------------------------*/
module egloosd.cons; // Const's

import std.datetime: dur;

/// Defined Const's
public static class Consts {
    /// API
    public static class API {
        /// API URL - 카테고리 목록 [$1=blog_domain]
        public static immutable GET_CATEGORY = "https://api.egloos.com/%s/category.json";
        /// API URL - 포스트 목록 [$1=blog_domain, $2=page, $3=category_no]
        public static immutable GET_POST_LIST = "https://api.egloos.com/%s/post.json?page=%s&category_no=%s";
        /// API URL - 특정포스트 읽기 [$1=blog_domain, $2=post_no]
        public static immutable GET_POST_READ = "https://api.egloos.com/%s/post/%s.json";
    }

    /// System var's
    public static class System {
        /// 통신 타임아웃 듀레이션
        public static immutable TIMEOUT_DURATION = dur!"seconds"(3);
        /// cURL 인증서 경로
        public static immutable CURL_CERT_PATH = "./curl-ca-bundle.crt";
    }

    /// Exception message's
    public static class Message {
        /// `Coul'd find *.crt file. Please download it from here=>[https://curl.se/download.html#Win64] and put in here=>[CURL_CERT_PATH]`
        public static immutable PLEASE_DOWNLOAD_CERT =
        "Coul'd find *.crt file. Please download it from here=>[https://curl.se/download.html#Win64] and put in here=>["~System.CURL_CERT_PATH~"]";        
        /// `Request Timeout` [$1=date, $2=url]
        public static immutable TIMEOUT = "Request Timeout [%s|%s]";
        /// `Network connection's error` [$1=date, $2=url]
        public static immutable NETWORK_CONNECTION = "Network connection's error [%s|%s]";
        /// `Get a responsed but content is empty` [$1=url]
        public static immutable GET_EMPTY_RESPONSE = "Get a responsed but content is empty [$s]";
        /// `Not Found` [$1=url]
        public static immutable NOT_FOUND = "Not Found [$s]";
        /// `Wrong url format` [$1=url]
        public static immutable WRONG_URL_FORMAT = "Url format is wrong [%s]";
        /// `Wrong json foramt. Please contact to "http://www.egloos.com/support.php"`
        public static immutable WRONG_JSON_FORMAT = "Wrong json foramt. Please contact to `http://www.egloos.com/support.php`";
    }
}