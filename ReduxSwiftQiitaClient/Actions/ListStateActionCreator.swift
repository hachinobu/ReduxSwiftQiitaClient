//
//  ListStateActionCreator.swift
//  ReduxSwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2016/10/15.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation
import ReSwift
import Result
import APIKit

protocol ListStateActionCreaterProtocol {
    func generateListUserIdAction() -> Store<AppState>.ActionCreator
    func generateListRefreshAction(isRefresh: Bool, pageNumber: Int) -> Store<AppState>.ActionCreator
    func generateListResultAction(result: Result<ArticleListModel, SessionTaskError>) -> Store<AppState>.ActionCreator
    func generateListShowMoreLoadingAction(isLoading: Bool) -> Store<AppState>.ActionCreator
    func generateMoreListResultAction(result: Result<ArticleListModel, SessionTaskError>) -> Store<AppState>.ActionCreator
    func generateFinishMoreListAction(isFinish: Bool) -> Store<AppState>.ActionCreator
    func generateResetListAction() -> Store<AppState>.ActionCreator
}

struct HomeStateActionCreator: ListStateActionCreaterProtocol {
    
    func generateListUserIdAction() -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return nil
        }
    }
    
    func generateListRefreshAction(isRefresh: Bool, pageNumber: Int) -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return HomeState.HomeRefreshAction(isRefresh: isRefresh, pageNumber: pageNumber)
        }
    }
    
    func generateListResultAction(result: Result<ArticleListModel, SessionTaskError>) -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return HomeState.HomeArticleResultAction(result: result)
        }
    }
    
    func generateListShowMoreLoadingAction(isLoading: Bool) -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return HomeState.HomeShowMoreLoadingAction(showMoreLoading: isLoading)
        }
    }
    
    func generateMoreListResultAction(result: Result<ArticleListModel, SessionTaskError>) -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return HomeState.HomeMoreArticleResultAction(result: result)
        }
    }
    
    func generateFinishMoreListAction(isFinish: Bool) -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return HomeState.HomeFinishMoreArticleAction(finishMoreUserArticle: isFinish)
        }
    }
    
    func generateResetListAction() -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return nil
        }
    }
    
}

struct UserListStateActionCreator: ListStateActionCreaterProtocol {
    
    func generateListUserIdAction() -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return UserArticleListState.UserArticleListUserIdAction(userId: state.userArticleList.userId)
        }
    }
    
    func generateListRefreshAction(isRefresh: Bool, pageNumber: Int) -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return UserArticleListState.UserArticleListRefreshAction(isRefresh: isRefresh, pageNumber: pageNumber)
        }
    }
    
    func generateListResultAction(result: Result<ArticleListModel, SessionTaskError>) -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return UserArticleListState.UserArticleResultAction(result: result)
        }
    }
    
    func generateListShowMoreLoadingAction(isLoading: Bool) -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return UserArticleListState.UserArticleListShowMoreLoadingAction(showMoreLoading: isLoading)
        }
    }
    
    func generateMoreListResultAction(result: Result<ArticleListModel, SessionTaskError>) -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return UserArticleListState.UserMoreArticleResultAction(result: result)
        }
    }
    
    func generateFinishMoreListAction(isFinish: Bool) -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return UserArticleListState.UserFinishMoreArticleAction(finishMoreUserArticle: isFinish)
        }
    }
    
    func generateResetListAction() -> Store<AppState>.ActionCreator {
        return { (state: AppState, store: Store<AppState>) in
            return UserArticleListState.UserResetArticleStateAction()
        }
    }
    
}
