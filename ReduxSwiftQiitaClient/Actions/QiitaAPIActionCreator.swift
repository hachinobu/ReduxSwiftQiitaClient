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
    
}