//
//  TopHitVC.swift
//  ICFlickr
//
//  Created by 李焯财 on 1/17/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit
import FlickrKit

/// 最近最热照片
class TopHitVC: UIViewController {
    /// 图片URL数组
    var photoURLs = [NSURL]()
    /// 图片标题数组
    var titles = [String]()
    /// tableView, 展示最近照片
    var tableView: UITableView!
    
    var photoModels = [PhotoWithURL]()
    
    // MARK: - UIView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultValues()
        initUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 初始化设置
    func setDefaultValues() {
        loadFlickrPhotos()
    }
    
    func loadFlickrPhotos() {
        let fk = FlickrKit.sharedFlickrKit()
        let interesting = FKFlickrInterestingnessGetList()
        fk.call(interesting) { (response, error) -> Void in
            if (response != nil) {
                self.photoURLs.removeAll()
                self.titles.removeAll()
//                print(response)
                let topPhotos = response["photos"] as! [NSObject: AnyObject]
                let photoArray = topPhotos["photo"] as! [[NSObject: AnyObject]]
                for photoDictionary in photoArray {
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
                                    photoModel.URL = single["url"] as! String
                                    let width = "\(single["width"])"
                                    if let fw = NSNumberFormatter().numberFromString(width) {
                                        photoModel.width = CGFloat(fw)
                                    }
//                                    photoModel.width = single["width"] as! CGFloat
                                    let height = "\(single["height"])"
                                    if let fh = NSNumberFormatter().numberFromString(height) {
                                        photoModel.height = CGFloat(fh)
                                    }
                                    photoModel.ratio = photoModel.width / photoModel.height
                                    
                                    self.photoModels.append(photoModel)
                                }
                            }
                        }
                    })
                    
                    let photoURL = FlickrKit.sharedFlickrKit().photoURLForSize(FKPhotoSizeSmall320, fromPhotoDictionary: photoDictionary)
                    let title = photoDictionary["title"] as! String
                    
                    self.titles.append(title)
                    self.photoURLs.append(photoURL)
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    func initUI() {
        view.backgroundColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = .None
        view.addSubview(tableView)
    }
}

// MARK: - UITableViewDataSource
extension TopHitVC: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoURLs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        let label = UILabel()
        label.frame = CGRect(x: 15, y: cell.frame.size.height - 15 - 20, width: AppUtil.currentWidth() - 30, height: 20)
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(20)
        label.text = titles[indexPath.row]
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        label.sizeToFit()
        
        let imageView:UIImageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 1, width: AppUtil.currentWidth(), height: cell.frame.size.height - 2)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.sd_setImageWithURL(photoURLs[indexPath.row])
        cell.addSubview(imageView)
        
        cell.insertSubview(label, aboveSubview: imageView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AppUtil.currentWidth() * 9 / 21.0
    }
}

// MARK: - UITableViewDelegate
extension TopHitVC: UITableViewDelegate {

}
