//
//  RegisterViewController.swift
//  ToddsSyndrome
//
//  Created by Dan on 6/10/16.
//  Copyright © 2016 dan.mobile.com. All rights reserved.
//

import UIKit
import SwiftValidator
import FMDB

class RegisterViewController: UIViewController, UITextFieldDelegate, ValidationDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var usernameEdit: UITextField!
    @IBOutlet weak var passwordEdit: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    // local var
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let validator = Validator()
    var anUser = User()
    var sUsername : String = ""
    var sPassword : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.layer.borderColor = backButton.titleLabel?.textColor.CGColor
        registerButton.layer.borderColor = registerButton.titleLabel?.textColor.CGColor
        
        // set validator
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.hidden = true
            validationRule.errorLabel?.text = ""
            validationRule.errorLabel?.textColor = UIColor.whiteColor()
            validationRule.textField.layer.borderColor = UIColor.clearColor().CGColor
            validationRule.textField.layer.borderWidth = 1.0
            
            }, error:{ (validationError) -> Void in
                print("error")
                validationError.errorLabel?.hidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                validationError.errorLabel?.textColor = UIColor.whiteColor()
                validationError.textField.layer.borderColor = UIColor.redColor().CGColor
                validationError.textField.layer.borderWidth = 1.0
        })
        
        validator.registerField(usernameEdit, errorLabel: usernameErrorLabel, rules: [RequiredRule(), MinLengthRule(length: 3)])
        validator.registerField(passwordEdit, errorLabel: passwordErrorLabel, rules: [RequiredRule(), PasswordRule()])

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBack(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func onBackgroundTapped(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func onRegister(sender: UIButton) {
        validator.validate(self)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "rq1Segue" {
            let des = segue.destinationViewController as! Q1ViewController
            des.anUser = self.anUser
        }
    }
 
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameEdit {
            passwordEdit.becomeFirstResponder()
        }
        else if textField == passwordEdit {
            self.view.endEditing(true)
            validator.validate(self)
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - ValidationDelegate
    func validationSuccessful() {
        sUsername = usernameEdit.text!
        sPassword = passwordEdit.text!
        saveUserInfo()
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
        }
    }

    // MARK: - save user info to sqlite3 db
    func saveUserInfo() {
        anUser.username = sUsername
        anUser.password = sPassword
        let contactDB = FMDatabase(path: appDel.databasePath as String)
        
        if contactDB.open() {
            
            let insertSQL = "INSERT INTO CONTACTS (username, password) VALUES ('\(sUsername)', '\(sPassword)')"
            
            let result = contactDB.executeUpdate(insertSQL, withArgumentsInArray: nil)
            
            if !result {
                print("Error: \(contactDB.lastErrorMessage())")
            } else {
                print("Success: Contact added")
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(sUsername, forKey: "username")
                defaults.synchronize()
                performSegueWithIdentifier("rq1Segue", sender: self)
            }
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
    }

}
