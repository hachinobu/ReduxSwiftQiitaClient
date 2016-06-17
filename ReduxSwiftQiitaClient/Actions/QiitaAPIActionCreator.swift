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
import Result

struct QiitaAPIActionCreator {
    
    static func call<Request: QiitaRequestType>(request: Request, responseHandler: (Result<Request.Response, SessionTaskError>) -> Void) -> Store<AppState>.ActionCreator {
        
        return { state, store in
            
            Session.sendRequest(request) { result in
                responseHandler(result)
            }
            return nil
            
        }
        
    }
    
    static func call(actionTasks: [Task<CGFloat, Action, SessionTaskError>], responseHandler: Result<[Action], SessionTaskError> -> Void) -> Store<AppState>.ActionCreator {
        
        return { state, store in
            
            Task.all(actionTasks).success { (actions) -> Void in
                responseHandler(Result(actions))
                }.failure { (error, isCancelled) -> Void in
                    responseHandler(Result(error: error!))
            }
            return nil
            
        }
        
    }
    
}

//MARK: generate Task
extension QiitaAPIActionCreator {
    
    enum ArticleDetailTaskActionType {
        case DetailFromAllList
        case DetailFromUserList
        
        func generateArticleDetailAction(articleDetail: ArticleModel) -> Action {
            switch self {
            case .DetailFromAllList:
                return ArticleDetailState.ArticleDetailAction(articleDetail: articleDetail)
            case .DetailFromUserList:
                return ArticleDetailState.UserArticleDetailAction(articleDetail: articleDetail)
            }
        }
        
        func generateArticleDetailStockersAction(stockers: UserListModel) -> Action {
            switch self {
            case .DetailFromAllList:
                return ArticleDetailState.ArticleDetailStockersAction(stockers: stockers)
            case .DetailFromUserList:
                return ArticleDetailState.UserArticleDetailStockersAction(stockers: stockers)
            }
        }
        
    }
    
    static func fetchArticleDetailInfoActionTasks(id: String, actionType: ArticleDetailTaskActionType) -> [Task<CGFloat, Action, SessionTaskError>] {
        let articleDetailTask = fetchArticleDetailTask(id, actionType: actionType)
        let articleStockersTask = fetchArticleStokersTask(id, actionType: actionType)
        return [articleDetailTask, articleStockersTask]
    }
    
    private static func fetchArticleDetailTask(id: String, actionType: ArticleDetailTaskActionType) -> Task<CGFloat, Action, SessionTaskError> {
        
        return Task { progress, fulfill, reject, configure in
            
            let request = GetArticleDetailEndpoint(id: id)
            Session.sendRequest(request) { result in
                switch result {
                case .Success(let articleDetail):
                    let action = actionType.generateArticleDetailAction(articleDetail)
                    fulfill(action)
                case .Failure(let error):
                    reject(error)
                }
            }
            
        }
    }
    
    private static func fetchArticleStokersTask(id: String, actionType: ArticleDetailTaskActionType) -> Task<CGFloat, Action, SessionTaskError> {
        
        return Task { progress, fulfill, reject, configure in
            
            let request = GetArticleStockersEndpoint(id: id)
            Session.sendRequest(request) { result in
                switch result {
                case .Success(let stockers):
                    let action = actionType.generateArticleDetailStockersAction(stockers)
                    fulfill(action)
                case .Failure(let error):
                    reject(error)
                }
            }
            
        }
        
    }
    
}

