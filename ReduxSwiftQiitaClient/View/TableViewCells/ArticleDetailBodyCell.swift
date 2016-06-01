//
//  ArticleDetailBodyCell.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/01.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit

class ArticleDetailBodyCell: UITableViewCell {

    @IBOutlet weak var htmlWebView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadRenderHtmlBody(html: String) {
        htmlWebView.loadHTMLString(html, baseURL: nil)
    }

}
