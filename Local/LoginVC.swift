//
//  ViewController.swift
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

class LoginVC: UIViewController {
    
    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var fbloginbutton: CustomButton!
    @IBOutlet weak var loginButton: CustomButton!
    
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginContraint: NSLayoutConstraint!
    @IBOutlet weak var usernameContraint: NSLayoutConstraint!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var businessButton: CustomButton!
    @IBOutlet weak var personButton: CustomButton!
    var engine : AnimationEngine!
    var active = false
    
    
    @IBAction func personBtnPressed(_ sender: Any) {
        engine = AnimationEngine(constraints: [passwordConstraint, usernameContraint, loginContraint])
        disappear()
        appear()
        engine.animateOnScreen(1)
    }
    
    func appear(){
        usernameTextField.alpha = 1.0
        passwordTextField.alpha = 1.0
        loginButton.alpha = 1.0
        fbloginbutton.alpha = 1.0
    }
    
    func disappear(){
        questionLabel.alpha = 0.0
        orLabel.alpha = 0.0
        businessButton.alpha = 0.0
        personButton.alpha = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func alert(message: String){
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // FIREBASE LOGIN //
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if active {
            if let email = usernameTextField.text, let pwd = passwordTextField.text{
                FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                    if error == nil{
                        print(" TEST - EMAIL USER Authernticated with Firebase")
                        if let user = user{
                            let userData = ["provider": user.providerID]
                            self.completeSignIn(id: user.uid, userData: userData)
                        }
                    } else {
                        FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                            if error != nil{
                                print("TEST - Unable to Authenticate with firebase using email \(error!)")
                                self.alert(message: "Unable to Register. Error : \(error!)")
                            } else {
                                print("TEST - Succesful Authentication of email user with Firebase")
                                if let user = user{
                                    let userData = ["provider": user.providerID]
                                    self.completeSignIn(id: user.uid, userData: userData)
                                }
                            }
                        })
                    }
                })
            }
        }else{
            active = true
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil{
                print(error!)
                print("TESST - Unable to Authenticate with Firebase")
            }else{
                
                print("TEST - Successful Firebase Authentication")
                if let user = user{
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
                
            }
        })
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>){
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_ID)
        print("TEST - Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "showEventVC", sender: self)
    }
    
    
    // AUTHENTICATING FACEBOOK LOGIN //
    
    @IBAction func facebookButtonPressed(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logIn(withReadPermissions: ["email", "public_profile", "user_friends"], from: self){(result, error) in
            if error != nil{
                print(error!)
            }else if result?.isCancelled == true{
                print("TEST - User cancelled facebook Authentication")
            }else{
                print("TEST - Successful Facebook Authentication")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
        
    }
    
}

