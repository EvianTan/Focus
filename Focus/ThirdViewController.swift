//
//  ThirdViewController.swift
//  Focus
//
//  Created by Evian tan  on 07/01/2018.
//  Copyright © 2018 Evian tan . All rights reserved.
//

import UIKit
import FirebaseAuth

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var isSignIn:Bool = true
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        // Flip the boolean
        isSignIn = !isSignIn
        
        // Check the bool and set the button and labels
        if isSignIn {
            actionButton.setTitle("Sign In", for: .normal)
        }
        else {
            actionButton.setTitle("Register", for: .normal)
        }
    }
    
    
    @IBOutlet weak var actionButton: UIButton!
    @IBAction func action(_ sender: UIButton) {
        if emailText.text != "" && passwordText.text != "" {
            // Login user
            if segmentControl.selectedSegmentIndex == 0 {
                Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                    if user != nil {
                        // Sign in successful
                        self.performSegue(withIdentifier: "segue1", sender: self)
                    }
                    else {
                        if let myError = error?.localizedDescription {
                            print(myError)
                        }
                        else {
                            print("ERROR")
                        }
                    }
                })

            }
            // Sign up user
            else {
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
                    if user != nil {
                        self.performSegue(withIdentifier: "segue1", sender: self)
                    }
                    else {
                        if let myError = error?.localizedDescription {
                            print(myError)
                        }
                        else {
                            print("ERROR")
                        }
                    }
                })
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
