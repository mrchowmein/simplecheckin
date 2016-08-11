//
//  CheckinViewController.swift
//  SimpleCheckin
//
//  Created by Jason Chan MBP on 8/11/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CheckinViewController: UIViewController {

    var dbRef: FIRDatabaseReference!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var hostField: UITextField!
    
    @IBAction func checkinButton(sender: AnyObject) {
    
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateformatter.timeStyle = NSDateFormatterStyle.LongStyle
        let now = dateformatter.stringFromDate(NSDate())
        
        let guestName = nameField.text
        let hostName = hostField.text
        let guest = guests(time:now, name: guestName!, host: hostName!)
        
        if guestName != "" {
        let guestRef = dbRef.child(now.lowercaseString)
            guestRef.setValue(guest.toAnyObject())
            nameField.text = ""
            hostField.text = ""
            
        } else {
            
            let alertController = UIAlertController(title: "Error", message:
                "Please enter your name", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dbRef = FIRDatabase.database().reference().child("guests")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
