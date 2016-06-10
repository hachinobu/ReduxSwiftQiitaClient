//
//  ArticleModel.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/24.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct ArticleModel {
    
    private(set) var id: String?
    private(set) var isPrivate: Bool?
    private(set) var title: String?
    private(set) var body: String?
    private(set) var renderedBody: String?
    private(set) var url: String?
    private(set) var tags: [TagModel]?
    private(set) var user: UserModel?
    private(set) var coEditing: Bool?
    private(set) var createdAt: String?
    private(set) var updatedAt: String?
    
}

extension ArticleModel: Mappable {
    
    init?(_ map: Map) { }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        isPrivate <- map["private"]
        title <- map["title"]
        body <- map["body"]
        renderedBody <- map["rendered_body"]
        url <- map["url"]
        tags <- map["tags"]
        user <- map["user"]
        coEditing <- map["coediting"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
    
}

extension ArticleModel {
    
    func fetchId() -> String {
        return id ?? ""
    }
    
    func fetchUserId() -> String {
        return user?.id ?? ""
    }
    
    func fetchPostedInfo() -> String {
        guard let userId = user?.id else {
            return ""
        }
        return userId + " が投稿しました"
    }
    
    func fetchProfileImageURL() -> String {
        return user?.profileImageUrl ?? ""
    }
    
    func fetchArticleTitle() -> String {
        return title ?? ""
    }
    
    func fetchRenderedBody() -> String {
        return renderedBody ?? ""
    }
    
    func fetchArticleURL() -> String {
        return url ?? ""
    }
    
    func fetchDownloadURLString() -> String {
        return user?.profileImageUrl ?? ""
    }
    
    func fetchDownloadURL() -> NSURL? {
        return NSURL(string: fetchDownloadURLString())
    }
    
    func fetchTags() -> String {
        guard let tags = tags else {
            return ""
        }
        return tags.flatMap { $0.name }.joinWithSeparator(",")
    }
    
    func fetchUpdatedAt() -> String {
        return updatedAt ?? ""
    }
    
    func fetchCreatedAt() -> String {
        return createdAt ?? ""
    }
    
}