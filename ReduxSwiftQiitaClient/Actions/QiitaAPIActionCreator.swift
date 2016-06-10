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
            
            let taskList: [Task<CGFloat, Action, SessionTaskError>] = [fetchArticleDetailTask(id, store: store), fetchArticleStokersTask(id, store: store)]
            Task.all(taskList).success { actionList -> Void in
                actionList.forEach { store.dispatch($0) }
            }.failure { (error, _) -> Void in
                let action = ArticleDetailErrorAction(error: error!)
                store.dispatch(action)
            }.then { _ in
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
    
    static func updateStockStatus(id: String, finishHandler: (Store<AppState> -> Void)?) -> Store<AppState>.ActionCreator {
        
        return { state, store in
            
            let request = ToStock(id: id)
            Session.sendRequest(request) { result in
                
            }
            return nil
            
        }
        
    }
}

//MARK: generate Task
extension QiitaAPIActionCreator {
    
    private static func fetchArticleDetailTask(id: String, store: Store<AppState>) -> Task<CGFloat, Action, SessionTaskError> {
        return Task { progress, fulfill, reject, configure in
            
            let request = GetArticleDetailEndpoint(id: id)
            Session.sendRequest(request) { result in
                switch result {
                case .Success(let article):
                    let action = ArticleDetailAction(articleDetail: article)
                    fulfill(action)
                case .Failure(let error):
                    reject(error)
                }
            }
            
        }
    }
    
    private static func fetchArticleStokersTask(id: String, store: Store<AppState>) -> Task<CGFloat, Action, SessionTaskError> {
        
        return Task { progress, fulfill, reject, configure in
            
            let request = GetArticleStockersEndpoint(id: id)
            Session.sendRequest(request) { result in
                switch result {
                case .Success(let userList):
                    let action = ArticleStockersAction(stockers: userList)
                    fulfill(action)
                case .Failure(let error):
                    reject(error)
                }
            }
            
        }
        
    }
    
}

