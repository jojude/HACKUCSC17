//
//  CustomTBGoingCell.swift
//  Local
//
//  Created by Jude Joseph on 1/21/17.
//  Copyright © 2017 Jude Joseph. All rights reserved.
//

import UIKit
import Firebase

class CustomTBGoingCell: UITableViewCell {

    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var organization: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    var event : Events!
    
    func configureCell(event : Events, img : UIImage? = nil){
        
        self.eventDate.text = event.date
        self.organization.text = event.orgName
        self.eventTitle.text = event.caption
        
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
                            AttendingVC.imageCache.setObject(img, forKey: event.imageUrl as NSString)
                        }
                    }
                }
            })

        }
    }
}
