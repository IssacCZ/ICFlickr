//
//  TopHitVC.swift
//  ICFlickr
//
//  Created by 李焯财 on 1/17/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit
import FlickrKit

class TopHitVC: UIViewController {
    var photoURLs = [NSURL]()
    var titles = [String]()
    var tableView: UITableView!
    
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
                print(response)
                let topPhotos = response["photos"] as! [NSObject: AnyObject]
                let photoArray = topPhotos["photo"] as! [[NSObject: AnyObject]]
                for photoDictionary in photoArray {
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

extension TopHitVC: UITableViewDelegate {

}
