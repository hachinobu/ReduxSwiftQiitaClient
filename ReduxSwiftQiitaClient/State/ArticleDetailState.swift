//
//  ArticleState.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/01.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

struct ArticleDetailState {
    
    private(set) var articleVM: ArticleVM!
    private(set) var hasStock: Bool?
    
}

//MARK: Update
extension ArticleDetailState {
    
    mutating func updateArticleVM(articleVM: ArticleVM) {
        self.articleVM = articleVM
    }
    
    mutating func updateHasStock(hasStock: Bool?) {
        self.hasStock = hasStock
    }
    
}

