//
//  ArticleDetailTopInfoCell.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/01.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit
import Kingfisher

private extension Selector {
    static let stockButtonTapped = #selector(ArticleDetailTopInfoCell.stockButtonAction)
    static let userNameTapped = #selector(ArticleDetailTopInfoCell.tappedUserName)
}

class ArticleDetailTopInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var postInfoLabel: UILabel!
    @IBOutlet weak var stockCountLabel: UILabel!
    @IBOutlet weak var stockButton: UIButton!
    var articleInfo: (articleDetail: ArticleModel, stockCount: String, stockStatus: StockStatus)? {
        didSet {
            updateCell()
        }
    }
    var selectedUserAction: ((userId: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stockButton.layer.cornerRadius = 4.0
        stockButton.addTarget(self, action: .stockButtonTapped, forControlEvents: .TouchUpInside)
        userNameButton.addTarget(self, action: .userNameTapped, forControlEvents: .TouchUpInside)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func stockButtonAction() {
        guard let articleInfo = articleInfo else { return }
        let isStock = !articleInfo.stockStatus.isStock
        mainStore.dispatch(QiitaAPIActionCreator.updateStockStatus(articleInfo.articleDetail.fetchId(), toStock: isStock, finishHandler: nil))
    }
    
    func tappedUserName() {
        guard let userId = articleInfo?.articleDetail.fetchUserId() else { return }
        selectedUserAction?(userId: userId)
    }
    
    private func updateCell() {
        guard let articleInfo = articleInfo else { return }
        let article = articleInfo.articleDetail
        titleLabel.text = article.fetchArticleTitle()
        tagLabel.text = article.fetchTags()
        userNameButton.setTitle(article.fetchUserId(), forState: .Normal)
        postInfoLabel.text = " が投稿しました"
        stockCountLabel.text = articleInfo.stockCount
        updateStockButtonStatus(articleInfo.stockStatus)
        
        guard let downloadURL = article.fetchDownloadURL() else { return }
        let resource = Resource(downloadURL: downloadURL, cacheKey: article.fetchId())
        downloadProfileImage(resource)
    }
    
    private func updateStockButtonStatus(stockStatus: StockStatus) {
        stockButton.setTitle(stockStatus.fetchStockStatusTitle(), forState: .Normal)
        stockButton.setTitleColor(stockStatus.fetchTextColor(), forState: .Normal)
        stockButton.backgroundColor = stockStatus.fetchBackgroundColor()
    }
    
    private func downloadProfileImage(resource: Resource) {
        profileImageView.kf_showIndicatorWhenLoading = true
        profileImageView.kf_setImageWithResource(resource, placeholderImage: nil, optionsInfo: [.Transition(ImageTransition.Fade(1))], progressBlock: nil, completionHandler: nil)
    }

}
