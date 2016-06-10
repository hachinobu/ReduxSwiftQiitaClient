//
//  UserModel.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/24.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserModel {
    
    var permanentId: String?
    var id: String?
    var name: String?
    var location: String?
    var profileImageUrl: String?
    var twitterScreenName: String?
    var facebookId: String?
    var linkedInId: String?
    var githubAccountName: String?
    var itemsCount: Int?
    var followeesCount: Int?
    var followersCount: Int?
    var organization: String?
    var websiteUrl: String?
    var description: String?
    
}

extension UserModel: Mappable {
    
    init?(_ map: Map) {}
    
    mutating func mapping(map: Map) {
        permanentId <- map["permanent_id"]
        id <- map["id"]
        name <- map["name"]
        location <- map["location"]
        profileImageUrl <- map["profile_image_url"]
        twitterScreenName <- map["twitter_screen_name"]
        facebookId <- map["facebook_id"]
        linkedInId <- map["linkedin_id"]
        githubAccountName <- map["github_login_name"]
        itemsCount <- map["items_count"]
        followeesCount <- map["followees_count"]
        followersCount <- map["followers_count"]
        organization <- map["organization"]
        websiteUrl <- map["website_url"]
        description <- map["description"]
    }
    
}

extension UserModel {
    
    func fetchUserName() -> String {
        return name ?? ""
    }
    
}
