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
    
    var seconds = 1500
    var timer = Timer()
    var isTimerRunning = false
    
    var maxCount = 1500
    var newAngleValue1 = 0.0
    
    var alertSound = 1304
    
    
    // MARK: date picker
    @IBOutlet weak var timeField: UITextField!
    
    let picker = UIDatePicker()
    
    func createDatePicker() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([done], animated: false)
        
        timeField.inputAccessoryView = toolbar
        timeField.inputView = picker
        
        // format picker for time
        picker.datePickerMode = .countDownTimer
        picker.minuteInterval = 1
        picker.countDownDuration = 1500
    }
    
    @objc func donePressed() {
        seconds = Int(picker.countDownDuration)
        timeField.text = timeString(time: TimeInterval(seconds))
        self.view.endEditing(true)
        
        maxCount = seconds
        newAngleValue1 = 0
        oProgressView2.setProgress(0, animated: true)
    }
    
    
    // MARK: Circle progress bar
    @IBOutlet weak var oProgressView2: OProgressView2!
    
    
    // MARK: start button
    @IBOutlet weak var startButton: UIButton!
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            isTimerRunning = true
            //self.startButton.setTitle("pause", for: .normal)
            self.startButton.setImage(UIImage(named: "pause.png"), for: .normal)
            timeField.isUserInteractionEnabled = false
            resetButton.isHidden = true
        } else {
            timer.invalidate()
            //cicularProgressView.pauseAnimation()
            isTimerRunning = false
            //self.startButton.setTitle("start", for: .normal)
            self.startButton.setImage(UIImage(named: "start.png"), for: .normal)
            timeField.isUserInteractionEnabled = true
            resetButton.isHidden = false
        }
    }
    
    
    // MARK: reset button action
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        
        createAlert1(title: "Alert", message: "Do you want to keep the data?")
        
        //timer.invalidate()
        
        /***
        seconds = 1500
        maxCount = 1500
        timeField.text = timeString(time: TimeInterval(seconds))
        
        isTimerRunning = false
        
        newAngleValue1 = 0
        oProgressView2.setProgress(0, animated: true)
         ***/
        
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
            AudioServicesPlaySystemSound(SystemSoundID(alertSound))
            createAlert(title: "Alert", message: "You've finished!")
            
            startButton.setImage(UIImage(named: "start.png"), for: .normal)
            timeField.isUserInteractionEnabled = true
            resetButton.isHidden = false
            
            newAngleValue1 = 0
            
        } else {
            seconds -= 1
            timeField.text = timeString(time: TimeInterval(seconds))
            
            newAngleValue1 += 100.0/Double(maxCount)
            oProgressView2.setProgress(newAngleValue1, animated: true)
        }
    }
    
    
    // MARK: show the time by hour, minute, second
    func timeString(time:TimeInterval) -> String {
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    
    // MARK: Switch for sound
    @IBAction func `switch`(_ sender: UISwitch) {
        if (sender.isOn == true) {
            alertSound = 1304
        }
        else
        {
            alertSound = 4095
        }
    }
    
    
    // MARK: Show an alert for ending
    func createAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: Show an alert for reset
    func createAlert1(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Keep it", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            self.seconds = 1500
            self.maxCount = 1500
            self.timeField.text = self.timeString(time: TimeInterval(self.seconds))
            
            self.isTimerRunning = false
            
            self.newAngleValue1 = 0
            self.oProgressView2.setProgress(0, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Discard it", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            self.seconds = 1500
            self.maxCount = 1500
            self.timeField.text = self.timeString(time: TimeInterval(self.seconds))
            
            self.isTimerRunning = false
            
            self.newAngleValue1 = 0
            self.oProgressView2.setProgress(0, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: Play audio in background
    var player:AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.isHidden = true
        
        createDatePicker()
        
        //oProgressView2.setProgress(newAngleValue1, animated: true)
       
        
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

