//
//  Array+Extension.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/17.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    public func uniqueBy() -> Array<Element> {
        return self.reduce([Element]()) { (list, element) in
            if list.contains(element) {
                return list
            }
            return list + [element]
        }
    }
    
}