//
//  LoadingStateReducer.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/13.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift

struct LoadingStateReducer {
}

extension LoadingStateReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        
        let state = state ?? AppState()
        var newState = state
        var loadingState = newState.loading
        
        switch action {
        case let action as LoadingState.LoadingAction:
            loadingState.updateIsLoading(action.isLoading)
        default:
            break
        }
        newState.loading = loadingState
        return newState
        
    }
    
}