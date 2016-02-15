//
//  ViewController.swift
//  TimerDemo
//
//  Created by coderyi on 16/2/15.
//  Copyright © 2016年 coderyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var Counter:Int = 0
    var Timer: NSTimer = NSTimer()
    
    lazy var mainLabel:UILabel={
        var mainLabel:UILabel=UILabel(frame: CGRectMake(0, 20, UIScreen.mainScreen().bounds.size.width, 30))
//        mainLabel.backgroundColor=UIColor.greenColor()
        mainLabel.textAlignment=NSTextAlignment.Center
        return mainLabel
    }()
    
    lazy var resetButton:UIButton={
        var resetButton:UIButton=UIButton(frame: CGRectMake(0, 60, UIScreen.mainScreen().bounds.size.width, 30))
        resetButton.addTarget(self, action:"resetButtonAction" , forControlEvents: UIControlEvents.TouchUpInside)
//        resetButton.backgroundColor=UIColor.greenColor()
//        resetButton.titleLabel?.text="reset"
        resetButton.setTitle("reset", forState:UIControlState.Normal)
        resetButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        return resetButton
    }()

    lazy var startButton:UIButton={
        var startButton:UIButton=UIButton(frame: CGRectMake(0, 100, UIScreen.mainScreen().bounds.size.width, 30))
        startButton.addTarget(self, action:"startButtonAction" , forControlEvents: UIControlEvents.TouchUpInside)
//        startButton.backgroundColor=UIColor.greenColor()
//        startButton.titleLabel?.text="start"
        startButton.setTitle("start", forState:UIControlState.Normal)
        startButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        return startButton
    }()

    lazy var stopButton:UIButton={
        var stopButton:UIButton=UIButton(frame: CGRectMake(0, 140, UIScreen.mainScreen().bounds.size.width, 30))
        stopButton.addTarget(self, action:"stopButtonAction" , forControlEvents: UIControlEvents.TouchUpInside)
//        stopButton.backgroundColor=UIColor.greenColor()
//        stopButton.titleLabel?.text="stop"
        stopButton.setTitle("stop", forState:UIControlState.Normal)
        stopButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        return stopButton
    }()

    func resetButtonAction(){
        NSLog("test")
        Timer.invalidate()
        Counter = 0
        mainLabel.text = String(Counter)

        
    }
    func startButtonAction(){
        NSLog("test")
        Timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("UpdateTimer"), userInfo: nil, repeats: true)

    }
    func stopButtonAction(){
        NSLog("test")
        Timer.invalidate()

    }
    
    func UpdateTimer() {
        Counter = Counter + 1
        mainLabel.text = String(Double(Counter)/10.0)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(mainLabel)
        mainLabel.text = String(Counter)

        self.view.addSubview(resetButton)
        self.view.addSubview(startButton)
        self.view.addSubview(stopButton)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

