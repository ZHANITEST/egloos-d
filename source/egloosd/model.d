/*--------------------------------------------------
 * egloos-d / Egloos API in D
 * License: LGPL-v2.1
 * Date: 2022.9.10
 * Authors: ZHANITEST (github.com/ZHANITEST/egloos-d)
 --------------------------------------------------*/
module egloosd.model; // Data type's

/**
 * 카테고리 데이터
 * See_Also: http://apicenter.egloos.com/manual_category.php
 */
struct CategoryData {
    /// 카테고리번호 - 예 `7`
    private string _no;
    /// 카테고리번호 - 예 `7`
    @property string no() {
        return this._no;
    }

    /// 카테고리명 - 예 `일상`
    private string _name;
    /// 카테고리명 - 예 `일상`
    @property string name() {
        return this._name;
    }

    /** 
     * 생성자
     * Params:
     *  no = 카테고리번호[category_no]  - 예 `7`
     *  name = 카테고리명[category_name] - 예 `일상`
     */
    this(string no, string name) {
        this._no = no;
        this._name = name;
    }
}


/** 
 * 글 데이터
 * See_Also: http://apicenter.egloos.com/manual_post.php
 */
struct PostData {
    private string _title; /// 제목[post_title]
    @property string title() {
        return this._title;
    }
    private string _no; /// 포스트 번호[post_no]
    @property string no() {
        return this._no;
    }
    private string _ctnt; /// 본문[post_content]
    @property string content() {
        return this._ctnt;
    }
    private string _cateName; /// 카테고리명[category_name]
    @property string categoryName() {
        return this._cateName;
    }
    private string _cateNo; /// 카테고리번호[category_no]
    @property string categoryNo() {
        return this._cateNo;
    }
    private string _nick; /// 작성자[post_nick] 닉네임
    @property string nick() {
        return this._nick;
    }
    private string _comtCnt; /// 덧글 개수[comment_count]
    @property string commentCount() {
        return this._comtCnt;
    }
    private string _trbkCnt; /// 트랙백 개수[trackback_count]
    @property string trackbackCount() {
        return this._trbkCnt;
    }
    private string _isHidden; /// 비공개여부[post_hidden] 0=공개, 1=비공개
    @property string hidden() {
        return this._isHidden;
    }
    private string _comtEnab; /// 덧글허용여부[comment_enabled] 0=비허용, 1=허용
    @property string commentEnable() {
        return this._comtEnab;
    }
    private string _trbkEnab; /// 트랙백허용여부[trackback_enabled] 0=비허용, 1=허용
    @property string trackbackEnabled() {
        return this._trbkEnab;
    }
    private string _cretDate; /// 글작성시간[post_date_created] 예 `2010-03-10 13:41:52`
    @property string dateCreated() {
        return this._cretDate;
    }
    private string _mdfyDate; /// 글수정일[post_date_modified] 예 `2010-03-10 13:41:52`
    @property string dateModified() {
        return this._mdfyDate;
    }
    private string _tags; /// 태그목록[post_tags] 콤마구분자로 구분, 예 `태그1,태그2,태그3`
    @property string tags() {
        return this._tags;
    }

