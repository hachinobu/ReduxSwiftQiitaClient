//
//  ArticleListTableViewController.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/24.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit
import APIKit
import ReSwift
import Kingfisher

private extension Selector {
    static let pullToRefresh = #selector(ArticleListTableViewController.refreshData)
}

class ArticleListTableViewController: UITableViewController {

    private var homeState = HomeState() {
        didSet {
            if homeState.hasError() {
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupUI() {
        title = "ホーム"
        tableView.addSubview(refreshUI)
        refreshUI.addTarget(self, action: .pullToRefresh, forControlEvents: .ValueChanged)
    }
    
    func refreshData() {
        mainStore.dispatch(RefreshAction(true))
        mainStore.dispatch(LoadingAction(isLoading: true))
        let actionCreator = QiitaAPIActionCreator.fetchAllArticleList { [unowned self] store in
            let refreshAction = RefreshAction(false, articleVMList: self.homeState.articleVMList, pageNumber: self.homeState.pageNumber)
            store.dispatch(refreshAction)
            store.dispatch(LoadingAction(isLoading: false))
        }
        mainStore.dispatch(actionCreator)
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeState.fetchArticleListCount()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(R.reuseIdentifier.articleListCell, forIndexPath: indexPath)!
        let viewModel = homeState.fetchArticleVM(indexPath.row)
        cell.updateCell(viewModel)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.row == homeState.fetchArticleListEndIndex() && !homeState.showMoreLoading else { return }
        
        mainStore.dispatch(ShowMoreLoadingAction(true))
        let actionCreator = QiitaAPIActionCreator.fetchMoreArticleList { store in
            store.dispatch(ShowMoreLoadingAction(false))
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
        let articleVM = homeState.fetchArticleVM(indexPath.row)
        let action = ArticleDetailIdAction(articleId: articleVM.fetchId())
        mainStore.dispatch(action)
        let vc = R.storyboard.articleDetail.initialViewController()!
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: StoreSubscriber
extension ArticleListTableViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        homeState = state.home
    }
    
}

//MARK: Stateが更新された時に呼ばれる処理
extension ArticleListTableViewController {
    
    private func showErrorDialog() {
        let alert = UIAlertController(title: "エラー", message: homeState.fetchErrorMessage(), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func expireCache() {
        guard homeState.isRefresh && homeState.fetchArticleListCount() == 0 else { return }
        KingfisherManager.sharedManager.cache.clearMemoryCache()
        KingfisherManager.sharedManager.cache.clearDiskCache()
    }
    
    private func updateMoreLoadingIndicator() {
        moreLoadingFooterView.updateIndicatorView(homeState.showMoreLoading)
    }
    
    private func reloadView() {
        guard homeState.fetchArticleListCount() > 0 else { return }
        if homeState.showMoreLoading || homeState.isRefresh { return }
        tableView.reloadData()
        refreshUI.endRefreshing()
    }
    
}




