//
//  AppUtil.swift
//  ICFlickr
//
//  Created by IssacCZ on 1/5/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit

/// 类方法形式实现小功能点
class AppUtil: NSObject {
    /**
     获取当前屏幕宽度
     
     - returns: 。
     */
    class func currentWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    /**
     获取当前屏幕高度
     
     - returns: 。
     */
    class func currentHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }
}
