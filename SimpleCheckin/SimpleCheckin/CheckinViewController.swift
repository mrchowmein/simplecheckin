//
//  CheckinViewController.swift
//  SimpleCheckin
//
//  Created by Jason Chan MBP on 8/11/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase

class CheckinViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var dbRef: FIRDatabaseReference!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var hostField: UITextField!
    
    @IBOutlet var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func checkinButton(sender: AnyObject) {
        
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateformatter.timeStyle = NSDateFormatterStyle.LongStyle
        let now = dateformatter.stringFromDate(NSDate())
        
        let guestName = nameField.text
        let hostName = hostField.text
        let guest = guests(time:now, name: guestName!, host: hostName!)
        
        // save to firebase
        if guestName != "" {
            let guestRef = dbRef.child(now.lowercaseString)
            guestRef.setValue(guest.toAnyObject())
            nameField.text = ""
            hostField.text = ""
            
            //printing
            
            let printController = UIPrintInteractionController.sharedPrintController()
            
            let printInfo = UIPrintInfo(dictionary:nil)
            printInfo.outputType = UIPrintInfoOutputType.General
            printInfo.jobName = "print Job"
            printController.printInfo = printInfo
            
            
            let formatter = UIMarkupTextPrintFormatter(markupText: guestName! + " \n" + hostName! + " \n" + now)
            formatter.contentInsets = UIEdgeInsets(top: 72, left: 72, bottom: 72, right: 72)
            printController.printFormatter = formatter
            
            printController.presentAnimated(true, completionHandler: nil)
            
        } else {
            
            let alertController = UIAlertController(title: "Error", message:
                "Please enter your name", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
        view.endEditing(true)
    }
    
    
    
    @IBAction func infoButton(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Authentication Required", message: "Enter user password", preferredStyle: .Alert)
        
        
        let signinAction = UIAlertAction(title: "Signin",
                                         style: .Default) { (action: UIAlertAction!) -> Void in
                                            
                                            
                                            let passwordField = alert.textFields?[0].text
                                            
                                            if passwordField == "" {
                                                
                                                let alertController = UIAlertController(title: "Not so fast!", message:
                                                    "Please enter password", preferredStyle: UIAlertControllerStyle.Alert)
                                                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                                                self.presentViewController(alertController, animated: true, completion: nil)
                                            }
                                            else {
                                                
                                                
                                                let user = FIRAuth.auth()?.currentUser
                                                
                                                
                                                
                                                FIRAuth.auth()?.signInWithEmail(user!.email!, password:passwordField!) { (user, error) in
                                                    if error != nil {
                                                        let alertController = UIAlertController(title: "Not so fast!", message:
                                                            "Incorrect Password", preferredStyle: UIAlertControllerStyle.Alert)
                                                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                                                        self.presentViewController(alertController, animated: true, completion: nil)
                                                    }
                                                        
                                                    else {
                                                        
                                                        self.performSegueWithIdentifier("logSegue", sender: nil)
                                                        
                                                        
                                                    }}
                                            }}
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        
        
        alert.addTextFieldWithConfigurationHandler {
            (passwordField) -> Void in
            passwordField.placeholder = "password"
            passwordField.secureTextEntry = true
            
            alert.addAction(signinAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert,
                animated: true,
                completion: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth:FIRAuth, user:FIRUser?) in
            
            if user?.uid != nil {
                self.dbRef = FIRDatabase.database().reference().child("\(user!.uid)")
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Mark: - Imagepicker
    
    
    
    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        
        
        if UIDevice.currentDevice().orientation == UIDeviceOrientation.Portrait{
            
            let alert = UIAlertController(title: "Authentication Required", message: "Enter user password", preferredStyle: .Alert)
            
            
            let signinAction = UIAlertAction(title: "Signin",
                                             style: .Default) { (action: UIAlertAction!) -> Void in
                                                
                                                
                                                let passwordField = alert.textFields?[0].text
                                                
                                                if passwordField == "" {
                                                    
                                                    let alertController = UIAlertController(title: "Not so fast!", message:
                                                        "Please enter password", preferredStyle: UIAlertControllerStyle.Alert)
                                                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                                                    self.presentViewController(alertController, animated: true, completion: nil)
                                                }
                                                else {
                                                    
                                                    
                                                    let user = FIRAuth.auth()?.currentUser
                                                    
                                                    
                                                    
                                                    FIRAuth.auth()?.signInWithEmail(user!.email!, password:passwordField!) { (user, error) in
                                                        if error != nil {
                                                            let alertController = UIAlertController(title: "Not so fast!", message:
                                                                "Incorrect Password", preferredStyle: UIAlertControllerStyle.Alert)
                                                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                                                            self.presentViewController(alertController, animated: true, completion: nil)
                                                        }
                                                            
                                                        else {
                                                            
                                                            self.imagePicker.allowsEditing = false
                                                            self.imagePicker.sourceType = .PhotoLibrary
                                                            
                                                            self.presentViewController(self.imagePicker, animated: true, completion: nil)
                                                            
                                                            
                                                        }}
                                                }}
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .Default) { (action: UIAlertAction!) -> Void in
            }
            
            
            
            alert.addTextFieldWithConfigurationHandler {
                (passwordField) -> Void in
                passwordField.placeholder = "password"
                passwordField.secureTextEntry = true
                
                alert.addAction(signinAction)
                alert.addAction(cancelAction)
                
                self.presentViewController(alert,
                    animated: true,
                    completion: nil)
            }
            
        } else {
            
            let alertController = UIAlertController(title: "Not so fast!", message:
                "Please rotate to portrait mode", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFill
            imageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
