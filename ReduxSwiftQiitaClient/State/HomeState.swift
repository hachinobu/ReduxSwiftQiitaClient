//
//  HomeState.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/25.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

struct HomeState: ArticleListScreenStateProtocol {
    
    let title: String = "ホーム"
    var userId: String!
    var pageNumber: Int = 1
    var articleList: [ArticleModel]?
    var errorMessage: String?
    var isRefresh: Bool = false
    var showMoreLoading: Bool = false
    var finishMoreUserArticle: Bool = false
    
}