//
//  ResultViewController.swift
//  ToddsSyndrome
//
//  Created by Dan on 6/10/16.
//  Copyright © 2016 dan.mobile.com. All rights reserved.
//

import UIKit
import FMDB

class ResultViewController: UIViewController {

    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var resultDesc: UILabel!
    @IBOutlet weak var thanksButton: UIButton!
    
    
    // local var
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var anUser : User!
    var nResult : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        thanksButton.layer.borderColor = thanksButton.titleLabel?.textColor.CGColor
        calcPercent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onThanks(sender: UIButton) {
        navigationController?.popToRootViewControllerAnimated(true)
//        let next = self.storyboard?.instantiateViewControllerWithIdentifier("RootViewController") as! ViewController
//        self.presentViewController(next, animated: true, completion: nil)
    }
    
    // calculate diagnosis
    func calcPercent() {
        if anUser.age == true {
            nResult += 25
        }
        if anUser.gender == true {
            nResult += 25
        }
        if anUser.migraine == true {
            nResult += 25
        }
        if anUser.drug == true {
            nResult += 25
        }
        
        percentLabel.text = "\(nResult)%"
        updateUserInfo()
    }

    // MARK: - save user info to sqlite3 db
    func updateUserInfo() {
        let contactDB = FMDatabase(path: appDel.databasePath as String)
        
        if contactDB.open() {
            
            let updateSQL = "UPDATE CONTACTS SET username = '\(anUser.username)', password = '\(anUser.password)', result = '\(nResult)' WHERE username = '\(anUser.username)'"
            let result = contactDB.executeUpdate(updateSQL, withArgumentsInArray: nil)
            
            if !result {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("Success: Contact updated")
                let alert = UIAlertController(title: "Alert", message: "Saved this result to local database", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
