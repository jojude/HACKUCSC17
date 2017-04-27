//
//  Events.swift
//  Local
//
//  Created by Jude Joseph on 1/21/17.
//  Copyright © 2017 Jude Joseph. All rights reserved.
//

import Foundation
import Firebase

class Events{
    
    private var _caption : String!
    private var _date : String!
    private var _details : String!
    private var _imageUrl: String!
    private var _location : String!
    private var _numberOfAttendees : Int!
    private var _numberOfLikes : Int!
    private var _org : String!
    private var _orgLogoUrl : String!
    
    private var _eventKey : String!
    private var _eventRef : FIRDatabaseReference!
    
    var eventKey : String{
        return _eventKey
    }
    
    var orgLogoUrl : String{
        return _orgLogoUrl
    }
    
    var orgName : String{
        return _org
    }
    
    var caption : String{
        return _caption
    }
    
    var date : String{
        return _date
    }
    
    var details : String{
        return _details
    }
    
    var imageUrl : String{
        return _imageUrl
    }
    
    var location : String{
        return _location
    }
    
    var numberOfAttendees : Int {
        return _numberOfAttendees
    }
    
    var numberOfLikes : Int{
        return _numberOfLikes
    }
    
    init(caption: String, numberOfLikes: Int, details : String, location: String, numberOfAttendees: Int, date: String, imageUrl : String, orgName : String, orgLogoUrl : String){
        self._caption = caption
        self._date = date
        self._details = details
        self._imageUrl = imageUrl
        self._location = location
        self._numberOfAttendees = numberOfAttendees
        self._numberOfLikes = numberOfLikes
        self._org = orgName
        self._orgLogoUrl = orgLogoUrl
    }
    
    
    init(eventkey: String, eventData: Dictionary<String, AnyObject>){
        self._eventKey = eventkey
        
        if let caption = eventData["caption"] as? String{
            self._caption = caption
        }
        if let imageURL = eventData["imageURL"] as? String{
            self._imageUrl = imageURL
        }
        if let likes = eventData["numberOfLikes"] as? Int{
            self._numberOfLikes = likes
        }
        if let attending = eventData["numberOfAttendees"] as? Int{
            self._numberOfAttendees = attending
        }
        if let description = eventData["description"] as? String{
            self._details = description
        }
        if let location = eventData["location"] as? String{
            self._location = location
        }
        if let date = eventData["date"] as? String{
            self._date = date
        }
        if let orgName = eventData["ORG"] as? String{
            self._org = orgName
        }
        if let orgLogoUrl = eventData["logoURL"] as? String{
            self._orgLogoUrl = orgLogoUrl
        }
        if let details = eventData["details"] as? String{
            self._details = details
        }
        
        _eventRef = DataService.ds.REF_EVENTS.child(_eventKey)
    }
    
    func adjLikes(addLikes : Bool){
        if addLikes{
            _numberOfLikes = _numberOfLikes + 1
        }else{
            _numberOfLikes = _numberOfLikes - 1
        }
        
        _eventRef.child("numberOfLikes").setValue(_numberOfLikes)
        print("TEST - LIKE ADJUST")
    }
    
    func adjAttendingCount(add: Bool){
        if add{
            _numberOfAttendees = _numberOfAttendees + 1
        }else{
            _numberOfAttendees = _numberOfAttendees - 1
        }
        
        _eventRef.child("numberOfAttendees").setValue(_numberOfAttendees)
        print("TEST - ATTENDANCE ADJUST")
    }
    
}
