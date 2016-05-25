//
//  HomeState.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/25.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift

struct HomeState {
    
    var articleVMList: [ArticleVM]?
    var isFetch: Bool = false
    var isRefresh: Bool = false
    
}
