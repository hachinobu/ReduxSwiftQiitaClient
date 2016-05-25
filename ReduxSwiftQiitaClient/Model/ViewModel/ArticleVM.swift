//
//  ArticleVM.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/25.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import Timepiece

struct ArticleVM {
    
    var articleModel: ArticleModel?
    
    func fetchId() -> String {
        return articleModel?.id ?? ""
    }
    
    func fetchUserId() -> String {
        return articleModel?.user?.id ?? ""
    }
    
    func fetchProfileImageURL() -> String {
        return articleModel?.user?.profileImageUrl ?? ""
    }
    
    func fetchArticleTitle() -> String {
        return articleModel?.title ?? ""
    }
    
    func fetchRenderedBody() -> String {
        return articleModel?.renderedBody ?? ""
    }
    
    func fetchArticleURL() -> String {
        return articleModel?.url ?? ""
    }
    
    func fetchTags() -> String {
        guard let tags = articleModel?.tags else {
            return ""
        }
        return tags.flatMap { $0.name }.joinWithSeparator(",")
    }
    
    func fetchUpdatedAt() -> String {
        return articleModel?.updatedAt ?? ""
    }
    
    func fetchCreatedAt() -> String {
        return articleModel?.createdAt ?? ""
    }
    
}