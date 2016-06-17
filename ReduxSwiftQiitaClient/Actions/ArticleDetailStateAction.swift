//
//  ArticleDetailStateAction.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/16.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift
import Result
import APIKit

//MARK: ArticleDetailStateAction
extension ArticleDetailState {
    
    struct ArticleDetailIdAction: Action {
        let articleId: String
    }
    
    struct ArticleDetailAction: Action {
        let articleDetail: ArticleModel
    }
    
    struct ArticleDetailStockersAction: Action {
        let stockers: UserListModel
    }
    
    struct ArticleDetailHasStockAction: Action {
        let hasStock: Bool
    }
    
    struct ArticleDetailErrorAction: Action {
        let error: SessionTaskError
    }
    
    struct ArticleDetailFetchingStockStatusAction: Action {
        let fetchingStockStatus: Bool
    }
    
    struct ArticleDetailResetAction: Action {
        let articleId: String! = ""
        let articleDetail: ArticleModel? = nil
        let fetchingStockStatus: Bool = false
        let stockStatus: StockStatus? = nil
        let stockUsers: UserListModel? = nil
        let error: SessionTaskError? = nil
    }
    
}

//MARK: UserArticleDetailStateAction
extension ArticleDetailState {
    
    struct UserArticleDetailIdAction: Action {
        let articleId: String
    }
    
    struct UserArticleDetailAction: Action {
        let articleDetail: ArticleModel
    }
    
    struct UserArticleDetailStockersAction: Action {
        let stockers: UserListModel
    }
    
    struct UserArticleDetailHasStockAction: Action {
        let hasStock: Bool
    }
    
    struct UserArticleDetailErrorAction: Action {
        let error: SessionTaskError
    }
    
    struct UserArticleDetailFetchingStockStatusAction: Action {
        let fetchingStockStatus: Bool
    }
    
    struct UserArticleDetailResetAction: Action {
        let articleId: String! = ""
        let articleDetail: ArticleModel? = nil
        let fetchingStockStatus: Bool = false
        let stockStatus: StockStatus? = nil
        let stockUsers: UserListModel? = nil
        let error: SessionTaskError? = nil
    }
    
}

