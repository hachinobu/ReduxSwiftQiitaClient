//
//  UserArticleListStateAction.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/16.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift
import Result
import APIKit

extension UserArticleListState {
    
    struct UserArticleListUserIdAction: Action {
        let userId: String
    }
    
    struct UserArticleListRefreshAction: Action {
        let isRefresh: Bool
        let pageNumber: Int
    }
    
    struct UserArticleResultAction: Action {
        let result: Result<GetAllArticleEndpoint.Response, SessionTaskError>
    }
    
    struct UserArticleListShowMoreLoadingAction: Action {
        let showMoreLoading: Bool
    }
    
    struct UserMoreArticleResultAction: Action {
        let result: Result<GetAllArticleEndpoint.Response, SessionTaskError>
    }
    
    struct UserFinishMoreArticleAction: Action {
        let finishMoreUserArticle: Bool
    }
    
    struct UserResetArticleStateAction: Action {
        let userId: String? = nil
        let pageNumber: Int = 1
        let articleList: [ArticleModel]? = nil
        let errorMessage: String? = nil
        let isRefresh: Bool = false
        let showMoreLoading: Bool = false
        let finishMoreUserArticle: Bool = false
    }
    
}