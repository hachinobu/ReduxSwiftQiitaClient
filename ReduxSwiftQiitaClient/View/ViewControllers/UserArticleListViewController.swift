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

private extension Selector {
    static let pullToRefresh = #selector(UserArticleListViewController.refreshData)
}

class UserArticleListViewController: UITableViewController, NavigationBarProtocol {
    
    @IBOutlet weak var moreLoadingFooterView: MoreLoadingFooterView!
    let refreshUI = UIRefreshControl()
    
    var listState: ArticleListScreenStateProtocol!
    
    func inject(listState: ArticleListScreenStateProtocol!) {
        self.listState = listState
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
        mainStore.dispatch(UserArticleListState.UserResetArticleStateAction())
    }
    
    private func setupUI() {
        title = "投稿一覧"
        setupBackBarButton()
        tableView.addSubview(refreshUI)
        refreshUI.addTarget(self, action: .pullToRefresh, forControlEvents: .ValueChanged)
    }
    
    func refreshData() {
        
        mainStore.dispatch(LoadingState.LoadingAction(isLoading: true))
        mainStore.dispatch(UserArticleListState.UserArticleListRefreshAction(isRefresh: true, pageNumber: 1))
        
        let actionCreator = QiitaAPIActionCreator.call(generateUserAllArticleList()) { [weak self] result in
            
            mainStore.dispatch(LoadingState.LoadingAction(isLoading: false))
            let pageNumber = self?.listState.pageNumber ?? 1
            mainStore.dispatch(UserArticleListState.UserArticleListRefreshAction(isRefresh: false, pageNumber: pageNumber))
            let action = UserArticleListState.UserArticleResultAction(result: result)
            mainStore.dispatch(action)
            
        }
        mainStore.dispatch(actionCreator)
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
        
        mainStore.dispatch(UserArticleListState.UserArticleListShowMoreLoadingAction(showMoreLoading: true))
        let actionCreator = QiitaAPIActionCreator.call(generateUserAllArticleList()) { result in
            
            mainStore.dispatch(UserArticleListState.UserArticleListShowMoreLoadingAction(showMoreLoading: false))
            let action: Action
            if result.value?.articleModels?.count == 0 {
                action = UserArticleListState.UserFinishMoreArticleAction(finishMoreUserArticle: true)
            }
            else {
                action = UserArticleListState.UserMoreArticleResultAction(result: result)
            }
            
            mainStore.dispatch(action)
        }
        
        mainStore.dispatch(actionCreator)
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
        let action = ArticleDetailState.UserArticleDetailIdAction(articleId: article.fetchId())
        mainStore.dispatch(action)
        let vc = R.storyboard.userArticleDetail.initialViewController()!
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension UserArticleListViewController {
    
    private func generateUserAllArticleList() -> GetUserArticleEndpoint {
        return GetUserArticleEndpoint(userId: listState.userId, queryParameters: ["per_page": 20, "page": listState.pageNumber])
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
