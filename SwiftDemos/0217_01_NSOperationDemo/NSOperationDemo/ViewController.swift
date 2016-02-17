//
//  ViewController.swift
//  NSOperationDemo
//
//  Created by coderyi on 16/2/17.
//  Copyright © 2016年 coderyi. All rights reserved.
//

import UIKit
let imageURLs = ["http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://algoos.com/wp-content/uploads/2015/08/ireland-02.jpg", "http://bdo.se/wp-content/uploads/2014/01/Stockholm1.jpg"]

class Downloader {
    
    class func downloadImageWithURL(url:String) -> UIImage! {
        
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        return UIImage(data: data!)
    }
}
class ViewController: UIViewController {
    lazy var startButton:UIButton={
        var startButton:UIButton=UIButton()
        startButton.frame=CGRectMake(100,30,60,30)
        startButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        startButton.setTitle("start", forState: .Normal)
        startButton.addTarget(self, action: "didClickOnStart", forControlEvents: UIControlEvents.TouchUpInside)
        return startButton
    
    }()
    lazy var cancelButton:UIButton={
        var cancelButton:UIButton=UIButton()
        cancelButton.frame=CGRectMake(190,30,60,30)
        cancelButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        cancelButton.setTitle("cancel", forState: .Normal)
        cancelButton.addTarget(self, action: "didClickOnCancel", forControlEvents: UIControlEvents.TouchUpInside)
        return cancelButton
        
    }()

    
    lazy var imageView1:UIImageView={
        var imageView1:UIImageView=UIImageView(frame: CGRectMake(0, 64, 200, 200))
        
        
        return imageView1
    }()
    lazy var imageView2:UIImageView={
        var imageView2:UIImageView=UIImageView(frame: CGRectMake(210, 64, 200, 200))
        
        
        return imageView2
    }()

    lazy var imageView3:UIImageView={
        var imageView3:UIImageView=UIImageView(frame: CGRectMake(0, 210+64, 200, 200))
        
        
        return imageView3
    }()

    
    lazy var imageView4:UIImageView={
        var imageView4:UIImageView=UIImageView(frame: CGRectMake(210, 210+64, 200, 200))
        
        
        return imageView4
    }()

    var queue = NSOperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(imageView1)
        self.view.addSubview(imageView2)
        self.view.addSubview(imageView3)
        self.view.addSubview(imageView4)
        self.view.addSubview(startButton)
        self.view.addSubview(cancelButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func didClickOnStart() {
        queue = NSOperationQueue()
        
        let operation1 = NSBlockOperation(block: {
            let img1 = Downloader.downloadImageWithURL(imageURLs[0])
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView1.image = img1
            })
        })
        
        operation1.completionBlock = {
            print("Operation 1 completed, cancelled:\(operation1.cancelled)")
        }
        queue.addOperation(operation1)
        
        let operation2 = NSBlockOperation(block: {
            let img2 = Downloader.downloadImageWithURL(imageURLs[1])
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView2.image = img2
            })
        })
        operation2.addDependency(operation1)
        operation2.completionBlock = {
            print("Operation 2 completed, cancelled:\(operation2.cancelled)")
        }
        queue.addOperation(operation2)
        
        
        let operation3 = NSBlockOperation(block: {
            let img3 = Downloader.downloadImageWithURL(imageURLs[2])
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView3.image = img3
            })
        })
        operation3.addDependency(operation2)
        
        operation3.completionBlock = {
            print("Operation 3 completed, cancelled:\(operation3.cancelled)")
        }
        queue.addOperation(operation3)
        
        let operation4 = NSBlockOperation(block: {
            let img4 = Downloader.downloadImageWithURL(imageURLs[3])
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.imageView4.image = img4
            })
        })
        
        operation4.completionBlock = {
            print("Operation 4 completed, cancelled:\(operation4.cancelled)")
        }
        queue.addOperation(operation4)
        
    }
    
    func didClickOnCancel() {
        
        self.queue.cancelAllOperations()
    }


}

