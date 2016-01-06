//
//  ViewController.swift
//  ICFlickr
//
//  Created by IssacCZ on 1/4/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var favorites: PHFetchResult?
    var fixModel = [PhotoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultValues()
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDefaultValues() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let smartAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .AlbumRegular, options: nil)
        let collection: PHCollection = smartAlbums[3] as! PHCollection
        print("\(collection.localizedTitle)")
        
        let assetCollection: PHAssetCollection = collection as! PHAssetCollection
        favorites = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: nil)
        fixImageRatio()
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
        view.addSubview(collectionView)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (favorites?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        cell.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        let imageView:UIImageView = UIImageView()
        imageView.frame = cell.bounds
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        cell.addSubview(imageView)
        
        let asset: PHAsset = favorites![indexPath.item] as! PHAsset
        print("\(asset.pixelWidth), \(asset.pixelHeight)")
        
        let imageManager: PHImageManager = PHImageManager()
        imageManager.requestImageForAsset(asset, targetSize: CGSize(width: 500, height: 500), contentMode: PHImageContentMode.AspectFill, options: nil) { (cellImage, info) -> Void in
            imageView.image = cellImage
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let model = fixModel[indexPath.row] 
        return CGSize(width: model.width, height: model.height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photoDetailVC = IFPhotoDetailVC()
        photoDetailVC.asset = favorites![indexPath.item] as? PHAsset
        navigationController?.pushViewController(photoDetailVC, animated: true)
    }
    
    func fixImageRatio() {
        let usedScreenWidth: CGFloat = AppUtil.currentWidth() - 4.0
        let minHeightLimit: CGFloat = usedScreenWidth / 4.0
        let margin: CGFloat = 2.0
        
        var index: Int
        for index = 0; index < favorites!.count; index++ {
            let asset: PHAsset = favorites![index] as! PHAsset
            let height: CGFloat = (CGFloat)(asset.pixelHeight)
            let width: CGFloat = (CGFloat)(asset.pixelWidth)
            let scale: CGFloat = minHeightLimit / (CGFloat)(asset.pixelHeight)
            
            let model = PhotoModel()
            model.height = height * scale
            model.width = width * scale
            fixModel.append(model)
        }
        
        var i: Int
        for i = 0 ; i < fixModel.count; i++ {
            if i + 2 < fixModel.count {
                let model0 = fixModel[i]
                let model1 = fixModel[i + 1]
                let model2 = fixModel[i + 2]
                
                if (model0.width > usedScreenWidth || model0.width + margin + model1.width > usedScreenWidth) {
                    let rowScale = usedScreenWidth / model0.width
                    model0.width = model0.width * rowScale
                    model0.height = model0.height * rowScale
                    fixModel[i] = model0
                } else if (model0.width + margin + model1.width <= usedScreenWidth && model0.width + margin + model1.width + margin + model2.width > usedScreenWidth) {
                    let totalWidth = model0.width + model1.width
                    let rowScale = (usedScreenWidth - margin) / totalWidth
                    model0.width = model0.width * rowScale
                    model0.height = model0.height * rowScale
                    fixModel[i] = model0
                    
                    model1.width = model1.width * rowScale
                    model1.height = model1.height * rowScale
                    fixModel[i + 1] = model1
                    i += 1
                } else {
                    let totalWidth = model0.width + model1.width + model2.width
                    let rowScale = (usedScreenWidth - margin * 2) / totalWidth
                    model0.width = model0.width * rowScale
                    model0.height = model0.height * rowScale
                    fixModel[i] = model0
                    
                    model1.width = model1.width * rowScale
                    model1.height = model1.height * rowScale
                    fixModel[i + 1] = model1
                    
                    model2.width = model2.width * rowScale
                    model2.height = model2.height * rowScale
                    fixModel[i + 2] = model2
                    i += 2
                }
            } else if (i + 1 < fixModel.count) {
                let model0 = fixModel[i]
                let model1 = fixModel[i + 1]
                
                if (model0.width + margin + model1.width > usedScreenWidth) {
                    let rowScale = usedScreenWidth / model0.width
                    model0.width = model0.width * rowScale
                    model0.height = model0.height * rowScale
                    fixModel[i] = model0
                } else {
                    let totalWidth = model0.width + model1.width
                    let rowScale = (usedScreenWidth - margin) / totalWidth
                    model0.width = model0.width * rowScale
                    model0.height = model0.height * rowScale
                    fixModel[i] = model0
                    
                    model1.width = model1.width * rowScale
                    model1.height = model1.height * rowScale
                    
                    fixModel[i + 1] = model1
                    i += 1;
                }
            } else {
                let model0 = fixModel[i]
                let rowScale = usedScreenWidth / model0.width;
                model0.width = model0.width * rowScale;
                model0.height = model0.height * rowScale;
                fixModel[i] = model0
            }
        }
    }
    
}
