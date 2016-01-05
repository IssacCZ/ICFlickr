//
//  ViewController.swift
//  ICFlickr
//
//  Created by IssacCZ on 1/4/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        let imageView:UIImageView = UIImageView()
        imageView.frame = view.bounds
        imageView.image = UIImage(named: "Icon-1024")
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        view.addSubview(imageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

