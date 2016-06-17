//
//  UserArticleDetailTableViewController.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/16.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit
import ReSwift
import APIKit

class UserArticleDetailTableViewController: UITableViewController, NavigationBarProtocol {

    private var userArticleDetailState: ArticleDetailState {
        return mainStore.state.userArticleDetail
    }
    
    private var webViewHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "詳細"
        setupBackBarButton()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mainStore.subscribe(self)
        fetchArticleDetail()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        mainStore.unsubscribe(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        mainStore.dispatch(ArticleDetailState.UserArticleDetailResetAction())
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return userArticleDetailState.fetchTableSectionCount()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArticleDetailState.fetchTableSectionRowCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.userArticleDetailTopInfoCell, forIndexPath: indexPath)!
            cell.articleInfo = userArticleDetailState.fetchArticleDetailTopInfo()
            cell.updateStockButtonAction = { [weak self] in
                self?.updateStockStatus()
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.articleDetailBodyCell, forIndexPath: indexPath)!
        cell.htmlWebView.delegate = self
        cell.loadRenderHtmlBody(userArticleDetailState.fetchHtmlBody())
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return fetchTableHeight(indexPath.row)
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return fetchTableHeight(indexPath.row)
    }
    
    private func fetchTableHeight(row: Int) -> CGFloat {
        return row == 0 ? UITableViewAutomaticDimension : webViewHeight
    }
    
}

//MARK: StoreSubscriber
extension UserArticleDetailTableViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        guard userArticleDetailState.isReloadView() else {
            return
        }
        tableView.reloadData()
    }
    
}

extension UserArticleDetailTableViewController {
    
    private func fetchArticleDetail() {
        
        mainStore.dispatch(LoadingState.LoadingAction(isLoading: true))
        let tasks = QiitaAPIActionCreator.fetchArticleDetailInfoActionTasks(userArticleDetailState.articleId, actionType: .DetailFromUserList)
        let actionCreator = QiitaAPIActionCreator.call(tasks) { [weak self] result in
            guard let actions = result.value else {
                let action = ArticleDetailState.UserArticleDetailErrorAction(error: result.error!)
                mainStore.dispatch(action)
                return
            }
            actions.forEach { mainStore.dispatch($0) }
            mainStore.dispatch(LoadingState.LoadingAction(isLoading: false))
            self?.fetchStockStatus()
        }
        mainStore.dispatch(actionCreator)
        
    }
    
    private func fetchStockStatus() {
        
        guard userArticleDetailState.hasArticleDetailData() else { return }
        if userArticleDetailState.hasStockStatus() || userArticleDetailState.fetchingStockStatus { return }
        
        mainStore.dispatch(ArticleDetailState.UserArticleDetailFetchingStockStatusAction(fetchingStockStatus: true))
        mainStore.dispatch(LoadingState.LoadingAction(isLoading: true))
        let actionCreator = QiitaAPIActionCreator.call(GetArticleStockStatus(id: userArticleDetailState.articleId)) { result in
            let hasStock: Bool = result.value != nil
            let action = ArticleDetailState.UserArticleDetailHasStockAction(hasStock: hasStock)
            mainStore.dispatch(action)
            
            mainStore.dispatch(ArticleDetailState.UserArticleDetailFetchingStockStatusAction(fetchingStockStatus: false))
            mainStore.dispatch(LoadingState.LoadingAction(isLoading: false))
        }
        
        mainStore.dispatch(actionCreator)
        
    }
    
    private func updateStockStatus() {
        
        mainStore.dispatch(LoadingState.LoadingAction(isLoading: true))
        let actionCreator = QiitaAPIActionCreator.call(generateUpdateStockRequest()) { [weak self] result in
            mainStore.dispatch(LoadingState.LoadingAction(isLoading: false))
            guard let weakSelf = self else { return }
            let isStock = result.value != nil ? !weakSelf.userArticleDetailState.hasStock() : weakSelf.userArticleDetailState.hasStock()
            let action = ArticleDetailState.UserArticleDetailHasStockAction(hasStock: isStock)
            mainStore.dispatch(action)
        }
        mainStore.dispatch(actionCreator)
        
    }
    
    private func generateUpdateStockRequest() -> UpdateArticleStockStatus {
        let isStock = !userArticleDetailState.hasStock()
        let method: HTTPMethod = isStock ? .PUT : .DELETE
        return UpdateArticleStockStatus(id: userArticleDetailState.articleId, method: method)
    }
    
}

extension UserArticleDetailTableViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let height = webView.scrollView.contentSize.height
        if webViewHeight == height {
            return
        }
        webViewHeight = height
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Fade)
        
    }
    
}