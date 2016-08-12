//
//  GuestLogTableViewController.swift
//  SimpleCheckin
//
//  Created by Jason Chan MBP on 8/11/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class GuestLogTableViewController: UITableViewController{

    
    var dbRef: FIRDatabaseReference!
    
    var guest = [guests]()
    
    @IBAction func signOutButton(sender: AnyObject) {
        
        try! FIRAuth.auth()!.signOut()
        
        self.dismissViewControllerAnimated(true, completion: nil)
 
    }
    
    @IBAction func backButtonInv(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth:FIRAuth, user:FIRUser?) in
            
            if user?.uid != nil {
            self.dbRef = FIRDatabase.database().reference().child("\(user!.uid)")
            }
        })
       
        
        
    }
    
    func startObservingDB () {
        dbRef.observeEventType(.Value, withBlock: { (snapshot:FIRDataSnapshot) in
           
            var newGuests = [guests]()
            
            for guest in snapshot.children {
                let guestObject = guests(snapshot: guest as! FIRDataSnapshot)
                newGuests.append(guestObject)
            }
            
            self.guest = newGuests
            self.tableView.reloadData()
            
        }) { (error:NSError) in
            print(error.description)
        }
    }
    
    
    
    
    
    
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        FIRAuth.auth()?.addAuthStateDidChangeListener({ (auth:FIRAuth, user:FIRUser?) in
            if let user = user {
                print("Welcome \(user.email)")
                self.startObservingDB()
            }else{
                print("You need to sign up or login first")
            }
        })
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return guest.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let guests = guest[indexPath.row]
        
        cell.textLabel?.text = guests.name + "  Host: " + guests.host
        cell.detailTextLabel?.text = guests.time
        
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let guests = guest[indexPath.row]
            
            guests.guestRef?.removeValue()
        }
    }
    
    
    
  


}
