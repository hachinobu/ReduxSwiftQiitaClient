//
//  UserArticleListViewController.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/13.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit
import ReSwift
import Kingfisher
import APIKit
import Result

private extension Selector {
    static let pullToRefresh = #selector(UserArticleListViewController.refreshData)
}

class UserArticleListViewController: UITableViewController, NavigationBarProtocol {
    
    @IBOutlet weak var moreLoadingFooterView: MoreLoadingFooterView!
    let refreshUI = UIRefreshControl()
    
    var listState: ArticleListScreenStateProtocol!
    var listActionCreator: ListStateActionCreaterProtocol!
    
    func inject(listState: ArticleListScreenStateProtocol!, listActionCreator: ListStateActionCreaterProtocol) {
        self.listState = listState
        self.listActionCreator = listActionCreator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        mainStore.subscribe(self)
        refreshData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        mainStore.dispatch(listActionCreator.generateResetListAction())
    }
    
    private func setupUI() {
        title = listState.title
        setupBackBarButton()
        tableView.addSubview(refreshUI)
        refreshUI.addTarget(self, action: .pullToRefresh, forControlEvents: .ValueChanged)
    }
    
    func refreshData() {
        
        mainStore.dispatch(LoadingState.LoadingAction(isLoading: true))
        mainStore.dispatch(listActionCreator.generateListRefreshAction(true, pageNumber: 1))
        
        let actionCreator: Store<AppState>.ActionCreator
        if listState.userId == nil {
            let request = GetAllArticleEndpoint(queryParameters: ["per_page": 20, "page": listState.pageNumber])
            actionCreator = QiitaAPIActionCreator.call(request) { [weak self] result in
                self?.refreshDataResponseHandler(result)
            }
        }
        else {
            let request = GetUserArticleEndpoint(userId: listState.userId, queryParameters: ["per_page": 20, "page": listState.pageNumber])
            actionCreator = QiitaAPIActionCreator.call(request) { [weak self] result in
                self?.refreshDataResponseHandler(result)
            }
        }
        
        mainStore.dispatch(actionCreator)
    }
    
    private func refreshDataResponseHandler(result: Result<ArticleListModel, SessionTaskError>) {
        mainStore.dispatch(LoadingState.LoadingAction(isLoading: false))
        let pageNumber = listState.pageNumber
        
        mainStore.dispatch(listActionCreator.generateListRefreshAction(false, pageNumber: pageNumber))
        let action = listActionCreator.generateListResultAction(result)
        mainStore.dispatch(action)
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listState.fetchArticleListCount()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.userArticleListCell, forIndexPath: indexPath)!
        cell.updateCell(listState.fetchArticle(indexPath.row))
        return cell
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.row == listState.fetchArticleListEndIndex() && !listState.showMoreLoading && !listState.finishMoreUserArticle else { return }
        
        mainStore.dispatch(listActionCreator.generateListShowMoreLoadingAction(true))
        let actionCreator: Store<AppState>.ActionCreator
        if listState.userId == nil {
            let request = GetAllArticleEndpoint(queryParameters: ["per_page": 20, "page": listState.pageNumber])
            actionCreator = QiitaAPIActionCreator.call(request) { [weak self] result in
                self?.moreListResponseHandler(result)
            }
        }
        else {
            let request = GetUserArticleEndpoint(userId: listState.userId, queryParameters: ["per_page": 20, "page": listState.pageNumber])
            actionCreator = QiitaAPIActionCreator.call(request) { [weak self] result in
                self?.moreListResponseHandler(result)
            }
        }
        
        mainStore.dispatch(actionCreator)
    }
    
    private func moreListResponseHandler(result: Result<ArticleListModel, SessionTaskError>) {
        mainStore.dispatch(listActionCreator.generateListShowMoreLoadingAction(false))
        let action: Store<AppState>.ActionCreator
        if result.value?.articleModels?.count == 0 {
            action = listActionCreator.generateFinishMoreListAction(true)
        }
        else {
            action = listActionCreator.generateMoreListResultAction(result)
        }
        mainStore.dispatch(action)
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let article = listState.fetchArticle(indexPath.row)
        let action = ArticleDetailState.ArticleDetailIdAction(articleId: article.fetchId())
        mainStore.dispatch(action)
        let vc = R.storyboard.articleDetail.initialViewController()!
        navigationController?.pushViewController(vc, animated: true)
    }

}

//MARK: StoreSubscriber
extension UserArticleListViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        
        if listState.userId == nil {
            listState = state.home
        }
        else {
            listState = state.userArticleList
        }
        
        if listState.hasError() {
            showErrorDialog()
            return
        }
        
        if listState.isRefresh && listState.pageNumber == 0 {
            expireCache()
        }
        
        reloadView()
    }
    
}

//MARK: Stateが更新された時に呼ばれる処理
extension UserArticleListViewController {
    
    private func showErrorDialog() {
        let alert = UIAlertController(title: "エラー", message: listState.fetchErrorMessage(), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func expireCache() {
        KingfisherManager.sharedManager.cache.clearMemoryCache()
        KingfisherManager.sharedManager.cache.clearDiskCache()
    }
    
    private func updateMoreLoadingIndicator() {
        moreLoadingFooterView.updateIndicatorView(listState.showMoreLoading)
    }
    
    private func reloadView() {
        updateMoreLoadingIndicator()
        guard listState.fetchArticleListCount() > 0 else { return }
        if listState.showMoreLoading || listState.isRefresh { return }
        tableView.reloadData()
        refreshUI.endRefreshing()
    }
    
}
