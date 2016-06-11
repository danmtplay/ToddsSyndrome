//
//  Q1ViewController.swift
//  ToddsSyndrome
//
//  Created by Dan on 6/10/16.
//  Copyright © 2016 dan.mobile.com. All rights reserved.
//

import UIKit
import DLRadioButton

class Q1ViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    
    // local var
    var anUser : User!
    var isSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.layer.borderColor = nextButton.titleLabel?.textColor.CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectAge(sender: DLRadioButton) {
        isSelected = true
        if sender.titleLabel?.text == "Under 15 years old" {
            anUser.age = true
        }
        else {
            anUser.age = false
        }
    }
    
    @IBAction func onNext(sender: UIButton) {
        if isSelected == true {
            performSegueWithIdentifier("q2Segue", sender: self)
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "Please choice one of 2 answers", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "q2Segue" {
            let des = segue.destinationViewController as! Q2ViewController
            des.anUser = self.anUser
        }
    }

}
