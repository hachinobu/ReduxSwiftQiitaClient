//
//  HomeReducer.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/25.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift

struct HomeReducer {
}

extension HomeReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        let state = state ?? AppState()
        var newState = state
        var homeState = newState.home
        
        switch action {
        case let action as HomeState.HomeRefreshAction:
            homeState.updateIsRefresh(action.isRefresh)
            homeState.updatePageNumber(action.pageNumber)
            
        case let action as HomeState.HomeArticleResultAction:
            switch action.result {
            case .Success(let articleList):
                homeState.updateArticleList(articleList.articleModels)
                homeState.updateErrorMessage(nil)
                
            case .Failure(let error):
                switch error {
                case .ResponseError(let qiitaError as QiitaError):
                    homeState.updateErrorMessage(qiitaError.message)
                default:
                    homeState.updateErrorMessage("通信処理でエラーが発生しました")
                }
            }
            
        case let action as HomeState.HomeMoreArticleResultAction:
            if let moreArticleList = action.result.value {
                homeState.appendArticleList(moreArticleList.articleModels)
            }
            
        case let action as HomeState.HomeShowMoreLoadingAction:
            homeState.updateShowMoreLoading(action.showMoreLoading)
            
        default:
            break
        }
        
        newState.home = homeState
        return newState
    }
    
}