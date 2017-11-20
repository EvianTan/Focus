//
//  SecondViewController.swift
//  Focus
//
//  Created by Evian tan  on 20/11/2017.
//  Copyright © 2017 Evian tan . All rights reserved.
//

import UIKit
import FirebaseDatabase

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var myTableView: UITableView!
    
    //let myList = ["milk", "data", "code"]
    
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
        
        ref = Database.database().reference()
        
        handle = ref?.child("list").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? String
            {
                self.myList.append(item)
                self.myTableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    

}
