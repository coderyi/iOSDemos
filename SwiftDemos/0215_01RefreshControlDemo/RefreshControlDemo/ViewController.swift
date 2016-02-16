//
//  ViewController.swift
//  RefreshControlDemo
//
//  Created by coderyi on 16/2/15.
//  Copyright © 2016年 coderyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    let cellIdentifer = "NewCellIdentifier"
    
    let favoriteEmoji = ["🤗🤗🤗🤗🤗", "😅😅😅😅😅", "😆😆😆😆😆"]
    let newFavoriteEmoji = [ "🤗🤗🤗🤗🤗", "😅😅😅😅😅", "😆😆😆😆😆" ,"🏃🏃🏃🏃🏃", "💩💩💩💩💩", "👸👸👸👸👸"]
    var emojiData = [String]()
    var tableViewController = UITableViewController(style: .Plain)
    
    var refreshControl = UIRefreshControl()
    var timer:NSTimer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emojiData = favoriteEmoji
        let emojiTableView = tableViewController.tableView
        
        emojiTableView.backgroundColor = UIColor(red:0.092, green:0.096, blue:0.116, alpha:1)
        emojiTableView.dataSource = self
        emojiTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifer)
        
        tableViewController.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: "didRoadEmoji", forControlEvents: .ValueChanged)
        
        self.refreshControl.backgroundColor = UIColor(red:0.113, green:0.113, blue:0.145, alpha:1)
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(NSDate())", attributes: attributes)
        self.refreshControl.tintColor = UIColor.whiteColor()
        
        self.title = "emoji"
        
        emojiTableView.rowHeight = UITableViewAutomaticDimension
        emojiTableView.estimatedRowHeight = 60.0
        emojiTableView.tableFooterView = UIView(frame: CGRectZero)
        emojiTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        self.view.addSubview(emojiTableView)
    }
    
    //UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emojiData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer)! as UITableViewCell
        
        cell.textLabel!.text = self.emojiData[indexPath.row]
        cell.textLabel!.textAlignment = NSTextAlignment.Center
        cell.textLabel!.font = UIFont.systemFontOfSize(50)
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    
    //RoadEmoji
    
    func didRoadEmoji() {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3,target:self,selector:Selector("tickDown"),userInfo:nil,repeats:true)
    }
    
    func tickDown(){
        
        self.emojiData = newFavoriteEmoji
        self.tableViewController.tableView.reloadData()
        self.refreshControl.endRefreshing()

    }


}

