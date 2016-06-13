//
//  LoadingState.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/13.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

struct LoadingState {
    
    private(set) var isLoading: Bool = false
    
}

extension LoadingState {
    
    mutating func updateIsLoading(isLoading: Bool) {
        self.isLoading = isLoading
    }
    
}