//
//  HomeState.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/25.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

struct HomeState {
    
    private(set) var pageNumber: Int = 1
    private(set) var articleVMList: [ArticleVM]?
    private(set) var errorMessage: String?
    private(set) var isFetch: Bool = false
    private(set) var isRefresh: Bool = false
    private(set) var showMoreLoading: Bool = false
    
}

//MARK: Update State
extension HomeState {
    
    mutating func updateIsFetch(isFetch: Bool) {
        self.isFetch = isFetch
    }
    
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

//MARK: ViewState
extension HomeState {
    
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