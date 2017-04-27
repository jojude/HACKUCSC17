//
//  OrgCreateVC.swift
//  Local
//
//  Created by Jude Joseph on 1/21/17.
//  Copyright © 2017 Jude Joseph. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftKeychainWrapper

class OrgCreateVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var typeOfOrgPicker: UIPickerView!
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var emailField: CustomTextField!
    @IBOutlet weak var nameField: CustomTextField!
    @IBOutlet weak var passwordField: CustomTextField!
    
    var imagePicker: UIImagePickerController!
    var imageSelected = false
    var pickerDataArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        typeOfOrgPicker.dataSource = self
        typeOfOrgPicker.delegate = self
        
        pickerDataArray = ["Food", "Education", "Community Service", "Animals", "Sports", "Retail", "Medicine"]
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OrgCreateVC.didTapImageView(_tap:))))
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(OrgCreateVC.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataArray[row]
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
            imageView.image = image
            imageSelected = true
        }else{
            print("JUDE : A valid image wasnt selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createBtnPressed(_ sender: Any) {
        //if all the attributes have been defined then
        if let email = emailField.text, let pwd = passwordField.text, let name = nameField.text{
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (org, error) in
                if error == nil{
                    print(" TEST - EMAIL org Authernticated with Firebase")
                    if let org = org{
                        let orgData = ["provider": org.providerID, "name" : name]
                        self.completeSignIn(id: org.uid, orgData: orgData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (org, error) in
                        if error != nil{
                            print("TEST - Unable to Authenticate with firebase using email \(error!)")
                            self.alert(message: "Unable to Register. Error : \(error!)")
                        } else {
                            print("TEST - Succesful Authentication of email org with Firebase")
                            if let org = org{
                                let orgData = ["provider": org.providerID, "name" : name]
                                self.completeSignIn(id: org.uid, orgData: orgData)
                            }
                        }
                    })
                }
            })
            
        }
        
    }
    
    func postToFirebase(imgUrl: String, id: String){
        
        let logo_image: Dictionary<String, AnyObject> = [
            "imageURL" : imgUrl as AnyObject,
            "name" : nameField.text as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_ORGS.child(id)
        firebasePost.setValue(logo_image)
        
        imageSelected = false
        imageView.image = #imageLiteral(resourceName: "camera_icon")
        
        performSegue(withIdentifier: "makeAPost", sender: self)
    }

    
    func pushOrgToFirebase(id: String){
        guard let img = imageView.image, imageSelected == true else{
            alert(message: "An image must be selected")
            print("JUDE : An image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            
            let imageUid = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.ds.REF_LOGO_IMAGES.child(imageUid).put(imgData, metadata: metaData){(metadata, error) in
                if error != nil{
                    print("JUDE : Unable to upload image to firebase storage")
                }else{
                    print("JUDE : SUCCESSFULL uplaoded image to firebase storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL{
                        self.postToFirebase(imgUrl: url, id: id)
                    }
                }
                
            }
        }
    }
    
    func alert(message: String){
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (org, error) in
            if error != nil{
                print(error!)
                print("TESST - Unable to Authenticate with Firebase")
            }else{
                
                print("TEST - Successful Firebase Authentication")
                if let org = org{
                    let orgData = ["provider": credential.provider]
                    self.completeSignIn(id: org.uid, orgData: orgData)
                }
                
            }
        })
    }
    
    
    func completeSignIn(id: String, orgData: Dictionary<String, String>){
        DataService.ds.createFirebaseDBOrg(uid: id, orgData: orgData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_ID)
        print("TEST - Data saved to keychain \(keychainResult)")
        pushOrgToFirebase(id: id)
        print("TEST - DONE")
        
    }
    
    
    @IBAction func returnBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
