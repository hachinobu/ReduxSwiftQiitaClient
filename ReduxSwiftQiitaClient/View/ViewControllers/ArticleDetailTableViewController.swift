//
//  ArticleDetailTableViewController.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/01.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit
import ReSwift

class ArticleDetailTableViewController: UITableViewController {

    private var articleDetailState = ArticleDetailState() {
        didSet {
            fetchStockStatus()
            tableView.reloadData()
        }
    }
    var webViewHeight: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStore.subscribe(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchArticleDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    private func fetchArticleDetail() {
        
        mainStore.dispatch(FetchAction(isFetch: true))
        let actionCreator = QiitaAPIActionCreator.fetchArticleDetailInfo(articleDetailState.articleId) { [weak self] store in
            store.dispatch(FetchAction(isFetch: false))
            self?.tableView.reloadData()
        }
        mainStore.dispatch(actionCreator)
    }

}

//MARK: StoreSubscriber
extension ArticleDetailTableViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        articleDetailState = state.articleDetail
    }
    
}

//MARK: State更新時に呼ばれる
extension ArticleDetailTableViewController {
    
    private func fetchStockStatus() {
        
        guard articleDetailState.hasArticleDetailData() else { return }
        if articleDetailState.hasStockStatus() || articleDetailState.fetchingStockStatus { return }
        
        mainStore.dispatch(FetchingStockStatusAction(fetchingStockStatus: true))
        mainStore.dispatch(FetchAction(isFetch: true))
        let actionCreator = QiitaAPIActionCreator.fetchArticleStockStatus(articleDetailState.articleId) { [weak self] store in
            mainStore.dispatch(FetchingStockStatusAction(fetchingStockStatus: false))
            store.dispatch(FetchAction(isFetch: false))
            self?.tableView.reloadData()
        }
        mainStore.dispatch(actionCreator)
    }
    
}

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


