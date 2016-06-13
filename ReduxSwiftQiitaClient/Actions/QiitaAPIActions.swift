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

struct LoadingAction: Action {
    let isLoading: Bool
}

struct RefreshAction: Action {
    
    let isRefresh: Bool
    let articleVMList: [ArticleVM]?
    let pageNumber: Int
    
    init(isRefresh: Bool, articleVMList: [ArticleVM]? = [], pageNumber: Int = 1) {
        self.isRefresh = isRefresh
        self.articleVMList = articleVMList
        self.pageNumber = pageNumber
    }
    
}

struct UserArticleListRefreshAction: Action {
    
    let isRefresh: Bool
    let articleVMList: [ArticleVM]?
    let pageNumber: Int
    
    init(isRefresh: Bool, articleVMList: [ArticleVM]? = [], pageNumber: Int = 1) {
        self.isRefresh = isRefresh
        self.articleVMList = articleVMList
        self.pageNumber = pageNumber
    }
    
}

struct AllArticleResultAction: Action {
    let result: Result<GetAllArticleEndpoint.Response, SessionTaskError>
}

struct UserArticleResultAction: Action {
    let result: Result<GetAllArticleEndpoint.Response, SessionTaskError>
}

struct ShowMoreLoadingAction: Action {
    let showMoreLoading: Bool
}

struct UserArticleListShowMoreLoadingAction: Action {
    let showMoreLoading: Bool
}

struct MoreAllArticleResultAction: Action {
    let result: Result<GetAllArticleEndpoint.Response, SessionTaskError>
}

struct MoreUserArticleResultAction: Action {
    let result: Result<GetAllArticleEndpoint.Response, SessionTaskError>
}

struct ArticleDetailIdAction: Action {
    let articleId: String
}

struct ArticleListUserIdAction: Action {
    let userId: String
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

struct FinishMoreUserArticleAction: Action {
    let finishMoreUserArticle: Bool
}

struct ResetUserArticleStateAction: Action {
    
    let userId: String? = nil
    let pageNumber: Int = 1
    let articleVMList: [ArticleVM]? = nil
    let errorMessage: String? = nil
    let isRefresh: Bool = false
    let showMoreLoading: Bool = false
    let finishMoreUserArticle: Bool = false
    
}
