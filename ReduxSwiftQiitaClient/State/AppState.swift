//
//  AppState.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/25.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    
    var loading = LoadingState()
    var home = HomeState()
    var articleDetail = ArticleDetailState()
    var userArticleList = UserArticleListState()
    
}