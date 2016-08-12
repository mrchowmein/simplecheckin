//
//  ViewController.swift
//  SimpleCheckin
//
//  Created by Jason Chan MBP on 8/10/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func loginButton(sender: AnyObject) {
        
        if emailField.text == "" && passwordField.text == "" {
            
            let alertController = UIAlertController(title: "Not so fast!", message:
                "Please enter email and password", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            
            FIRAuth.auth()?.signInWithEmail(emailField.text!, password:passwordField.text!) { (user, error) in
                if error != nil {
                    let alertController = UIAlertController(title: "Not so fast!", message:
                        "Incorrect Email or Password", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                    
                else {
                    self.emailField.text = ""
                    self.passwordField.text = ""
                    self.performSegueWithIdentifier("checkinSegue", sender: nil)
                }
            }
            
        }
        
        view.endEditing(true)
    }
    
    
    @IBAction func registerButton(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Register",
                                      message: "Sign up now!",
                                      preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default) { (action: UIAlertAction!) -> Void in
                                        
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        
                                        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password:passwordField.text!) { (user, error) in
                                            
                                            if error != nil {
                                                
                                                print(error!.description)
                                            }
                                                
                                            else {
                                                
                                                self.performSegueWithIdentifier("checkinSegue", sender: nil)
                                                
                                            }
                                        }
                                        
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textEmail) -> Void in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textPassword) -> Void in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth:FIRAuth, user:FIRUser?) in
            if let user = user {
                print("Welcome \(user.email)")
                self.performSegueWithIdentifier("checkinSegue", sender: nil)
            }else{
                print("You need to sign up or login first")
            }
        })
        
    }
    
    
}

