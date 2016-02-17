//
//  ViewController.swift
//  RecordDemo
//
//  Created by coderyi on 16/2/17.
//  Copyright © 2016年 coderyi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    lazy var startRecordBut:UIButton={
        var startRecordBut:UIButton=UIButton()
        startRecordBut.frame=CGRectMake(100,70,100,30)
        startRecordBut.setTitle("startRecord", forState: .Normal)
        startRecordBut.setTitleColor(UIColor.blackColor(), forState: .Normal)
        startRecordBut.addTarget(self, action: "startRecordButAction", forControlEvents: UIControlEvents.TouchUpInside)
        return startRecordBut
    }()
    
    lazy var stopRecordBut:UIButton={
        var stopRecordBut:UIButton=UIButton()
        stopRecordBut.frame=CGRectMake(100,110,100,30)
        stopRecordBut.setTitle("stopRecord", forState: .Normal)
        stopRecordBut.setTitleColor(UIColor.blackColor(), forState: .Normal)

        stopRecordBut.addTarget(self, action: "stopRecordButAction", forControlEvents: UIControlEvents.TouchUpInside)
        return stopRecordBut
    }()
    lazy var startPlayBut:UIButton={
        var startPlayBut:UIButton=UIButton()
        startPlayBut.frame=CGRectMake(100,150,100,30)
        startPlayBut.setTitle("startPlay", forState: .Normal)
        startPlayBut.setTitleColor(UIColor.blackColor(), forState: .Normal)

        startPlayBut.addTarget(self, action: "startPlayButAction", forControlEvents: UIControlEvents.TouchUpInside)
        return startPlayBut
    }()
    lazy var pausePlayBut:UIButton={
        var pausePlayBut:UIButton=UIButton()
        pausePlayBut.frame=CGRectMake(100,200,100,30)
        pausePlayBut.setTitle("pausePlay", forState: .Normal)
        pausePlayBut.setTitleColor(UIColor.blackColor(), forState: .Normal)

        pausePlayBut.addTarget(self, action: "pausePlayButAction", forControlEvents: UIControlEvents.TouchUpInside)
        return pausePlayBut
    }()
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    ////定义音频的编码参数，这部分比较重要，决定录制音频文件的格式、音质、容量大小等，建议采用AAC的编码方式
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),//声音采样率
        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),//编码格式
        AVNumberOfChannelsKey : NSNumber(int: 1),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]//音频质量
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(startRecordBut)
        self.view.addSubview(stopRecordBut)
        self.view.addSubview(startPlayBut)
        self.view.addSubview(pausePlayBut)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!,
                settings: recordSettings)//初始化实例
            audioRecorder.prepareToRecord()//准备录音
        } catch {
        }


    }
    
    func directoryURL() -> NSURL? {
        //定义并构建一个url来保存音频，音频文件名为ddMMyyyyHHmmss.caf
        //根据时间来设置存储文件名
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".caf"
        print(recordingName)
        
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent(recordingName)
        return soundURL
    }
    
    func startRecordButAction() {
        //开始录音
        if !audioRecorder.recording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
                print("record!")
            } catch {
            }
        }
    }
    func stopRecordButAction() {
        //停止录音
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
            print("stop!!")
        } catch {
        }
    }
    
    
    func startPlayButAction() {
        //开始播放
        if (!audioRecorder.recording){
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder.url)
                audioPlayer.play()
                print("play!!")
            } catch {
            }
        }
    }
    
    
    func pausePlayButAction() {
        //暂停播放
        if (!audioRecorder.recording){
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder.url)
                audioPlayer.pause()
                
                print("pause!!")
            } catch {
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

