//
//  TagModel.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/24.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct TagModel {
    
    var name: String?
    var versions: [String]?
    
}

extension TagModel: Mappable {
    
    init?(_ map: Map) {}
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        versions <- map["versions"]
    }
    
}

