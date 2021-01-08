//
//  MyBackViewController.swift
//  ECE564_HW
//
//  Created by Jiawei Sun on 10/6/20.
//  Copyright © 2020 ECE564. All rights reserved.
//

import UIKit
import AVFoundation

class MyBackViewController: UIViewController {
   
    var player: AVAudioPlayer?
    
    let basketBall: UIView = Basketball()
    let label = UILabel.init()
    func moveBallAround() {
        
            UIView.animate(withDuration: 1.0, delay: 0,
                           options: [.repeat, .autoreverse], animations: {
                            self.basketBall.frame.origin.y += 100
            })
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playMusic()
        loadCircularProgress()
        loadAttributedText()
        backToFront()
        loadBall()
    }
    
    func loadCircularProgress() {
        let cp = CircularProgressView(frame: CGRect(x: self.view.center.x, y: 100.0, width: 50.0, height: 50.0))
        cp.trackColor = UIColor.systemRed
        cp.progressColor = UIColor.systemBlue
        cp.tag = 101
        self.view.addSubview(cp)
        self.perform(#selector(animateProgress), with: nil, afterDelay: 0.5)
    }
    
    @objc func animateProgress() {
        let cP = self.view.viewWithTag(101) as! CircularProgressView
        cP.setProgressWithAnimation(duration: 1.0, value: 1.0)
    }
    
    func playMusic() {
        let urlString = Bundle.main.path(forResource: "audio", ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            guard let urlString = urlString else {
                return
            }
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath:  urlString))
            guard let player = player else {
                return
            }
            player.play()
        }
        catch {
            print("something's wrong")
        }
        
    }
    
    func loadAttributedText() {
        label.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        /*
        let textLine = "Hobby"
        let myFont = UIFont(name: "Zapfino", size: 40.0)

        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.blue

        let myAttributes = [
            NSAttributedString.Key.shadow: myShadow,
            NSAttributedString.Key.font: myFont,
            NSAttributedString.Key.foregroundColor: UIColor.blue
        ]
        let attString = NSAttributedString(string: textLine, attributes: (myAttributes) as [NSAttributedString.Key : Any])
        self.label.attributedText = attString
        */
        let str = "NBA"

        let attStr = NSMutableAttributedString.init(string: str)

          attStr.addAttribute(.font,
                        value: UIFont.init(name: "Zapfino", size: 15) ?? "font not found",
                        range: NSRange.init(location: 0, length: str.count))

        self.label.attributedText = attStr
        self.view.addSubview(label)
    }
    
    func loadBall() {
        /*
        let blackBg = UIView(frame: CGRect(x: 50, y: 80, width: 200, height: 200)) // Make a black background for the blue ball
                blackBg.backgroundColor = .black
                view?.addSubview(blackBg)
        */
                basketBall.frame = CGRect(x: 0, y: 300, width: 100, height: 100) // Place it on the top half of the scene
        self.view.addSubview(basketBall)
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
                moveBallAround()
    }
    
    func backToFront() {
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(recognizer:)))
        recognizer.direction = .right
            self.view.addGestureRecognizer(recognizer)
    }
    
    @objc func swipeRight(recognizer : UISwipeGestureRecognizer) {
        self.performSegue(withIdentifier: "BackToFrontFromMe", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let informationVC = segue.destination as! InformationViewController
        informationVC.whichSegue = true
        
    }

    
}
