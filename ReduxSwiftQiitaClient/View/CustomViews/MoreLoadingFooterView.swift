//
//  MoreLoadingFooterView.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/05/31.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit

class MoreLoadingFooterView: UIView {

    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    func updateIndicatorView(showIndicator: Bool) {
        showIndicator ? showIndicatorView() : hideIndicatorView()
    }
    
    private func showIndicatorView() {
        loadingIndicator.hidden = false
        loadingIndicator.startAnimating()
        frame.size.height = 44.0
    }
    
    private func hideIndicatorView() {
        loadingIndicator.hidden = true
        loadingIndicator.stopAnimating()
        frame.size.height = 0.0
    }

}
