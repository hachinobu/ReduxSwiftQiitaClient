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

class ArticleListTableViewController: UITableViewController, NavigationBarProtocol {

    private var homeState: HomeState {
        return mainStore.state.home
    }
    
    @IBOutlet weak var moreLoadingFooterView: MoreLoadingFooterView!
    let refreshUI = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mainStore.subscribe(self)
        refreshData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        mainStore.unsubscribe(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupUI() {
        title = "ホーム"
        setupBackBarButton()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        tableView.addSubview(refreshUI)
        refreshUI.addTarget(self, action: .pullToRefresh, forControlEvents: .ValueChanged)
    }
    
    func refreshData() {
        
        mainStore.dispatch(LoadingState.LoadingAction(isLoading: true))
        let refreshStartAction = HomeState.HomeRefreshAction(isRefresh: true, pageNumber: 1)
        mainStore.dispatch(refreshStartAction)
        
        let actionCreator = QiitaAPIActionCreator.call(generateAllArticleRequest()) { [weak self] result in
            
            let pageNumber = self?.homeState.pageNumber ?? 1
            let refreshEndAction = HomeState.HomeRefreshAction(isRefresh: false, pageNumber: pageNumber)
            mainStore.dispatch(refreshEndAction)
            mainStore.dispatch(LoadingState.LoadingAction(isLoading: false))
            
            let action = HomeState.HomeArticleResultAction(result: result)
            mainStore.dispatch(action)
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
        let article = homeState.fetchArticle(indexPath.row)
        cell.updateCell(article)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.row == homeState.fetchArticleListEndIndex() && !homeState.showMoreLoading else { return }
        
        mainStore.dispatch(HomeState.HomeShowMoreLoadingAction(showMoreLoading: true))
        let actionCreator = QiitaAPIActionCreator.call(generateAllArticleRequest()) { result in
            let action = HomeState.HomeMoreArticleResultAction(result: result)
            mainStore.dispatch(action)
            mainStore.dispatch(HomeState.HomeShowMoreLoadingAction(showMoreLoading: false))
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
        let article = homeState.fetchArticle(indexPath.row)
        let action = ArticleDetailState.ArticleDetailIdAction(articleId: article.fetchId())
        mainStore.dispatch(action)
        let vc = R.storyboard.articleDetail.initialViewController()!
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ArticleListTableViewController {
    
    private func expireCache() {
        KingfisherManager.sharedManager.cache.clearMemoryCache()
        KingfisherManager.sharedManager.cache.clearDiskCache()
    }
    
    private func generateAllArticleRequest() -> GetAllArticleEndpoint {
        return GetAllArticleEndpoint(queryParameters: ["per_page": 20, "page": homeState.pageNumber])
    }
    
}

//MARK: StoreSubscriber
extension ArticleListTableViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        
        if homeState.hasError() {
            showErrorDialog()
            return
        }
        
        if homeState.isRefresh && homeState.pageNumber == 1 {
            expireCache()
        }
        
        reloadView()
    }
    
}

//MARK: Stateが更新された時に呼ばれるView処理
extension ArticleListTableViewController {
    
    private func showErrorDialog() {
        let alert = UIAlertController(title: "エラー", message: homeState.fetchErrorMessage(), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func updateMoreLoadingIndicator() {
        moreLoadingFooterView.updateIndicatorView(homeState.showMoreLoading)
    }
    
    private func reloadView() {
        updateMoreLoadingIndicator()
        guard homeState.fetchArticleListCount() > 0 else { return }
        if homeState.showMoreLoading || homeState.isRefresh { return }
        tableView.reloadData()
        refreshUI.endRefreshing()
    }
    
}

