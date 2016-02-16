//
//  ViewController.swift
//  TableViewDemo
//
//  Created by coderyi on 15/12/4.
//  Copyright © 2015年 coderyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    lazy var mainTableView:UITableView={
        
        var tempTableView:UITableView=UITableView(frame: CGRectMake(0, 20, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height), style: .Plain)
        tempTableView.dataSource=self
        tempTableView.delegate=self
        return tempTableView
        
    }()
    func animateTable() {
        
        mainTableView.reloadData()
        
        let cells = mainTableView.visibleCells
        let tableHeight: CGFloat = mainTableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            
            let cell: UITableViewCell = a as UITableViewCell
            
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                
                }, completion: nil)
            
            index += 1
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        animateTable()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(mainTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier: String = "Cell"
        var cell:UITableViewCell?=tableView.dequeueReusableCellWithIdentifier(identifier)
        if(cell==nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
        }
        
        cell?.backgroundColor=UIColor(red: 55/255, green: 186/255, blue: 89/255, alpha: 0.5)
        
        cell?.textLabel?.text="xxxxx"
        cell?.detailTextLabel?.text="ddddd"
        return cell!//!表示“我确定这里的的cell一定是非nil的，尽情调用吧”
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("xxxx")
    }
}

