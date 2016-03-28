//
//  DeviczVC.swift
//  ICFlickr
//
//  Created by 李焯财 on 3/3/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit

class DeviczVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let url = NSURL(string: "http://www.devicz.com")
        let request = NSMutableURLRequest(URL: url!)
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
