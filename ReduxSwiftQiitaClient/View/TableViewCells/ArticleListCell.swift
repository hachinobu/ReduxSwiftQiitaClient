//
//  ArticleListCell.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/24.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit
import Kingfisher

class ArticleListCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postedInfoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateCell(viewModel: ArticleVM) {
        postedInfoLabel.text = viewModel.fetchPostedInfo()
        titleLabel.text = viewModel.fetchArticleTitle()
        tagLabel.text = viewModel.fetchTags()
        
        guard let downloadURL = viewModel.fetchDownloadURL() else { return }
        let resource = Resource(downloadURL: downloadURL, cacheKey: viewModel.fetchId())
        downloadProfileImage(resource)
    }
    
    private func downloadProfileImage(resource: Resource) {
        profileImageView.kf_showIndicatorWhenLoading = true
        profileImageView.kf_setImageWithResource(resource, placeholderImage: nil, optionsInfo: [.Transition(ImageTransition.Fade(1))], progressBlock: nil, completionHandler: nil)
    }

}