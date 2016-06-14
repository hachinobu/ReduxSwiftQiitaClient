//
//  UserArticleListState.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/13.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

struct UserArticleListState: UserArticleListScreenStateProtocol {
    
    var userId: String!
    var pageNumber: Int = 1
    var articleVMList: [ArticleVM]?
    var errorMessage: String?
    var isRefresh: Bool = false
    var showMoreLoading: Bool = false
    var finishMoreUserArticle: Bool = false
    
}