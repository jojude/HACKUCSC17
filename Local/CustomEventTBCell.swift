//
//  CustomEventTBCell.swift
//  Local
//
//  Created by Jude Joseph on 1/21/17.
//  Copyright © 2017 Jude Joseph. All rights reserved.
//

import UIKit
import Firebase

class CustomEventTBCell: UITableViewCell {

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var numberOfAttendees: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var organization: UILabel!
    @IBOutlet weak var organizationProfilePic: CustomImageView!

    var event : Events!
    var likesref = FIRDatabaseReference()
    var attendingref = FIRDatabaseReference()

    
    
    func configureCell(event : Events, img: UIImage? = nil, logo: UIImage? = nil){
        self.event = event
        
        likesref = DataService.ds.REF_USER_CURRENT.child("likes").child(event.eventKey)
        attendingref = DataService.ds.REF_USER_CURRENT.child("attending").child(event.eventKey)
        
        self.eventTitle.text = event.caption
        self.date.text = event.date
        self.numberOfLikes.text = String(event.numberOfLikes)
        self.numberOfAttendees.text = String(event.numberOfAttendees)
        self.organization.text = event.orgName
        
        if img != nil{
            self.eventImage.image = img
        }else{
            let ref = FIRStorage.storage().reference(forURL: event.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil{
                    print("TEST - Unable to download image from firebase storage")
                }else{
                    print("TEST - IMAGE downladed from firebase storage")
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.eventImage.image = img
                            EventVC.imageCache.setObject(img, forKey: event.imageUrl as NSString)
                        }
                    }
                }
            })

        }
        
        if logo != nil{
            self.organizationProfilePic.image = logo
        }else{
            let ref = FIRStorage.storage().reference(forURL: event.orgLogoUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil{
                    print("TEST - Unable to download image from firebase storage")
                }else{
                    print("TEST - IMAGE downladed from firebase storage")
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.organizationProfilePic.image = img
                            EventVC.imageCache.setObject(img, forKey: event.orgLogoUrl as NSString)
                        }
                    }
                }
            })
        }
        
        /*
        likesref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                
            }
        })
        */
    }


    @IBAction func attendingButtonPressed(_ sender: Any){
        print("TEST - ATTENDING PRESSED")
        attendingref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.event.adjAttendingCount(add: true)
                self.attendingref.setValue(true)
            }else{
                self.event.adjAttendingCount(add: false)
                self.attendingref.removeValue()
            }
        })
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        print("TEST - BUTTON PRESSED")
        likesref.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull{
                print("TEST - LIKES ADJUSTED")
                self.event.adjLikes(addLikes: true)
                self.likesref.setValue(true)
            }else{
                self.event.adjLikes(addLikes: false)
                self.likesref.removeValue()
            }
        })
        
    }
}
