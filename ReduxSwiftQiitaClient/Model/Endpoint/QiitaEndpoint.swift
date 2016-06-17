//
//  QiitaEndpoint.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/24.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import APIKit
import ObjectMapper

struct GetAllArticleEndpoint: QiitaRequestType {
    
    typealias Response = ArticleListModel
    
    var method: HTTPMethod {
        return .GET
    }
    
    var path: String {
        return "/api/v2/items"
    }
    
    var queryParameters: [String: AnyObject]?
    
    init(queryParameters: [String: AnyObject]?) {
        self.queryParameters = queryParameters
    }
    
}

struct GetArticleDetailEndpoint: QiitaRequestType {
    
    typealias Response = ArticleModel
    
    var method: HTTPMethod {
        return .GET
    }
    
    var path: String = "/api/v2/items/"
    
    init(id: String) {
        path += id
    }
    
}

struct GetArticleStockersEndpoint: QiitaRequestType {
    
    typealias Response = UserListModel
    
    var method: HTTPMethod {
        return .GET
    }
    
    var path: String
    var queryParameters: [String: AnyObject]? = ["per_page": "100"]
    
    init(id: String) {
        path = "/api/v2/items/\(id)/stockers"
    }
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        guard let json = object as? [[String: AnyObject]], responseObject = Mapper<UserModel>().mapArray(json) else {
            throw ResponseError.UnexpectedObject(object)
        }
        return UserListModel(userModels: responseObject)
    }
    
}

struct GetArticleStockStatus: QiitaRequestType {
    
    typealias Response = Bool
    
    var method: HTTPMethod {
        return .GET
    }
    
    var path: String
    
    init(id: String) {
        path = "/api/v2/items/\(id)/stock"
    }
    
}

struct UpdateArticleStockStatus: QiitaRequestType {
    
    typealias Response = Bool
    
    var path: String
    var method: HTTPMethod
    
    init(id: String, method: HTTPMethod) {
        path = "/api/v2/items/\(id)/stock"
        self.method = method
    }
    
}

struct GetUserArticleEndpoint: QiitaRequestType {
    
    typealias Response = ArticleListModel
    
    var method: HTTPMethod {
        return .GET
    }
    
    var path: String
    var queryParameters: [String: AnyObject]?
    
    init(userId: String, queryParameters: [String: AnyObject]?) {
        path = "/api/v2/users/\(userId)/items"
        self.queryParameters = queryParameters
    }
    
}



