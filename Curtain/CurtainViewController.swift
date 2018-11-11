//
//  CurtainViewController.swift
//  Brainshots
//
//  Created by Amritpal Singh on 18/01/17.
//  Copyright © 2017 Anuradha Sharma. All rights reserved.
//

import AppKit
import AVFoundation

protocol curtainDelegate {
    func openCurtain()
    func closeCurtain()
}

final class CurtainViewController: NSViewController, curtainDelegate {
    
    var curtainsSound : AVAudioPlayer? = nil
    var curtainsOpenSound : AVAudioPlayer? = nil
       
    lazy var imageArray = [NSImage]()
    var playIndex = 0
    var playTotalTime : Double = 0
    var animTimer : Timer?

    @IBOutlet weak var imageView: NSImageView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        openCurtainsSound()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        let darkBackgroundColor:NSColor = NSColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)

        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = darkBackgroundColor.cgColor
    }
    
    /*Add Bottle On Counter Sound*/
    func curtainSound(){
        
        let path = Bundle.main.path(forResource: "CURTAINS CLOSE_OPEN.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            curtainsSound = try AVAudioPlayer(contentsOf: url)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func openCurtainsSound(){
        
        let path = Bundle.main.path(forResource: "CURTAINS OPEN.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            curtainsOpenSound = try AVAudioPlayer(contentsOf: url)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func openCurtain() {
        
        readGifDataAndConfigImageView(name: "CurtainOpen640.gif")
        timer()
    }
    
    func closeCurtain() {
        
        readGifDataAndConfigImageView(name: "CurtainClose640.gif")
        timer()
    }
    
    func readGifDataAndConfigImageView(name: String) {
        
        imageArray.removeAll()
        playIndex = 0
        playTotalTime = 0
        animTimer?.invalidate()
        
        guard let gifPath = Bundle.main.pathForImageResource( name ) else {return}
        guard let gifData = NSData(contentsOfFile: gifPath) else {return}
        
        guard let imageSourceRef = CGImageSourceCreateWithData(gifData, nil) else {return}
        
        let imageCount = CGImageSourceGetCount(imageSourceRef)
        
        for  i in 0 ..< imageCount {
            
            guard let cgImageRef =  CGImageSourceCreateImageAtIndex(imageSourceRef, i, nil) else {continue}
            
            let image =  NSImage(cgImage: cgImageRef, size: CGSize(width: cgImageRef.width, height: cgImageRef.height))
            imageArray.append(image)
            
            let cfProperties =  CGImageSourceCopyPropertiesAtIndex(imageSourceRef, i, nil)
            let gifProperties: CFDictionary = unsafeBitCast(
                CFDictionaryGetValue(cfProperties,
                                     Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
            
            var delayObject: AnyObject = unsafeBitCast(
                CFDictionaryGetValue(gifProperties,
                                     Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
            if delayObject.doubleValue == 0 {
                delayObject = unsafeBitCast(CFDictionaryGetValue(
                    gifProperties,
                    Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
            }
            playTotalTime += delayObject as! Double
        }
        
        imageView.image = imageArray.first
        
        self.imageView.canDrawSubviewsIntoLayer = true
        self.imageView.imageScaling = .scaleAxesIndependently
        self.imageView.frame = CGRect(x: 100.0, y: 100.0, width: self.view.frame.size.width / 10, height: self.view.frame.size.height / 10)
        
        curtainsOpenSound?.prepareToPlay()
        curtainsOpenSound?.play()
    }
    
    func timer() {
        
        animTimer = Timer(timeInterval: playTotalTime / Double(imageArray.count), target: self, selector: #selector(starGifAnimated), userInfo: nil, repeats: true)
        RunLoop.current.add(animTimer!, forMode: RunLoop.Mode.common)
    }
    
    @objc func starGifAnimated() {
        imageView.image = imageArray[playIndex]
        playIndex += 1
        if playIndex == imageArray.count {
            animTimer!.invalidate()
            playIndex = 0
        }
    }
}
