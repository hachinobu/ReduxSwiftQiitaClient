//
//  QiitaAPIActionCreator.swift
//  ReduxSwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2016/05/29.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import APIKit
import ReSwift
import Kingfisher
import SwiftTask

struct QiitaAPIActionCreator {
    
    static let PerPage: Int = 20
    
    static func fetchAllArticleList(finishHandler: ((Store<AppState>) -> Void)?) -> Store<AppState>.ActionCreator {
        
        return { state, store in
            
            let request = GetAllArticleEndpoint(queryParameters: ["per_page": PerPage, "page": state.home.pageNumber])
            Session.sendRequest(request) { result in
                let action = AllArticleResultAction(result)
                store.dispatch(action)
                finishHandler?(store)
            }
            return nil
            
        }
        
    }
    
    static func fetchMoreArticleList(finishHandler: ((Store<AppState>) -> Void)?) -> Store<AppState>.ActionCreator {
        
        return { state, store in
            
            let request = GetAllArticleEndpoint(queryParameters: ["per_page": PerPage, "page": state.home.pageNumber])
            Session.sendRequest(request) { result in
                let action = MoreAllArticleResultAction(result)
                store.dispatch(action)
                finishHandler?(store)
            }
            return nil
            
        }
        
    }
    
    static func fetchArticleDetailInfo(id: String, finishHandler: ((Store<AppState>) -> Void)?) -> Store<AppState>.ActionCreator {
        
        return { state, store in
            
            let taskList: [Task<CGFloat, Bool, SessionTaskError>] = [fetchArticleDetailTask(id, store: store), fetchArticleStokersTask(id, store: store)]
            Task.all(taskList).success { _ -> Void in
                finishHandler?(store)
            }
            return nil
            
        }
        
    }
    
    static func fetchArticleStockStatus(id: String, finishHandler: ((Store<AppState>) -> Void)?) -> Store<AppState>.ActionCreator {
        
        return { state, store in
            
            let request = GetArticleStockStatus(id: id)
            Session.sendRequest(request) { result in
                let hasStock: Bool = result.value != nil
                let action = HasStockArticleAction(hasStock: hasStock)
                store.dispatch(action)
                finishHandler?(store)
            }
            return nil
            
        }
        
    }
    
}

//MARK: generate Task
extension QiitaAPIActionCreator {
    
    private static func fetchArticleDetailTask(id: String, store: Store<AppState>) -> Task<CGFloat, Bool, SessionTaskError> {
        return Task { (progress, fulfill, reject, configure) in
            
            let request = GetArticleDetailEndpoint(id: id)
            Session.sendRequest(request) { result in
                let action = ArticleDetailAction(result: result)
                store.dispatch(action)
                fulfill(true)
            }
            
        }
    }
    
    private static func fetchArticleStokersTask(id: String, store: Store<AppState>) -> Task<CGFloat, Bool, SessionTaskError> {
        
        return Task { (progress, fulfill, reject, configure) in
            
            let request = GetArticleStockersEndpoint(id: id)
            Session.sendRequest(request) { result in
                let action = ArticleStockersAction(result: result)
                store.dispatch(action)
                fulfill(true)
            }
            
        }
        
    }
    
}

