//
//  ArticleDetailTableViewController.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/01.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit
import ReSwift
import APIKit

class ArticleDetailTableViewController: UITableViewController, NavigationBarProtocol {

    private var articleDetailState: ArticleDetailState {
        return mainStore.state.articleDetail
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
        mainStore.dispatch(ArticleDetailState.ArticleDetailResetAction())
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return articleDetailState.fetchTableSectionCount()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleDetailState.fetchTableSectionRowCount()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.articleDetailTopInfoCell, forIndexPath: indexPath)!
            cell.articleInfo = articleDetailState.fetchArticleDetailTopInfo()
            cell.selectedUserAction = { [weak self] userId in
                self?.segueUserArticleList(userId)
            }
            cell.updateStockButtonAction = { [weak self] in
                self?.updateStockStatus()
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.articleDetailBodyCell, forIndexPath: indexPath)!
        cell.htmlWebView.delegate = self
        cell.loadRenderHtmlBody(articleDetailState.fetchHtmlBody())
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
    
    private func segueUserArticleList(userId: String) {
        mainStore.dispatch(UserArticleListState.UserArticleListUserIdAction(userId: userId))
        let vc = R.storyboard.userArticleList.initialViewController()!
        vc.inject(mainStore.state.userArticleList)
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ArticleDetailTableViewController {
    
    private func fetchArticleDetail() {
        
        mainStore.dispatch(LoadingState.LoadingAction(isLoading: true))
        let tasks = QiitaAPIActionCreator.fetchArticleDetailInfoActionTasks(articleDetailState.articleId, actionType: .DetailFromAllList)
        let actionCreator = QiitaAPIActionCreator.call(tasks) { [weak self] result in
            guard let actions = result.value else {
                let action = ArticleDetailState.ArticleDetailErrorAction(error: result.error!)
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
        
        mainStore.dispatch(LoadingState.LoadingAction(isLoading: true))
        mainStore.dispatch(ArticleDetailState.ArticleDetailFetchingStockStatusAction(fetchingStockStatus: true))
        let actionCreator = QiitaAPIActionCreator.call(GetArticleStockStatus(id: articleDetailState.articleId)) { result in
            
            mainStore.dispatch(LoadingState.LoadingAction(isLoading: false))
            mainStore.dispatch(ArticleDetailState.ArticleDetailFetchingStockStatusAction(fetchingStockStatus: false))
            let hasStock = result.value != nil
            let action = ArticleDetailState.ArticleDetailHasStockAction(hasStock: hasStock)
            mainStore.dispatch(action)
            
        }
        mainStore.dispatch(actionCreator)
        
    }
    
    private func updateStockStatus() {
        
        mainStore.dispatch(LoadingState.LoadingAction(isLoading: true))
        let actionCreator = QiitaAPIActionCreator.call(generateUpdateStockRequest()) { [weak self] result in
            mainStore.dispatch(LoadingState.LoadingAction(isLoading: false))
            guard let weakSelf = self else { return }
            let isStock = result.value != nil ? !weakSelf.articleDetailState.hasStock() : weakSelf.articleDetailState.hasStock()
            let action = ArticleDetailState.ArticleDetailHasStockAction(hasStock: isStock)
            mainStore.dispatch(action)
        }
        mainStore.dispatch(actionCreator)
        
    }
    
    private func generateUpdateStockRequest() -> UpdateArticleStockStatus {
        let isStock = !articleDetailState.hasStock()
        let method: HTTPMethod = isStock ? .PUT : .DELETE
        return UpdateArticleStockStatus(id: articleDetailState.articleId, method: method)
    }
    
}

//MARK: StoreSubscriber
extension ArticleDetailTableViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        guard articleDetailState.isReloadView() else {
            return
        }
        tableView.reloadData()
    }
    
}

//MARK: UIWebViewDelegate
extension ArticleDetailTableViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        let height = webView.scrollView.contentSize.height
        if webViewHeight == height {
            return
        }
        webViewHeight = height
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)], withRowAnimation: .Fade)
        
    }
    
}


