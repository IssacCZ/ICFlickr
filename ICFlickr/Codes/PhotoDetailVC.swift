//
//  PhotoDetailVC.swift
//  ICFlickr
//
//  Created by IssacCZ on 1/6/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit
import Photos

/// 本地相册单张详情，已弃用
class PhotoDetailVC: UIViewController {

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
        imageView?.center = CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height / 2 - 32)
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

extension PhotoDetailVC: UIScrollViewDelegate {
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
