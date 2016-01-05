//
//  ViewController.swift
//  ICFlickr
//
//  Created by IssacCZ on 1/4/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUI() {
        view.backgroundColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.reloadData()
        collectionView.backgroundColor = UIColor.whiteColor()
        view.addSubview(collectionView);
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
//        cell.frame = CGRect(x: 0, y: 0, width: (AppUtil.currentWidth() - 2 * 4) / 3, height: (AppUtil.currentWidth() - 2 * 4) / 3)
        
        let imageView:UIImageView = UIImageView()
        imageView.frame = cell.bounds
        imageView.image = UIImage(named: "Icon-1024")
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        cell.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 2, bottom: 2, right: 2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (AppUtil.currentWidth() - 2 * 4) / 3, height: (AppUtil.currentWidth() - 2 * 4) / 3)
    }
}
