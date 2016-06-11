//
//  LoginViewController.swift
//  ToddsSyndrome
//
//  Created by Dan on 6/10/16.
//  Copyright © 2016 dan.mobile.com. All rights reserved.
//

import UIKit
import SwiftValidator
import FMDB

class LoginViewController: UIViewController, UITextFieldDelegate, ValidationDelegate {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameEdit: UITextField!
    @IBOutlet weak var passwordEdit: UITextField!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var rememberButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    
    // local var
    let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var doRemember = false
    let validator = Validator()
    var anUser = User()
    var sUsername : String = ""
    var sPassword : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        backButton.layer.borderColor = backButton.titleLabel?.textColor.CGColor
        loginButton.layer.borderColor = loginButton.titleLabel?.textColor.CGColor
        
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
    
    override func viewWillAppear(animated: Bool) {
        usernameEdit.text = ""
        doRemember = false
        getRemember()
        if doRemember == true {
            getUserInfo()
        }
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
    
    @IBAction func onRemember(sender: UIButton) {
        doRemember = !doRemember
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(doRemember, forKey: "remember")
        defaults.synchronize()
        setRememberImage()
    }
    
    @IBAction func onLogin(sender: UIButton) {
        validator.validate(self)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "lq1Segue" {
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
        checkUserInfo()
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
    func findUserInfo() {
        let contactDB = FMDatabase(path: appDel.databasePath as String)
        
        if contactDB.open() {
            let querySQL = "SELECT username, password FROM CONTACTS WHERE username = '\(sUsername)'"
            
            let results:FMResultSet? = contactDB.executeQuery(querySQL, withArgumentsInArray: nil)
            
            if results?.next() == true {
                sUsername = (results?.stringForColumn("username"))!
                sPassword = (results?.stringForColumn("password"))!
                print("Record Found")
            } else {
                print("Record not found")
            }
            contactDB.close()
        } else {
            print("Error: \(contactDB.lastErrorMessage())")
        }
        
    }
    
    func checkUserInfo() {
        findUserInfo()
        if sUsername == usernameEdit.text && sPassword == passwordEdit.text {
            anUser.username = sUsername
            anUser.password = sPassword
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(sUsername, forKey: "username")
            defaults.synchronize()

            performSegueWithIdentifier("lq1Segue", sender: self)
        }
        else {
            usernameErrorLabel.text = ""
            passwordErrorLabel.text = ""
            
            let dynamicLabel: UILabel = UILabel()
            dynamicLabel.textColor = UIColor.whiteColor()
            dynamicLabel.textAlignment = NSTextAlignment.Right
            if sUsername != usernameEdit.text {
                dynamicLabel.frame = usernameErrorLabel.frame
                dynamicLabel.text = "invalid username"
                usernameErrorLabel.text = "invalid username"
            }
            else {
                dynamicLabel.frame = passwordErrorLabel.frame
                dynamicLabel.text = "invalid password"
                passwordErrorLabel.text = "invalid password"
            }
            self.loginView.addSubview(dynamicLabel)
        }
    }
    
    func getUserInfo() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let savedUsername = defaults.stringForKey("username") {
            sUsername = savedUsername
        }
        else {
            sUsername = ""
        }
        usernameEdit.text = sUsername
    }
    
    func getRemember() {
        let defaults = NSUserDefaults.standardUserDefaults()
        doRemember = defaults.boolForKey("remember")
        setRememberImage()
    }
    
    func setRememberImage() {
        if doRemember {
            rememberButton.setImage(UIImage(named: "checked.png"), forState: UIControlState.Normal)
        }
        else {
            rememberButton.setImage(UIImage(named: "unchecked.png"), forState: UIControlState.Normal)
        }
    }

}
