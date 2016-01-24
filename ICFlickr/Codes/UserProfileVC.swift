//
//  UserProfileVC.swift
//  ICFlickr
//
//  Created by IssacCZ on 1/24/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit
import FlickrKit

class UserProfileVC: UIViewController {
    var completeAuthOp: FKDUNetworkOperation!
    var checkAuthOp: FKDUNetworkOperation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkAuthentication()
    }
    
    func checkAuthentication() {
        NSNotificationCenter.defaultCenter().addObserverForName("UserAuthCallbackNotification", object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            let callBackURL: NSURL = notification.object as! NSURL
            self.completeAuthOp = FlickrKit.sharedFlickrKit().completeAuthWithURL(callBackURL, completion: { (userName, userId, fullName, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if ((error == nil)) {
                        print("登录返回，用户名是\(userName)，id是\(userId)")
                    }
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
                });
            })
        }
        
        // Check if there is a stored token - You should do this once on app launch
        self.checkAuthOp = FlickrKit.sharedFlickrKit().checkAuthorizationOnCompletion { (userName, userId, fullName, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if ((error == nil)) {
                    print("检查已登录，用户名是\(userName)，id是\(userId)")
                }
            });
        }
    }
}
