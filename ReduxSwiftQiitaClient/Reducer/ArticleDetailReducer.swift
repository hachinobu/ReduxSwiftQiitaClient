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
        var articleDetail = newState.articleDetail
        
        switch action {
        case let action as ArticleDetailIdAction:
            articleDetail.updateArticleId(action.articleId)
            
        case let action as HasStockArticleAction:
            articleDetail.updateHasStock(action.hasStock)
            
        default:
            break
        }
        
        newState.articleDetail = articleDetail
        return newState
    }
    
}