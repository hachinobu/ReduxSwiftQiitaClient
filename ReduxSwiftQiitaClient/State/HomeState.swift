//
//  HomeState.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/25.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

struct HomeState: ArticleListScreenStateProtocol {
    
    var pageNumber: Int = 1
    var articleVMList: [ArticleVM]?
    var errorMessage: String?
    var isRefresh: Bool = false
    var showMoreLoading: Bool = false
    
}