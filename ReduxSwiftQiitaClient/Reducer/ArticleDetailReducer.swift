//
//  ArticleDetailReducer.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/01.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift

struct ArticleDetailReducer {
}

extension ArticleDetailReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        
        let state = state ?? AppState()
        var newState = state
        var articleDetailState = newState.articleDetail
        
        switch action {
        case let action as ArticleDetailIdAction:
            articleDetailState.updateArticleId(action.articleId)
            
        case let action as ArticleDetailAction:
            articleDetailState.updateArticleDetail(action.articleDetail)
            articleDetailState.updateError(nil)
            
        case let action as ArticleStockersAction:
            articleDetailState.updateStockUsers(action.stockers)
            articleDetailState.updateError(nil)
            
        case let action as HasStockArticleAction:
            let stockStatus = StockStatus(isStock: action.hasStock)
            articleDetailState.updateStockStatus(stockStatus)
            
        case let action as FetchingStockStatusAction:
            articleDetailState.updateFetchingStockStatus(action.fetchingStockStatus)
            
        case let action as ArticleDetailErrorAction:
            articleDetailState.updateError(action.error)
        
        case let action as IsUserArticleListAction:
            articleDetailState.updateUserArticleList(action.isUserArticleList)
            
        default:
            break
        }
        
        newState.articleDetail = articleDetailState
        return newState
    }
    
}
