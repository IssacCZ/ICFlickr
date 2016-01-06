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
    var scrollView: UIScrollView?
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView?.delegate = self
        scrollView?.maximumZoomScale = 3.0
        view.addSubview(scrollView!)
        
        imageView = UIImageView(frame: view.bounds)
        scrollView!.addSubview(imageView!)
        imageView!.contentMode = .ScaleAspectFit
        let imageManager: PHImageManager = PHImageManager()
        imageManager.requestImageForAsset(asset!, targetSize: CGSize(width: (asset?.pixelWidth)!, height: (asset?.pixelHeight)!), contentMode: PHImageContentMode.AspectFill, options: nil) { (cellImage, info) -> Void in
            self.imageView!.image = cellImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension IFPhotoDetailVC: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
