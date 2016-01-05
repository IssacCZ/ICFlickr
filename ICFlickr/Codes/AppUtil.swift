//
//  AppUtil.swift
//  ICFlickr
//
//  Created by IssacCZ on 1/5/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit

class AppUtil: NSObject {

    class func isiPad() -> Bool {
        return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
    }
    
    class func currentWidth() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    class func currentHeight() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }
}
