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
        case let action as RefreshAction:
            homeState.updateIsRefresh(action.isRefresh)
            homeState.updateArticleVMList(action.articleVMList)
            homeState.updatePageNumber(action.pageNumber)
            
        case let action as AllArticleResultAction:
            switch action.result {
            case .Success(let articleList):
                let articleVMList = generateArticleVMList(articleList)
                homeState.updateArticleVMList(articleVMList)
                
            case .Failure(let error):
                switch error {
                case .ResponseError(let qiitaError as QiitaError):
                    homeState.updateErrorMessage(qiitaError.message)
                default:
                    homeState.updateErrorMessage("通信処理でエラーが発生しました")
                }
            }
            
        case let action as FetchAction:
            homeState.updateIsFetch(action.isFetch)
            
        case let action as MoreAllArticleResultAction:
            if let moreArticleList = action.result.value {
                let articleVMList = generateArticleVMList(moreArticleList)
                homeState.appendArticleVMList(articleVMList)
            }
            
        case let action as ShowMoreLoadingAction:
            homeState.updateShowMoreLoading(action.showMoreLoading)
            
        default:
            break
        }
        
        newState.home = homeState
        return newState
    }
    
    private func generateArticleVMList(articleList: ArticleListModel) -> [ArticleVM]? {
        let articleVMList = articleList.articleModels?.flatMap { ArticleVM(articleModel: $0) }
        return articleVMList
    }
    
}