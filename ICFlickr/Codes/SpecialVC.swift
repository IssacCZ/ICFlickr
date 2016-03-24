//
//  SpecialVC.swift
//  ICFlickr
//
//  Created by 李焯财 on 2/15/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit
import FlickrKit

class SpecialVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var fixModel = [PhotoWithURL]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultValues()
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setDefaultValues() {
//        fixImageRatio()
        loadFlickrPhotos()
    }
    
    func loadFlickrPhotos() {
        let fk = FlickrKit.sharedFlickrKit()
        let interesting = FKFlickrInterestingnessGetList()
        fk.call(interesting) { (response, error) -> Void in
            if (response != nil) {
                self.fixModel.removeAll()
                let topPhotos = response["photos"] as! [NSObject: AnyObject]
                let photoArray = topPhotos["photo"] as! [[NSObject: AnyObject]]
                
                var i: Int
                for i = 0 ; i < photoArray.count; i++ {
                    let photoDictionary = photoArray[i]
                    let photoSize = FKFlickrPhotosGetSizes()
                    photoSize.photo_id = photoDictionary["id"] as! String
                    fk.call(photoSize, completion: { (response, error) -> Void in
                        if response != nil {
                            let sizes = response["sizes"] as! [String: AnyObject]
                            let size = sizes["size"] as! NSArray
                            for single in size {
                                let label = single["label"] as! String
                                if label == "Small 320" {
                                    print(single)
                                    let photoModel = PhotoWithURL()
                                    photoModel.URL = single["source"] as! String
                                    photoModel.photoID = photoSize.photo_id
                                    let fw = single["width"]
                                    if let intw = fw as? CGFloat {
                                        photoModel.width = intw
                                    } else {
                                        let wi = fw as? String
                                        photoModel.width = CGFloat((wi! as NSString).doubleValue)
                                    }
                                    
                                    let fh = single["height"]
                                    if let inth = fh as? CGFloat {
                                        photoModel.height = inth
                                    } else {
                                        let hi = fh as? String
                                        photoModel.height = CGFloat((hi! as NSString).doubleValue)
                                    }
                                    
                                    photoModel.ratio = photoModel.width / photoModel.height
                                    
                                    self.fixModel.append(photoModel)
                                    
                                    if self.fixModel.count == photoArray.count - 10 {
                                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                            self.fixImageRatio()
                                            self.collectionView.reloadData()
                                        })
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
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
        return fixModel.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        cell.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        struct User {
            let userID: String
            let username: String
            let avatarURLString: String
//            if let
//            URL = NSURL(string: avatarURLString),
//            data = NSData(contentsOfURL: URL),
//            image = UIImage(data: data) {
//                
//            }
        }
        
        let imageView:UIImageView = UIImageView()
        imageView.frame = cell.bounds
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        cell.addSubview(imageView)
        
        let model = fixModel[indexPath.item]
        imageView.backgroundColor = UIColor.yellowColor()
        imageView.sd_setImageWithURL(NSURL(string: model.URL))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let model = fixModel[indexPath.row]
        return CGSize(width: model.width, height: model.height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = fixModel[indexPath.item]
//        print(model.photoID)
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoInfoVC") as! PhotoInfoVC
        vc.photo = model.URL
        vc.ratio = model.ratio
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func fixImageRatio() {
        let usedScreenWidth: CGFloat = AppUtil.currentWidth() - 10.0
        let minHeightLimit: CGFloat = usedScreenWidth / 3.0
        let margin: CGFloat = 3.0
        
        var index: Int
        for index = 0; index < fixModel.count; index++ {
            let model = fixModel[index]
            let scale: CGFloat = minHeightLimit / model.height
            model.height = model.height * scale
            model.width = model.width * scale
            fixModel[index] = model
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
