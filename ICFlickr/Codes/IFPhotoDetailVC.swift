//
//  IFPhotoDetailVC.swift
//  ICFlickr
//
//  Created by IssacCZ on 1/6/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit
import Photos

class IFPhotoDetailVC: UIViewController {

    var asset: PHAsset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        let imageView = UIImageView(frame: view.bounds)
        view.addSubview(imageView)
        imageView.contentMode = .ScaleAspectFit
        let imageManager: PHImageManager = PHImageManager()
        imageManager.requestImageForAsset(asset!, targetSize: CGSize(width: (asset?.pixelWidth)!, height: (asset?.pixelHeight)!), contentMode: PHImageContentMode.AspectFill, options: nil) { (cellImage, info) -> Void in
            imageView.image = cellImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
