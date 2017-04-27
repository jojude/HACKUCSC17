//
//  DataService.swift
//  Local
//
//  Created by Jude Joseph on 1/21/17.
//  Copyright © 2017 Jude Joseph. All rights reserved.
//

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService{
    static let ds = DataService()
    
    //DB references
    private var _REF_BASE = DB_BASE
    private var _REF_EVENTS = DB_BASE.child("events")
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_ORGS = DB_BASE.child("organizations")
    
    //Storage references
    private var _REF_EVENT_IMAGES = STORAGE_BASE.child("event_pics")
    private var _REF_LOGO_IMAGES = STORAGE_BASE.child("org_logo")
    
    var REF_BASE: FIRDatabaseReference{
        return _REF_BASE
    }
    
    var REF_EVENTS: FIRDatabaseReference{
        return _REF_EVENTS
    }
    
    var REF_ORGS: FIRDatabaseReference{
        return _REF_ORGS
    }
    
    var REF_USERS: FIRDatabaseReference{
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: FIRDatabaseReference{
        let uid = KeychainWrapper.standard.string(forKey: KEY_ID)
        if let userUid = uid{
            let user = REF_USERS.child(userUid)
            return user
        }
        return FIRDatabaseReference()
    }
    
    var REF_ORG_CURRENT: FIRDatabaseReference{
        let uid = KeychainWrapper.standard.string(forKey: KEY_ID)
        if let orgUid = uid{
            let org = REF_ORGS.child(orgUid)
            return org
        }
        return FIRDatabaseReference()
    }
    
    var REF_EVENT_IMAGES: FIRStorageReference{
        return _REF_EVENT_IMAGES
    }
    
    var REF_LOGO_IMAGES: FIRStorageReference{
        return _REF_LOGO_IMAGES
    }
    
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func createFirebaseDBOrg( uid: String, orgData : Dictionary<String, String>){
        REF_ORGS.child(uid).updateChildValues(orgData)
    }
}
