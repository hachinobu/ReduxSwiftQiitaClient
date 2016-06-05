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

    private var articleDetailState = ArticleDetailState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainStore.subscribe(self)
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        

        // Configure the cell...

        return cell
    }


}

//MARK: StoreSubscriber
extension ArticleDetailTableViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        
    }
    
}

//MARK: State更新時に呼ばれる
extension ArticleDetailTableViewController {
    
    private func fetchArticleDetail() {
        if articleDetailState.hasArticleDetailData() {
            return
        }
        
        mainStore.dispatch(FetchAction(isFetch: true))
        let actionCreator = QiitaAPIActionCreator.fetchArticleDetailInfo(articleDetailState.articleId) { store in
            store.dispatch(FetchAction(isFetch: false))
        }
        mainStore.dispatch(actionCreator)
    }
    
}