//
//  ViewController.swift
//  ToddsSyndrome
//
//  Created by Dan on 6/9/16.
//  Copyright © 2016 dan.mobile.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.borderColor = registerButton.titleLabel?.textColor.CGColor
        loginButton.layer.borderColor = loginButton.titleLabel?.textColor.CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onRegister(sender: UIButton) {
        performSegueWithIdentifier("registerSegue", sender: self)
    }
    
    @IBAction func onLogin(sender: UIButton) {
        performSegueWithIdentifier("loginSegue", sender: self)
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "registerSegue" {
//            let des = segue.destinationViewController as! RegisterViewController
//            
//        }
//        else if segue.identifier == "loginSegue" {
//            let des = segue.destinationViewController as! LoginViewController
//            
//        }
//    }
}

