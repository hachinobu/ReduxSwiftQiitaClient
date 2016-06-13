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

class UserArticleListViewController: UITableViewController {

    var userArticleListState = UserArticleListState() {
        didSet {
            if userArticleListState.hasError() {
                showErrorDialog()
                return
            }
            expireCache()
            updateMoreLoadingIndicator()
            reloadView()
        }
    }
    
    @IBOutlet weak var moreLoadingFooterView: MoreLoadingFooterView!
    let refreshUI = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStore.subscribe(self)
        setupUI()
        refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupUI() {
        title = "投稿一覧"
        tableView.addSubview(refreshUI)
        refreshUI.addTarget(self, action: .pullToRefresh, forControlEvents: .ValueChanged)
    }
    
    func refreshData() {
        mainStore.dispatch(UserArticleListRefreshAction(isRefresh: true))
        mainStore.dispatch(LoadingAction(isLoading: true))
        let actionCreator = QiitaAPIActionCreator.fetchUserAllArticleList(userArticleListState.userId) { [unowned self] store in
            let refreshAction = UserArticleListRefreshAction(isRefresh: false, articleVMList: self.userArticleListState.articleVMList, pageNumber: self.userArticleListState.pageNumber)
            store.dispatch(refreshAction)
            store.dispatch(LoadingAction(isLoading: false))
        }
        mainStore.dispatch(actionCreator)
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArticleListState.fetchArticleListCount()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.userArticleListCell, forIndexPath: indexPath)!
        cell.updateCell(userArticleListState.fetchArticleVM(indexPath.row))
        return cell
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.row == userArticleListState.fetchArticleListEndIndex() && !userArticleListState.showMoreLoading && !userArticleListState.finishMoreUserArticle else { return }
        
        mainStore.dispatch(UserArticleListShowMoreLoadingAction(showMoreLoading: true))
        let actionCreator = QiitaAPIActionCreator.fetchMoreUserArticleList(userArticleListState.userId, finishHandler: { store in
            store.dispatch(UserArticleListShowMoreLoadingAction(showMoreLoading: false))
        })
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
        let articleVM = userArticleListState.fetchArticleVM(indexPath.row)
        let action = ArticleDetailIdAction(articleId: articleVM.fetchId())
        mainStore.dispatch(action)
        let vc = R.storyboard.articleDetail.initialViewController()!
        navigationController?.pushViewController(vc, animated: true)
    }

}

//MARK: StoreSubscriber
extension UserArticleListViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        userArticleListState = state.userArticleList
    }
    
}

//MARK: Stateが更新された時に呼ばれる処理
extension UserArticleListViewController {
    
    private func showErrorDialog() {
        let alert = UIAlertController(title: "エラー", message: userArticleListState.fetchErrorMessage(), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func expireCache() {
        guard userArticleListState.isRefresh && userArticleListState.fetchArticleListCount() == 0 else { return }
        KingfisherManager.sharedManager.cache.clearMemoryCache()
        KingfisherManager.sharedManager.cache.clearDiskCache()
    }
    
    private func updateMoreLoadingIndicator() {
        moreLoadingFooterView.updateIndicatorView(userArticleListState.showMoreLoading)
    }
    
    private func reloadView() {
        guard userArticleListState.fetchArticleListCount() > 0 else { return }
        if userArticleListState.showMoreLoading || userArticleListState.isRefresh { return }
        tableView.reloadData()
        refreshUI.endRefreshing()
    }
    
}
