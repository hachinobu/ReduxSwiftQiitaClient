//
//  QiitaAPIActions.swift
//  ReduxSwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2016/05/29.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import APIKit
import Result
import ReSwift

struct FetchAction: Action {
    let isFetch: Bool
}

struct RefreshAction: Action {
    
    static let type = "RefreshAction"
    let isRefresh: Bool
    let articleVMList: [ArticleVM]?
    let pageNumber: Int
    
    init(_ isRefresh: Bool, articleVMList: [ArticleVM]? = [], pageNumber: Int = 1) {
        self.isRefresh = isRefresh
        self.articleVMList = articleVMList
        self.pageNumber = pageNumber
    }
    
}

struct AllArticleResultAction: Action {
    
    static let type = "AllArticleResultAction"
    let result: Result<GetAllArticleEndpoint.Response, SessionTaskError>
    
    init(_ result: Result<GetAllArticleEndpoint.Response, SessionTaskError>) {
        self.result = result
    }
    
}

struct ShowMoreLoadingAction: Action {
    
    static let type = "ShowMoreLoadingAction"
    let showMoreLoading: Bool
    
    init(_ showMoreLoading: Bool) {
        self.showMoreLoading = showMoreLoading
    }
    
}

struct MoreAllArticleResultAction: Action {
    
    static let type = "MoreAllArticleResultAction"
    let result: Result<GetAllArticleEndpoint.Response, SessionTaskError>
    
    init(_ result: Result<GetAllArticleEndpoint.Response, SessionTaskError>) {
        self.result = result
    }
    
}

struct ArticleDetailAction: Action {
    let result: Result<GetArticleDetailEndpoint.Response, SessionTaskError>
}

struct ArticleStockersAction: Action {
    let result: Result<GetArticleStockersEndpoint.Response, SessionTaskError>
}

struct ArticleDetailIdAction: Action {
    let articleId: String
}

struct HasStockArticleAction: Action {
    let hasStock: Bool
}





