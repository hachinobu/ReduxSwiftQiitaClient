//
//  QiitaAPIActions.swift
//  ReduxSwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2016/05/29.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift

extension LoadingState {
    
    struct LoadingAction: Action {
        let isLoading: Bool
    }
    
}