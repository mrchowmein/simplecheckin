//
//  Members.swift
//  CampManager
//
//  Created by Jason Chan MBP on 7/26/16.
//  Copyright © 2016 Jason Chan. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

struct guests {
    
    
    
    let time:String!
    let name:String!
    let host:String!
    let key:String!
    let guestRef:FIRDatabaseReference?
    
    init (time:String, name:String, host:String, key:String = "") {
        
        self.time = time
        self.name = name
        self.host = host
        self.key = key
        self.guestRef = nil
    }
    
    init (snapshot:FIRDataSnapshot) {
        key = snapshot.key
        guestRef = snapshot.ref
        
        if let timeContent = snapshot.value!["time"] as? String {
            time = timeContent
        }else {
            time = ""
        }
        
        if let nameContent = snapshot.value!["name"] as? String {
            name = nameContent
        }else {
            name = ""
        }
        
        if let hostContent = snapshot.value!["host"] as? String {
            host = hostContent
        }else {
            host = ""
        }
        
        
        
    }
    
    func toAnyObject() -> AnyObject {
        return ["time":time, "name":name, "host":host]
    }
    
}