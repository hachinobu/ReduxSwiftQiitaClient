//
//  ArticleDetailReducer.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/01.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift

//MARK: ArticleDetailReducer
struct ArticleDetailReducer {
}

extension ArticleDetailReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        
        let state = state ?? AppState()
        var newState = state
        var articleDetailState = newState.articleDetail
        
        switch action {
        case let action as ArticleDetailState.ArticleDetailIdAction:
            articleDetailState.updateArticleId(action.articleId)
            
        case let action as ArticleDetailState.ArticleDetailAction:
            articleDetailState.updateArticleDetail(action.articleDetail)
            articleDetailState.updateError(nil)
            
        case let action as ArticleDetailState.ArticleDetailStockersAction:
            articleDetailState.updateStockUsers(action.stockers)
            articleDetailState.updateError(nil)
            
        case let action as ArticleDetailState.ArticleDetailHasStockAction:
            let stockStatus = StockStatus(isStock: action.hasStock)
            articleDetailState.updateStockStatus(stockStatus)
            
        case let action as ArticleDetailState.ArticleDetailFetchingStockStatusAction:
            articleDetailState.updateFetchingStockStatus(action.fetchingStockStatus)
            
        case let action as ArticleDetailState.ArticleDetailErrorAction:
            articleDetailState.updateError(action.error)
            
        case let action as ArticleDetailState.ArticleDetailResetAction:
            articleDetailState.updateArticleId(action.articleId)
            articleDetailState.updateArticleDetail(action.articleDetail)
            articleDetailState.updateError(action.error)
            articleDetailState.updateStockUsers(action.stockUsers)
            articleDetailState.updateStockStatus(action.stockStatus)
            articleDetailState.updateFetchingStockStatus(action.fetchingStockStatus)
        
        default:
            break
        }
        
        newState.articleDetail = articleDetailState
        return newState
    }
    
}

//MARK: UserArticleDetailReducer
struct UserArticleDetailReducer {
}

extension UserArticleDetailReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        
        let state = state ?? AppState()
        var newState = state
        var userArticleDetailState = newState.userArticleDetail
        
        switch action {
        case let action as ArticleDetailState.UserArticleDetailIdAction:
            userArticleDetailState.updateArticleId(action.articleId)
            
        case let action as ArticleDetailState.UserArticleDetailAction:
            userArticleDetailState.updateArticleDetail(action.articleDetail)
            userArticleDetailState.updateError(nil)
            
        case let action as ArticleDetailState.UserArticleDetailStockersAction:
            userArticleDetailState.updateStockUsers(action.stockers)
            userArticleDetailState.updateError(nil)
            
        case let action as ArticleDetailState.UserArticleDetailHasStockAction:
            let stockStatus = StockStatus(isStock: action.hasStock)
            userArticleDetailState.updateStockStatus(stockStatus)
            
        case let action as ArticleDetailState.UserArticleDetailFetchingStockStatusAction:
            userArticleDetailState.updateFetchingStockStatus(action.fetchingStockStatus)
            
        case let action as ArticleDetailState.UserArticleDetailErrorAction:
            userArticleDetailState.updateError(action.error)
            
        case let action as ArticleDetailState.UserArticleDetailResetAction:
            userArticleDetailState.updateArticleId(action.articleId)
            userArticleDetailState.updateArticleDetail(action.articleDetail)
            userArticleDetailState.updateError(action.error)
            userArticleDetailState.updateStockUsers(action.stockUsers)
            userArticleDetailState.updateStockStatus(action.stockStatus)
            userArticleDetailState.updateFetchingStockStatus(action.fetchingStockStatus)
            
        default:
            break
        }
        
        newState.userArticleDetail = userArticleDetailState
        return newState
    }
    
}

