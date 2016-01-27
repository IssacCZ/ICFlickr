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
    
    /// 用户头像
    @IBOutlet weak var UserAvatar: UIImageView!
    /// 用户昵称或登录按钮
    @IBOutlet weak var loginButton: UIButton!
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
                        let userInfoAPI = FKFlickrPeopleGetInfo()
                        userInfoAPI.user_id = userId
                        FlickrKit.sharedFlickrKit().call(userInfoAPI, completion: { (response, error) -> Void in
                            print(response)
                            print(response["realname"] as? String)
                            self.loginButton.setTitle(response["realname"] as? String, forState: UIControlState.Normal)
                            let iconURL = FlickrKit.sharedFlickrKit().buddyIconURLForUser(userId)
                            self.UserAvatar.sd_setImageWithURL(iconURL)
                        })
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
                    let userInfoAPI = FKFlickrPeopleGetInfo()
                    userInfoAPI.user_id = userId
                    FlickrKit.sharedFlickrKit().call(userInfoAPI, completion: { (response, error) -> Void in
                        print(response)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            var dic0 = response["person"] as! [String: AnyObject]
                            var dic1 = dic0["realname"] as! [String: AnyObject]
                            let realName = dic1["_content"] as! String
                            print(realName)
                            self.loginButton.setTitle(realName, forState: UIControlState.Normal)
                            let iconURL = FlickrKit.sharedFlickrKit().buddyIconURLForUser(userId)
                            self.UserAvatar.sd_setImageWithURL(iconURL)
                            self.UserAvatar.layer.cornerRadius = 27.5
                            self.UserAvatar.clipsToBounds = true
                        })
                    })
                } else {
                    self.loginButton.setTitle("login", forState: UIControlState.Normal)
                }
            });
        }
    }
}
