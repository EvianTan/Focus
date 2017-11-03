//
//  ViewController.swift
//  Focus
//
//  Created by Evian tan  on 01/11/2017.
//  Copyright © 2017 Evian tan . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Connect timeLable
    @IBOutlet weak var timerLabel: UILabel!
    
    

    var seconds = 1500
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
    
    // MARK: start button action
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            self.startButton.isEnabled = false
        }
    }
    
    @IBOutlet weak var startButton: UIButton!
    
    
    // MARK: pause button action
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
            self.pauseButton.setTitle("Resume", for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            self.pauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    @IBOutlet weak var pauseButton: UIButton!
    
    // MARK: reset button action
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        seconds = 1500
        timerLabel.text = timeString(time: TimeInterval(seconds))
        
        isTimerRunning = false
        pauseButton.isEnabled = false
        startButton.isEnabled = true
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pauseButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: run time
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        
        isTimerRunning = true
        pauseButton.isEnabled = true
    }
    
    // MARK: Update the time
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            // TODO: Send alert to inform time is up
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

}

