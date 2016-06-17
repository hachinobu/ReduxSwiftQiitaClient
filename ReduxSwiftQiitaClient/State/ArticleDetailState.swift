//
//  ArticleState.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/01.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import APIKit

struct ArticleDetailState {
    
    private(set) var articleId: String!
    private(set) var articleDetail: ArticleModel?
    private(set) var fetchingStockStatus: Bool = false
    private(set) var stockStatus: StockStatus?
    private(set) var stockUsers: UserListModel?
    private(set) var error: SessionTaskError?
    
}

//MARK: Update
extension ArticleDetailState {
    
    mutating func updateArticleId(articleId: String) {
        self.articleId = articleId
    }
    
    mutating func updateArticleDetail(articleDetail: ArticleModel?) {
        self.articleDetail = articleDetail
    }
    
    mutating func updateFetchingStockStatus(fetchingStockStatus: Bool) {
        self.fetchingStockStatus = fetchingStockStatus
    }
    
    mutating func updateStockStatus(stockStatus: StockStatus?) {
        self.stockStatus = stockStatus
    }
    
    mutating func updateStockUsers(stockUsers: UserListModel?) {
        self.stockUsers = stockUsers
    }
    
    mutating func updateError(error: SessionTaskError?) {
        self.error = error
    }
        
}

extension ArticleDetailState {
    
    private func fetchStockCountDisplay() -> String {
        guard let users = stockUsers?.userModels else {
            return "0ストック"
        }
        return users.count == 100 ? "ストック数: 100+" : "ストック数: \(users.count)"
    }
    
    func isReloadView() -> Bool {
        return articleId != nil && stockUsers != nil && stockStatus != nil
    }
    
    func hasError() -> Bool {
        return error != nil
    }
    
    func fetchErrorMessage() -> String {
        guard let error = error else {
            return ""
        }
        
        switch error {
        case .ResponseError(let qiitaError as QiitaError):
            return qiitaError.message
        default:
            return "通信処理でエラーが発生しました"
        }
    }
    
    func fetchArticleDetail() -> ArticleModel {
        return articleDetail ?? ArticleModel()
    }
    
    func hasStock() -> Bool {
        return stockStatus?.isStock ?? false
    }
    
    func hasStockStatus() -> Bool {
        return stockStatus != nil
    }

    func hasArticleDetailData() -> Bool {
        return articleDetail != nil
    }
    
    func fetchTableSectionCount() -> Int {
        return articleDetail == nil ? 0 : 1
    }
    
    func fetchTableSectionRowCount() -> Int {
        return articleDetail == nil ? 0 : 2
    }
    
    func fetchArticleDetailTopInfo() -> (articleDetail: ArticleModel, stockCount: String, stockStatus: StockStatus) {
        let status = stockStatus ?? StockStatus(isStock: false)
        return (fetchArticleDetail(), fetchStockCountDisplay(), status)
    }
    
    func fetchHtmlBody() -> String {
        return articleDetail?.fetchRenderedBody() ?? ""
    }
    
}
