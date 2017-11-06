//
//  ViewController.swift
//  Focus
//
//  Created by Evian tan  on 01/11/2017.
//  Copyright © 2017 Evian tan . All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
    
    var seconds = 15
    var timer = Timer()
    var isTimerRunning = false
    
    // MARK: Connect timeLable
    @IBOutlet weak var timerLabel: UILabel!
    
    
    // MARK: Slider button
    @IBOutlet weak var sliderOutlet: UISlider!
    @IBAction func timerSlider(_ sender: UISlider) {
        seconds = Int(sender.value)
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    
    // MARK: start button
    @IBOutlet weak var startButton: UIButton!
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            isTimerRunning = true
            self.startButton.setTitle("pause", for: .normal)
            resetButton.isHidden = true
            sliderOutlet.isEnabled = false
        } else {
            timer.invalidate()
            isTimerRunning = false
            self.startButton.setTitle("start", for: .normal)
            resetButton.isHidden = false
            sliderOutlet.isEnabled = true
        }
    }
    
    
    // MARK: reset button action
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        seconds = 1500
        sliderOutlet.value = 1500
        timerLabel.text = timeString(time: TimeInterval(seconds))
        
        isTimerRunning = false
    }
    
    
    // MARK: run time
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        
        isTimerRunning = true
    }
    
    
    // MARK: Update the time
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            // TODO: Send alert to inform time is up
            AudioServicesPlaySystemSound(SystemSoundID(1304))
            createAlert(title: "Alert", message: "You've finished!")
        } else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    
    // MARK: show the time by hour, minute, second
    func timeString(time:TimeInterval) -> String {
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    // MARK: Show an alert
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: Play audio in background
    var player:AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.isHidden = true
        
        // MARK: Play audio in background
        do {
            let audioPath = Bundle.main.path(forResource: "silence", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        }
        catch {
            //PROCESS
        }
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch { }
        player.play()
        player.numberOfLoops = -1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

