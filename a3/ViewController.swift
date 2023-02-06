//
//  ViewController.swift
//  a3
//
//  Created by Brandon  Miller on 1/30/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var liveTimer = Timer()
    var timer = Timer()
    var intTimeRemaining = 0
    var musicPlaying = false
    var player = AVAudioPlayer()
    
    
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAMorPM()
        liveTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getCurrentTime), userInfo: nil, repeats: true)
    }
    
    func playPiano() {
        guard let path = Bundle.main.path(forResource: "piano", ofType: "wav") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        }
        catch {
            print("ERROR")
        }

    }
    
    func stopPiano() {
        player.stop()
    }
    
    @objc func getCurrentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM YYYY HH:mm:ss"
        currentTime.text = formatter.string(from: Date())
        getAMorPM()
    }
    
    @objc func getAMorPM() {
        let post = DateFormatter()
        post.dateFormat = "a"
        if (post.string(from: Date()) == "PM") {
            self.view.backgroundColor = UIColor.lightGray
        }
        else {
            self.view.backgroundColor = UIColor.orange
        }
    }

    @objc func getTimeRemaining() {
        if (intTimeRemaining > 0) {
            getDigest()
            intTimeRemaining -= 1
        }
        else {
            timeRemaining.text = "Time Remaining: "
            intTimeRemaining = 0
            timer.invalidate()
            buttonLabel.isUserInteractionEnabled = true
            buttonLabel.setTitle("Stop Music", for: .normal)
            playPiano()
            musicPlaying = true
            
        }
    }
    
    func getDigest() {
        let ss: Int = intTimeRemaining % 60
        let mm: Int = (intTimeRemaining / 60) % 60
        let hh: Int = intTimeRemaining / 3600
    
        timeRemaining.text = "Time Remaining: " + String(format: "%02d:%02d:%02d", hh, mm, ss)
        
    }
    
    @IBOutlet weak var timeSelected: UIDatePicker!
    
    @IBOutlet weak var buttonLabel: UIButton!
    
    @IBAction func timerStart(_ sender: Any) {
        
        if (musicPlaying == false) {
            buttonLabel.isUserInteractionEnabled = false
            intTimeRemaining = Int(timeSelected.countDownDuration)
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTimeRemaining), userInfo: nil, repeats: true)
        }
        else {
            buttonLabel.setTitle("Start Timer", for: .normal)
            stopPiano()
            musicPlaying = false
        }
        
        
    }
    
}

