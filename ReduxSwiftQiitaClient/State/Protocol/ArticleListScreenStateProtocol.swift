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
    var articleVMList: [ArticleVM]? { get set }
    var errorMessage: String? { get set }
    var isRefresh: Bool { get set }
    var showMoreLoading: Bool { get set }
    
}

extension ArticleListScreenStateProtocol {
    
    mutating func updateIsRefresh(isRefresh: Bool) {
        self.isRefresh = isRefresh
    }
    
    mutating func updateArticleVMList(articleVMList: [ArticleVM]?) {
        self.articleVMList = articleVMList
        incrementPageNumber()
    }
    
    mutating func appendArticleVMList(articleVMList: [ArticleVM]?) {
        guard let articleVMList = articleVMList else { return }
        self.articleVMList?.appendContentsOf(articleVMList)
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
    
    func fetchArticleVM(index: Int) -> ArticleVM {
        guard let articleVMList = articleVMList where articleVMList.count > index else {
            return ArticleVM()
        }
        return articleVMList[index]
    }
    
    func fetchArticleListCount() -> Int {
        return articleVMList?.count ?? 0
    }
    
    func hasError() -> Bool {
        return errorMessage != nil
    }
    
    func fetchErrorMessage() -> String {
        return errorMessage ?? ""
    }
    
    func fetchArticleListEndIndex() -> Int {
        return articleVMList?.endIndex.predecessor() ?? 0
    }
    
}