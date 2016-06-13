//
//  UserArticleListReducer.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/13.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift

struct UserArticleListReducer {
    
}

extension UserArticleListReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        
        let state = state ?? AppState()
        var newState = state
        var userArticleListState = newState.userArticleList
        
        switch action {
        case let action as ArticleListUserIdAction:
            userArticleListState.updateUserId(action.userId)
            
        case let action as UserArticleListRefreshAction:
            userArticleListState.updateIsRefresh(action.isRefresh)
            userArticleListState.updateArticleVMList(action.articleVMList)
            userArticleListState.updatePageNumber(action.pageNumber)
            
        case let action as UserArticleResultAction:
            switch action.result {
            case .Success(let articleList):
                let articleVMList = generateArticleVMList(articleList)
                userArticleListState.updateArticleVMList(articleVMList)
                userArticleListState.updateErrorMessage(nil)
                
            case .Failure(let error):
                switch error {
                case .ResponseError(let qiitaError as QiitaError):
                    userArticleListState.updateErrorMessage(qiitaError.message)
                default:
                    userArticleListState.updateErrorMessage("通信処理でエラーが発生しました")
                }
            }
            
        case let action as MoreUserArticleResultAction:
            if let moreArticleList = action.result.value {
                let articleVMList = generateArticleVMList(moreArticleList)
                userArticleListState.appendArticleVMList(articleVMList)
            }
            
        case let action as UserArticleListShowMoreLoadingAction:
            userArticleListState.updateShowMoreLoading(action.showMoreLoading)
            
        case let action as FinishMoreUserArticleAction:
            userArticleListState.updateFinishMoreArticle(action.finishMoreUserArticle)
            
        default:
            break
        }
        
        newState.userArticleList = userArticleListState
        return newState
        
    }
    
}
