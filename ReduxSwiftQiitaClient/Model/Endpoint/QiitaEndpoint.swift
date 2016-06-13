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

struct QiitaError: ErrorType {
    let message: String
    
    init(object: AnyObject) {
        message = object["message"] as? String ?? "Unknown Error"
    }
}

protocol QiitaRequestType: RequestType {
}

extension QiitaRequestType {
    
    var headerFields: [String: String] {
        let secretsFileURL = NSBundle.mainBundle().URLForResource("Secrets", withExtension: "plist")!
        let secretDict = NSDictionary(contentsOfURL: secretsFileURL)!
        let accessToken = secretDict["AccessToken"] as! String
        return ["Authorization": "Bearer \(accessToken)"]
    }
    
    var baseURL: NSURL {
        return NSURL(string: "http://qiita.com/")!
    }
    
    func interceptObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> AnyObject {
        switch URLResponse.statusCode {
        case 200..<300:
            return object
        case 400, 401, 402, 403, 404:
            throw QiitaError(object: object)
        default:
            throw ResponseError.UnacceptableStatusCode(URLResponse.statusCode)
        }
    }
    
}

extension QiitaRequestType where Response: Mappable {
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        guard let json = object as? [String: AnyObject], responseObject = Mapper<Response>().map(json) else {
            throw ResponseError.UnexpectedObject(object)
        }
        return responseObject
    }
    
}

extension QiitaRequestType where Response == Bool {
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        return true
    }
    
}

extension QiitaRequestType where Response == ArticleListModel {
    
    func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) throws -> Response {
        guard let json = object as? [[String: AnyObject]], responseObject = Mapper<ArticleModel>().mapArray(json) else {
            throw ResponseError.UnexpectedObject(object)
        }
        return ArticleListModel(articleModels: responseObject)
    }
    
}

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
    var queryParameters: [String: AnyObject]? = ["per_page": 100]
    
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



