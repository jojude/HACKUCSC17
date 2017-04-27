//
//  PostEventVC.swift
//  Local
//
//  Created by Jude Joseph on 1/22/17.
//  Copyright © 2017 Jude Joseph. All rights reserved.
//

import UIKit
import Firebase

class PostEventVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var captionField: CustomTextField!
    @IBOutlet weak var dateField: CustomTextField!
    @IBOutlet weak var locationField: CustomTextField!
    @IBOutlet weak var detailsView: UITextView!
    
    
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var name : String?
    var imageurl : String?
    
    var nameref = FIRDatabaseReference()
    var imageurlref = FIRDatabaseReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        eventImageView.isUserInteractionEnabled = true
        eventImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OrgCreateVC.didTapImageView(_tap:))))
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OrgCreateVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        nameref = DataService.ds.REF_ORG_CURRENT.child("name")
        nameref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snap = snapshot.value as? String{
                self.name = snap
            }
        })
        
        imageurlref = DataService.ds.REF_ORG_CURRENT.child("imageURL")
        imageurlref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snap = snapshot.value as? String{
                self.imageurl = snap
            }
        })

    }
    
    @IBAction func postEventBtnPressed(_ sender: Any) {
        pushOrgToFirebase()
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func didTapImageView(_tap: UITapGestureRecognizer){
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            eventImageView.image = image
            imageSelected = true
        }else{
            print("JUDE : A valid image wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func alert(message: String){
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func postToFirebase(imgUrl: String){
        print("TEST - \(self.name) \(self.imageurl)")
        
        let event: Dictionary<String, AnyObject> = [
            "imageURL" : imgUrl as AnyObject,
            "numberOfLikes" : 0 as AnyObject,
            "numberOfAttendees" : 0 as AnyObject,
            "caption" : self.captionField.text as AnyObject,
            "date" : self.dateField.text as AnyObject,
            "location" : self.locationField.text as AnyObject,
            "details" : self.detailsView.text as AnyObject,
            "ORG" : self.name as AnyObject,
            "logoURL" : self.imageurl as AnyObject
            ]
        
        let firebasePost = DataService.ds.REF_EVENTS.childByAutoId()
        firebasePost.setValue(event)
        
        let orgEvent = DataService.ds.REF_ORG_CURRENT.child("event").child(firebasePost.key)
        orgEvent.setValue(true)
        
        imageSelected = false
        eventImageView.image = #imageLiteral(resourceName: "camera_icon")
        
        performSegue(withIdentifier: "goSeePost", sender: self)
    }
    
    
    func pushOrgToFirebase(){
        guard let img = eventImageView.image, imageSelected == true else{
            alert(message: "An image must be selected")
            print("JUDE : An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            
            let imageUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_EVENT_IMAGES.child(imageUid).put(imgData, metadata: metaData){(metadata, error) in
                if error != nil{
                    print("JUDE : Unable to upload image to firebase storage")
                }else{
                    print("JUDE : SUCCESSFULL uplaoded image to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL{
                        self.postToFirebase(imgUrl: url)
                    }
                }
                
            }
        }
    }

}