    /** 
     * 생성자
     * Params:
     *  title = 제목[post_title]
     *  no = 포스트 번호[post_no]
     *  content = 본문[post_content]
     *  cateName = 카테고리명[category_name]
     *  cateNo = 카테고리번호[category_no]
     *  nick = 작성자[post_nick] 닉네임
     *  comtCnt = 덧글 개수[comment_count]
     *  trbkCnt = 트랙백 개수[trackback_count]
     *  isHidden = 비공개여부[post_hidden] 0=공개, 1=비공개
     *  comtEnab = 덧글허용여부[comment_enabled] 0=비허용, 1=허용
     *  trbkEnab = 트랙백허용여부[trackback_enabled] 0=비허용, 1=허용
     *  cretDate = 글작성시간[post_date_created] 예 `2010-03-10 13:41:52`
     *  mdfyDate = 글수정일[post_date_modified] 예 `2010-03-10 13:41:52`
     *  tags = 태그목록[post_tags] 콤마구분자로 구분, 예 `태그1,태그2,태그3`
     */
    this(string title, string no, string content, string cateName, string cateNo, string nick, string comtCnt,
        string trbkCnt, string isHidden, string comtEnab, string trbkEnab, string cretDate, string mdfyDate,
        string tags) {
        this._title = title;
        this._no = no;
        this._ctnt = content;
        this._cateName = cateName;
        this._cateNo = cateNo;
        this._nick = nick;
        this._comtCnt = comtCnt;
        this._trbkCnt = trbkCnt;
        this._isHidden = isHidden;
        this._comtEnab = comtEnab;
        this._trbkEnab = trbkEnab;
        this._cretDate = cretDate;
        this._mdfyDate = mdfyDate;
        this._tags = tags;
    }
}

/**
 * 포스트 목록 데이터
 * See_Also: http://apicenter.egloos.com/manual_post.php
 */
struct PostListData {
    private PostListItemData[] _items; /// 포스트 목록 아이템
    @property PostListItemData[] item() {
        return this._items;
    }
    private uint _lastPage; /// 마지막페이지 수
    @property uint lastPage() {
        return this._lastPage;
    }

    /** 
     * 생성자
     * Params:
     * items = 포스트목록아이템 배열
     * lastPage = 마지막페이지
     */
    this(PostListItemData[] items, uint lastPage) {
        this._items = items;
        this._lastPage = lastPage;
    }
}

/**
 * 포스트 목록 아이템 데이터
 * See_Also: http://apicenter.egloos.com/manual_post.php
 */
struct PostListItemData  {
    private string _url; /// 포스트 주소[post_url] 예 `http://example.egloos.com/12345`
    @property string url() {
        return this._url;
    }
    private string _no; /// 포스트 번호[post_no]
    @property string no() {
        return this._no;
    }
    private string _title; /// 제목[post_title]
    @property string title() {
        return this._title;
    }
    private string _thumb; /// 대표썸네일[post_thumb]
    @property string thumb() {
        return this._thumb;
    }
    private string _cateName; /// 카테고리명[category_name]
    @property string categoryName() {
        return this._cateName;
    }
    private string _comtCtn; /// 덧글수[comment_count]
    @property string commentCount() {
        return this._comtCtn;
    }
    private string _isHidden; /// 비공개여부[post_hidden] 0:공개,1:비공개
    @property string hidden() {
        return this._isHidden;
    }
    private string _cretDate; /// 글작성시간[post_date_created] 예 `2010-03-10 13:41:52`
    @property string dateCreated() {
        return this._cretDate;
    }

    /** 
     * 생성자
     * Params:
     *  url = 포스트 주소[post_url] 예 http://example.egloos.com/12345
     *  no = 포스트 번호[post_no]
     *  title = 제목[post_title]
     *  thumb = 대표썸네일[post_thumb]
     *  cateName = 카테고리명[category_name]
     *  comtCtn = 덧글수[comment_count]
     *  isHidden = 비공개여부[post_hidden] 0:공개,1:비공개
     *  cretDate = 글작성시간[post_date_created] 예 `2010-03-10 13:41:52`
     */
    this(string url, string no, string title, string thumb, string cateName, string comtCtn,
        string isHidden, string cretDate) {
        this._url = url;
        this._no = no;
        this._title = title;
        this._thumb = thumb;
        this._cateName = cateName;
        this._comtCtn = comtCtn;
        this._isHidden = isHidden;
        this._cretDate = cretDate;
    }
}

/** 
 * 에러 데이터 - 테스트해보니 어차피 200코드에 응답내용도 별 거 없어서 파싱 안해도 될 듯.
struct ErrorData {
    string category;
    string message;
} */