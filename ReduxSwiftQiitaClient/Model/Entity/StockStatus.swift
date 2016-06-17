//
//  StockStatus.swift
//  ReduxSwiftQiitaClient
//
//  Created by Nishinobu.Takahiro on 2016/06/14.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import UIKit

struct StockStatus {
    
    let isStock: Bool
    
    func fetchBackgroundColor() -> UIColor {
        return isStock ? UIColor.greenColor() : UIColor.whiteColor()
    }
    
    func fetchTextColor() -> UIColor {
        return isStock ? UIColor.whiteColor() : UIColor.blackColor()
    }
    
    func fetchStockStatusTitle() -> String {
        return isStock ? "ストック済み" : "ストック"
    }
    
}