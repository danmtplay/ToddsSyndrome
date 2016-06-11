//
//  Q4ViewController.swift
//  ToddsSyndrome
//
//  Created by Dan on 6/10/16.
//  Copyright © 2016 dan.mobile.com. All rights reserved.
//

import UIKit
import DLRadioButton

class Q4ViewController: UIViewController {

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
    
    @IBAction func useDrugs(sender: DLRadioButton) {
        isSelected = true
        if sender.selectedButton()?.titleLabel?.text == "Yes" {
            anUser.drug = true
        }
        else {
            anUser.drug = false
        }
    }
    
    @IBAction func onNext(sender: UIButton) {
        if isSelected == true {
            performSegueWithIdentifier("resultSegue", sender: self)
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "Please choice one of 2 answers", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "resultSegue" {
            let des = segue.destinationViewController as! ResultViewController
            des.anUser = self.anUser
        }
    }

}
