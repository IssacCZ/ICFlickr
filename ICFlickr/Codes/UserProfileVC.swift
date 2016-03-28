//
//  UserProfileVC.swift
//  ICFlickr
//
//  Created by IssacCZ on 1/24/16.
//  Copyright © 2016 Issac. All rights reserved.
//

import UIKit
import FlickrKit

/// 用户个人主页
class UserProfileVC: UIViewController {
    var completeAuthOp: FKDUNetworkOperation!
    var checkAuthOp: FKDUNetworkOperation!
    
    var photoURLs = [NSURL]()
    var titles = [String]()
    var times = [String]()
    var tableView: UITableView!
    
    /// 用户头像
    @IBOutlet weak var UserAvatar: UIImageView!
    /// 用户昵称或登录按钮
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - UIView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkAuthentication()
        
        initUI()
        
//        var total1 = 2.4;
//        var total2 = 0.8 * 4;
//        for index in 3...12 {
//            total1 += 1 + Double(Double(index) / 10.0)
//            print(total1)
//        }
//        
//        for index in 3...12 {
//            total2 += 0.8 * (1 + Double(Double(index) / 10.0))
//            print(total2)
//        }
//        
//        var total3 = 2.4;
//        for _ in 3...12 {
//            total3 += 1
//            print(total3)
//        }
    }

    // MARK: - 初始化设置
    func initUI() {
        view.backgroundColor = UIColor.whiteColor()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        tableView = UITableView(frame: CGRect(x: 0, y: 130 + 64, width: AppUtil.currentWidth(), height: AppUtil.currentHeight() - 130 - 64 - 44), style: .Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = .None
        view.addSubview(tableView)
    }
    
    func loadFlickrPhotos(uid: String) {
        let fk = FlickrKit.sharedFlickrKit()
        let interesting = FKFlickrPeopleGetPhotos()
        interesting.user_id = uid
        fk.call(interesting) { (response, error) -> Void in
            if (response != nil) {
                self.photoURLs.removeAll()
                self.titles.removeAll()
                self.times.removeAll()
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

    func checkAuthentication() {
        if let localUserName = NSUserDefaults.standardUserDefaults().valueForKey(kAPP_LOCAL_USER_NAME) {
            self.loginButton.setTitle(localUserName as? String, forState: .Normal)
        }
        if let localUserIconURL = NSUserDefaults.standardUserDefaults().valueForKey(kAPP_LOCAL_USER_ICON_URL) {
            let url = NSURL(string: localUserIconURL as! String)
            self.UserAvatar.sd_setImageWithURL(url)
            self.UserAvatar.layer.cornerRadius = 27.5
            self.UserAvatar.clipsToBounds = true
        }
        NSNotificationCenter.defaultCenter().addObserverForName("UserAuthCallbackNotification", object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            let callBackURL: NSURL = notification.object as! NSURL
            self.completeAuthOp = FlickrKit.sharedFlickrKit().completeAuthWithURL(callBackURL, completion: { (userName, userId, fullName, error) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if ((error == nil)) {
                        print("登录返回，用户名是\(userName)，id是\(userId)")
                        self.loadFlickrPhotos(userId)
                        let userInfoAPI = FKFlickrPeopleGetInfo()
                        userInfoAPI.user_id = userId
                        FlickrKit.sharedFlickrKit().call(userInfoAPI, completion: { (response, error) -> Void in
                            print(response)
                            print(response["realname"] as? String)
                            self.loginButton.setTitle(response["realname"] as? String, forState: UIControlState.Normal)
                            let iconURL = FlickrKit.sharedFlickrKit().buddyIconURLForUser(userId)
                            self.UserAvatar.sd_setImageWithURL(iconURL)
                        })
                    }
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
                });
            })
        }
        
        // Check if there is a stored token - You should do this once on app launch
        self.checkAuthOp = FlickrKit.sharedFlickrKit().checkAuthorizationOnCompletion { (userName, userId, fullName, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if ((error == nil)) {
                    print("检查已登录，用户名是\(userName)，id是\(userId)")
                    self.loadFlickrPhotos(userId)
                    let userInfoAPI = FKFlickrPeopleGetInfo()
                    userInfoAPI.user_id = userId
                    FlickrKit.sharedFlickrKit().call(userInfoAPI, completion: { (response, error) -> Void in
                        print(response)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            var dic0 = response["person"] as! [String: AnyObject]
                            var dic1 = dic0["realname"] as! [String: AnyObject]
                            let realName = dic1["_content"] as! String
                            print(realName)
                            self.loginButton.setTitle(realName, forState: UIControlState.Normal)
                            self.loginButton.tintColor = UIColor.blackColor()
                            let iconURL = FlickrKit.sharedFlickrKit().buddyIconURLForUser(userId)
                            self.UserAvatar.sd_setImageWithURL(iconURL)
                            self.UserAvatar.layer.cornerRadius = 27.5
                            self.UserAvatar.clipsToBounds = true
                            NSUserDefaults.standardUserDefaults().setObject(realName, forKey: kAPP_LOCAL_USER_NAME)
                            let localURL = "\(iconURL)"
                            NSUserDefaults.standardUserDefaults().setObject(localURL, forKey: kAPP_LOCAL_USER_ICON_URL)
                            NSUserDefaults.standardUserDefaults().synchronize()
                        })
                    })
                } else {
                    self.loginButton.setTitle("login", forState: UIControlState.Normal)
                }
            });
        }
    }
}

// MARK: - UITableViewDataSource
extension UserProfileVC: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return photoURLs.count
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        
        let label = UILabel()
        label.frame = CGRect(x: 15, y: 0, width: AppUtil.currentWidth() - 30, height: 44)
        label.textColor = UIColor.whiteColor()
        label.center.y = 22
        label.font = UIFont.systemFontOfSize(20)
        label.text = titles[section]
        header.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        label.sizeToFit()
        header.addSubview(label)
        
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
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
        label.text = titles[indexPath.section]
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        label.sizeToFit()
        
        let imageView:UIImageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 1, width: AppUtil.currentWidth(), height: cell.frame.size.height - 2)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        imageView.sd_setImageWithURL(photoURLs[indexPath.section])
        cell.addSubview(imageView)
        
//        cell.insertSubview(label, aboveSubview: imageView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return AppUtil.currentWidth() * 9 / 21.0
    }
}

// MARK: - UITableViewDelegatge
extension UserProfileVC: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoInfoVC") as! PhotoInfoVC
        vc.photo = String(format: "%@", photoURLs[indexPath.section])
        vc.ratio = 21.0 / 9
        navigationController?.pushViewController(vc, animated: true)
    }
}
