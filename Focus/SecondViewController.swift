//
//  SecondViewController.swift
//  Focus
//
//  Created by Evian tan  on 20/11/2017.
//  Copyright © 2017 Evian tan . All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Charts

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    @IBOutlet weak var uiSlider: UISlider!
    
    
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var timeBars: [String]!
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        var counter = 0.0
        
        for i in 0..<dataPoints.count {
            counter += 1.0
            let dataEntry = BarChartDataEntry(x: counter/4, y:values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values:dataEntries, label: "Focus:210min" )
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
        
        //barChartView.groupBars(fromX: 0.0, groupSpace: 0.0, barSpace: 0.0)
        
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawLabelsEnabled = false
        barChartView.leftAxis.drawLabelsEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        
        chartData.setDrawValues(false)
        barChartView.chartDescription?.text = ""
        chartDataSet.colors = [UIColor(red: 251/255.0, green: 191/255.0, blue: 101/255.0, alpha: 1)]
        barChartView.animate(xAxisDuration: 2.0)
    }
    
    
    var ref:DatabaseReference?
    var handle:DatabaseHandle?
    
    var  myList:[String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = myList[indexPath.row]
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = UIColor(red: 115/255.0, green: 140/255.0, blue: 199/255.0, alpha: 1)
        self.view.backgroundColor = UIColor(red: 115/255.0, green: 140/255.0, blue: 199/255.0, alpha: 1)
        
        ref = Database.database().reference()
        /**
        handle = ref?.child("list").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? String
            {
                self.myList.append(item)
                self.myTableView.reloadData()
            }
        })
        **/
        
        let date = Date()
        let calendar = Calendar.current
        
        let currentYear = calendar.component(.year, from: date)
        let currentMonth = calendar.component(.month, from: date)
        let currentDay = calendar.component(.day, from: date)
        
        let currentDate = String(currentYear)+String(currentMonth)+String(currentDay)
        
        let currentHour = calendar.component(.hour, from: date)
        let currentMinute = calendar.component(.minute, from: date)
        let currentSecond = calendar.component(.second, from: date)
        
        let userID = Auth.auth().currentUser!.uid
        handle = ref?.child("users").child(userID).child("Focus").child(currentDate).observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? String
            {
                self.myList.append(item)
                self.myTableView.reloadData()
            }
        })
        
        self.view.backgroundColor = UIColor.white
        
       
        
        //print ("\(currentHour):\(currentMinute):\(currentSecond)")
        
        uiSlider.value = Float(currentHour*3600+currentMinute*60+currentSecond)
        uiSlider.maximumTrackTintColor = UIColor.white
        uiSlider.minimumTrackTintColor = UIColor.white
        uiSlider.setThumbImage(UIImage(named: "focus_pin.png"), for: .normal)
        uiSlider.setThumbImage(UIImage(named: "focus_pin.png"), for: .highlighted)
        uiSlider.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        
        timeBars = ["0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8", "8.5", "9", "9.5", "10", "10.5", "11", "11.5", "12", "12.5", "13", "13.5", "14", "14.5", "15", "15.5", "16", "16.5", "17", "17.5", "18", "18.5", "19", "19.5", "20", "20.5", "21", "21.5", "22", "22.5", "23", "23.5", "0", "0.5", "1", "1.5", "2", "2.5", "3", "3.5", "4", "4.5", "5", "5.5", "6", "6.5", "7", "7.5", "8", "8.5", "9", "9.5", "10", "10.5", "11", "11.5", "12", "12.5", "13", "13.5", "14", "14.5", "15", "15.5", "16", "16.5", "17", "17.5", "18", "18.5", "19", "19.5", "20", "20.5", "21", "21.5", "22", "22.5", "23", "23.5"]
        let focusStatus = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        
        setChart(dataPoints: timeBars, values: focusStatus)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    

}
