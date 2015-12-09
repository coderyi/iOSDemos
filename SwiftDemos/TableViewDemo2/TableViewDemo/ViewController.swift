//
//  ViewController.swift
//  TableViewDemo
//
//  Created by coderyi on 15/12/4.
//  Copyright © 2015年 coderyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,FirstTableViewCellDelegate{

    lazy var mainTableView:UITableView={
        
        var tempTableView:UITableView=UITableView(frame: CGRectMake(0, 20, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height), style: .Plain)
        tempTableView.dataSource=self
        tempTableView.delegate=self
        return tempTableView
        
    }()//不要忘记最后的小括号，只有加了小括号，必包才会在掉用的时候立刻执行。
    
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
        
        var cell:FirstTableViewCell?=tableView.dequeueReusableCellWithIdentifier(identifier) as? FirstTableViewCell
        if(cell==nil){
            cell=FirstTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
            cell?.delegate=self
        }
        cell?.titleLabel.text="xxxxx"
        cell?.detailLabel.text="yyyyyy"
        cell?.countLabel.text="2"
        
        return cell!//!表示“我确定这里的的cell一定是非nil的，尽情调用吧”
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("xxxx")
    }
    
    func addButtonAction(){
        NSLog("+++")

    }
    
    func reduceButtonAction(){
        NSLog("---")

    }
}

