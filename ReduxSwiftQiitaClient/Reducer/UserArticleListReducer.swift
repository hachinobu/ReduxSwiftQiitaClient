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
        case let action as  UserArticleListState.UserArticleListUserIdAction:
            userArticleListState.updateUserId(action.userId)
            
        case let action as UserArticleListState.UserArticleListRefreshAction:
            userArticleListState.updateIsRefresh(action.isRefresh)
            userArticleListState.updatePageNumber(action.pageNumber)
            
        case let action as UserArticleListState.UserArticleResultAction:
            switch action.result {
            case .Success(let articleList):
                userArticleListState.updateArticleList(articleList.articleModels)
                userArticleListState.updateErrorMessage(nil)
                
            case .Failure(let error):
                switch error {
                case .ResponseError(let qiitaError as QiitaError):
                    userArticleListState.updateErrorMessage(qiitaError.message)
                default:
                    userArticleListState.updateErrorMessage("通信処理でエラーが発生しました")
                }
            }
            
        case let action as UserArticleListState.UserMoreArticleResultAction:
            if let moreArticleList = action.result.value {
                userArticleListState.appendArticleList(moreArticleList.articleModels)
            }
            
        case let action as UserArticleListState.UserArticleListShowMoreLoadingAction:
            userArticleListState.updateShowMoreLoading(action.showMoreLoading)
            
        case let action as UserArticleListState.UserFinishMoreArticleAction:
            userArticleListState.updateFinishMoreUserArticle(action.finishMoreUserArticle)
            
        case let action as UserArticleListState.UserResetArticleStateAction:
            userArticleListState.updateUserId(action.userId)
            userArticleListState.updatePageNumber(action.pageNumber)
            userArticleListState.updateArticleList(action.articleList)
            userArticleListState.updateErrorMessage(action.errorMessage)
            userArticleListState.updateIsRefresh(action.isRefresh)
            userArticleListState.updateShowMoreLoading(action.showMoreLoading)
            userArticleListState.updateFinishMoreUserArticle(action.finishMoreUserArticle)
            
        default:
            break
        }
        
        newState.userArticleList = userArticleListState
        return newState
        
    }
    
}
