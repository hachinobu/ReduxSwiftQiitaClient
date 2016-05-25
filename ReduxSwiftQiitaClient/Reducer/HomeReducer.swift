//
//  HomeReducer.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/25.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift

struct HomeReducer {
}

extension HomeReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        return AppState()
    }
    
}
