//
//  ArticleListScreenStateProtocol.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/14.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

protocol ArticleListScreenStateProtocol {
    
    var pageNumber: Int { get set }
    var articleList: [ArticleModel]? { get set }
    var errorMessage: String? { get set }
    var isRefresh: Bool { get set }
    var showMoreLoading: Bool { get set }
    
}

extension ArticleListScreenStateProtocol {
    
    mutating func updateIsRefresh(isRefresh: Bool) {
        self.isRefresh = isRefresh
    }
    
    mutating func updateArticleList(articleList: [ArticleModel]?) {
        self.articleList = articleList
        incrementPageNumber()
    }
    
    mutating func appendArticleList(articleList: [ArticleModel]?) {
        guard let articleList = articleList else { return }
        self.articleList?.appendContentsOf(articleList)
        self.articleList = self.articleList?.uniqueBy()
        incrementPageNumber()
    }
    
    mutating func updateErrorMessage(errorMessage: String?) {
        self.errorMessage = errorMessage
    }
    
    mutating func updateShowMoreLoading(showMoreLoading: Bool) {
        self.showMoreLoading = showMoreLoading
    }
    
    mutating func updatePageNumber(pageNumber: Int) {
        self.pageNumber = pageNumber
    }
    
    private mutating func incrementPageNumber() {
        pageNumber += 1
    }
    
}

extension ArticleListScreenStateProtocol {
    
    func fetchArticle(index: Int) -> ArticleModel {
        guard let articleList = articleList where articleList.count > index else {
            return ArticleModel()
        }
        return articleList[index]
    }
    
    func fetchArticleListCount() -> Int {
        return articleList?.count ?? 0
    }
    
    func hasError() -> Bool {
        return errorMessage != nil
    }
    
    func fetchErrorMessage() -> String {
        return errorMessage ?? ""
    }
    
    func fetchArticleListEndIndex() -> Int {
        return articleList?.endIndex.predecessor() ?? 0
    }
    
}