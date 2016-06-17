//
//  NavigationBarProtocol.swift
//  ReduxSwiftQiitaClient
//
//  Created by Takahiro Nishinobu on 2016/06/20.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit

protocol NavigationBarProtocol {
}

extension NavigationBarProtocol where Self: UIViewController {
    
    func setupBackBarButton() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
}