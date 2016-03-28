//
//  PhotoInfoVC.swift
//  ICFlickr
//
//  Created by 李焯财 on 2/17/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit

class PhotoInfoVC: UIViewController {

    var photo: String?
    var ratio:CGFloat = 1.0
    var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.whiteColor()
        photoView = UIImageView()
        view.addSubview(photoView)
        let hhh = (ratio < 1.1) ? 375 : AppUtil.currentWidth() / ratio
        photoView.frame.size = CGSize(width: AppUtil.currentWidth(), height: hhh)
        photoView.frame.origin = CGPoint(x: 0, y: 70)
        photoView.sd_setImageWithURL(NSURL(string: photo!))
        photoView.clipsToBounds = true
        photoView.contentMode = .ScaleAspectFill
        photoView.backgroundColor = UIColor.lightGrayColor()
        
        print(photoView.frame)
    }
}
