//
//  HomeStateAction.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/15.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift
import Result
import APIKit

extension HomeState {
    
    struct HomeRefreshAction: Action {
        let isRefresh: Bool
        let pageNumber: Int
    }
    
    struct HomeArticleResultAction: Action {
        let result: Result<GetAllArticleEndpoint.Response, SessionTaskError>
    }
    
    struct HomeShowMoreLoadingAction: Action {
        let showMoreLoading: Bool
    }
    
    struct HomeMoreArticleResultAction: Action {
        let result: Result<GetAllArticleEndpoint.Response, SessionTaskError>
    }
    
}