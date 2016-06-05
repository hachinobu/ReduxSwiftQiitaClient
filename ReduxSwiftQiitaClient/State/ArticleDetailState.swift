//
//  ArticleState.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/01.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

struct ArticleDetailState {
    
    private(set) var articleId: String!
    private(set) var articleDetail: ArticleVM?
    private(set) var hasStock: Bool?
    
}

//MARK: Update
extension ArticleDetailState {
    
    mutating func updateArticleId(articleId: String) {
        self.articleId = articleId
    }
    
    mutating func updateArticleDetail(articleDetail: ArticleVM) {
        self.articleDetail = articleDetail
    }
    
    mutating func updateHasStock(hasStock: Bool?) {
        self.hasStock = hasStock
    }
    
}

//MARK;
extension ArticleDetailState {
    
    func hasArticleDetailData() -> Bool {
        return articleDetail != nil
    }
    
    func fetchTableSectionCount() -> Int {
        return articleDetail == nil ? 0 : 1
    }
    
    func fetchTableSectionRowCount() -> Int {
        return articleDetail == nil ? 0 : 2
    }
    
}