//
//  ViewController.swift
//  Focus
//
//  Created by Evian tan  on 01/11/2017.
//  Copyright © 2017 Evian tan . All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation
import AudioToolbox
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {
    
    var seconds = 1500
    var timer = Timer()
    var isTimerRunning = false
    
    var maxCount = 1500
    var newAngleValue1 = 0.0
    
    var alertSound = 1304
    
    var ref:DatabaseReference?
    
    var hour1 = 0
    var minute1 = 0
    
    var hour2 = 0
    var minute2 = 0
    
    var hour3 = 0
    var minute3 = 0
    
    var status = 0 //status for record the start time

    
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
            
            if status == 0 {
                // start time
                hour1 = Calendar.current.component(.hour, from: Date())
                minute1 = Calendar.current.component(.minute, from: Date())
            }
            status = 1
            
            runTimer()
            isTimerRunning = true
            self.startButton.setImage(UIImage(named: "pause.png"), for: .normal)
            timeField.isUserInteractionEnabled = false
            resetButton.isHidden = true
        } else {
            timer.invalidate()
            isTimerRunning = false
            self.startButton.setImage(UIImage(named: "start.png"), for: .normal)
            timeField.isUserInteractionEnabled = true
            resetButton.isHidden = false
        }
    }
    
    
    // MARK: reset button action
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        createAlert1(title: "Alert", message: "Do you want to keep the data?")
        status = 0
    }
    
    
    // MARK: run time
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        
        isTimerRunning = true
    }
    
    var totalFocusTime = 0
    
    // MARK: Update the time
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            AudioServicesPlaySystemSound(SystemSoundID(alertSound))
            
            // end time
            hour2 = Calendar.current.component(.hour, from: Date())
            minute2 = Calendar.current.component(.minute, from: Date())
            
            status = 0
            
            // write the focus time into firebase database
            ref = Database.database().reference()
            
            let date = Date()
            let calendar = Calendar.current
            
            let currentYear = calendar.component(.year, from: date)
            let currentMonth = calendar.component(.month, from: date)
            let currentDay = calendar.component(.day, from: date)
            
            let currentDate = String(currentYear)+String(currentMonth)+String(currentDay)
            
            let  userID = Auth.auth().currentUser!.uid
           // self.ref?.child("users").child(userID).child("Focus").child(currentDate).child("totalFocusTime").setValue(totalFocusTime)
            self.ref?.child("users").child(userID).child("Focus").child(currentDate).childByAutoId().setValue("\(hour1):\(minute1),\(hour2):\(minute2),\(maxCount/60)")
            
           // self.ref?.child("users").child(userID).child("Focus").child(currentDate).childByAutoId().child("startTime").setValue("\(hour1):\(minute1)")
            
            //self.ref?.child("users").child(userID).child("Focus").child(currentDate).childByAutoId().child("endTime").setValue("\(hour2):\(minute2)")
            
           // self.ref?.child("users").child(userID).child("Focus").child(currentDate).childByAutoId().child("focusTime").setValue("\(maxCount/60) min")
            
            
            
            
            
            
            
            //totalFocusTime += maxCount/60
            
            //self.ref?.child("users").child(userID).child("Focus").child(currentDate).child("totalFocusTime").setValue(totalFocusTime)
            
            
            
            // Send an inner alert to inform time is up
            createAlert(title: "Close your eyes and take a break!", message: "You've finished!")
            
            startButton.setImage(UIImage(named: "start.png"), for: .normal)
            timeField.isUserInteractionEnabled = true
            resetButton.isHidden = false
            
            newAngleValue1 = 0
            oProgressView2.setProgress(0, animated: true)
            
            // Send a locoal notification
            let content = UNMutableNotificationContent()
            content.title = "You've finished!"
            content.subtitle = "Time is up!"
            content.body = "You've focused \(Int(maxCount/60)) minutes!"
            
            let request = UNNotificationRequest(identifier: "timeDone", content: content, trigger:nil)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
    var counter = 30
    var timer1 = Timer()
    var alert: UIAlertController!
    
    func createAlert(title:String, message:String) {
        alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in self.alert.dismiss(animated: true, completion: nil)}))
        
        //self.present(alert, animated: true, completion: nil)
        self.present(alert, animated: true){
            self.timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.decrease), userInfo: nil, repeats: true)
        }
    }
    
    @objc func decrease() {
        //var minutes: Int
        var seconds1 = 30
        if(counter > 0) {
            self.counter -= 1
            alert.message = String("👁 \(counter) s")
        }
        else{
            dismiss(animated: true, completion: nil)
            timer1.invalidate()
        }
    }
    
    
    // MARK: Show an alert for reset
    func createAlert1(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let date = Date()
        let calendar = Calendar.current
        
        let currentYear = calendar.component(.year, from: date)
        let currentMonth = calendar.component(.month, from: date)
        let currentDay = calendar.component(.day, from: date)
        
        let currentDate = String(currentYear)+String(currentMonth)+String(currentDay)
        
        
        alert.addAction(UIAlertAction(title: "Keep it", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            // keep time data
            self.hour3 = Calendar.current.component(.hour, from: Date())
            self.minute3 = Calendar.current.component(.minute, from: Date())
            
            self.ref = Database.database().reference()
            let  userID = Auth.auth().currentUser!.uid
            self.ref?.child("users").child(userID).child("Focus").child(currentDate).childByAutoId().setValue("\(self.hour1):\(self.minute1)-\(self.hour3):\(self.minute3) \((self.maxCount-self.seconds)/60) min")
            
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
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in})
       
        
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

