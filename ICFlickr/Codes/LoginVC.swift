//
//  LoginVC.swift
//  ICFlickr
//
//  Created by IssacCZ on 1/24/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit
import FlickrKit

/// 登录页面，嵌入webView
class LoginVC: UIViewController {

    /// 嵌入webView
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FlickrKit.sharedFlickrKit().initializeWithAPIKey(FLICKR_API_KEY, sharedSecret: FLICKR_API_SECRET)
        
        loadWebView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hidesBottomBarWhenPushed = true
    }

    // MARK: WebView
    func loadWebView() {
        let callbackURLString = "icflickr://auth"
        
        let url = NSURL(string: callbackURLString)
        FlickrKit.sharedFlickrKit().beginAuthWithCallbackURL(url, permission: FKPermissionDelete, completion: { (url, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if ((error == nil)) {
                    let urlRequest = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 30)
                    self.webView.loadRequest(urlRequest)
                }
            });
        })
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let url = request.URL
        
        if  !(url?.scheme == "http") && !(url?.scheme == "https") {
            if (UIApplication.sharedApplication().canOpenURL(url!)) {
                UIApplication.sharedApplication().openURL(url!)
                return false
            }
        }
    
        return true
    }
}
