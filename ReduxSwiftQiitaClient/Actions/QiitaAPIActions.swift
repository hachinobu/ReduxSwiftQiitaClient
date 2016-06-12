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
    
    let result: Result<GetAllArticleEndpoint.Response, SessionTaskError>
    
    init(_ result: Result<GetAllArticleEndpoint.Response, SessionTaskError>) {
        self.result = result
    }
    
}

struct ShowMoreLoadingAction: Action {
    
    let showMoreLoading: Bool
    
    init(_ showMoreLoading: Bool) {
        self.showMoreLoading = showMoreLoading
    }
    
}

struct MoreAllArticleResultAction: Action {
    
    let result: Result<GetAllArticleEndpoint.Response, SessionTaskError>
    
    init(_ result: Result<GetAllArticleEndpoint.Response, SessionTaskError>) {
        self.result = result
    }
    
}

struct ArticleDetailIdAction: Action {
    let articleId: String
}

struct ArticleDetailAction: Action {
    let articleDetail: ArticleModel
}

struct ArticleStockersAction: Action {
    let stockers: UserListModel
}

struct HasStockArticleAction: Action {
    let hasStock: Bool
}

struct ArticleDetailErrorAction: Action {
    let error: SessionTaskError
}

struct FetchingStockStatusAction: Action {
    let fetchingStockStatus: Bool
}

struct IsUserArticleListAction: Action {
    let isUserArticleList: Bool
}



