//
//  UserArticleListScreenStateProtocol.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/14.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

protocol UserArticleListScreenStateProtocol: ArticleListScreenStateProtocol {
    
    var userId: String! { get set }
    var finishMoreUserArticle: Bool { get set }
    
}

extension UserArticleListScreenStateProtocol {
    
    mutating func updateUserId(userId: String!) {
        self.userId = userId
    }
    
    mutating func updateFinishMoreUserArticle(finishMoreUserArticle: Bool) {
        self.finishMoreUserArticle = finishMoreUserArticle
    }
    
}