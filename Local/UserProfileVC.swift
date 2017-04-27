//
//  UserProfileVC.swift
//  Local
//
//  Created by Jude Joseph on 1/22/17.
//  Copyright © 2017 Jude Joseph. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class UserProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: CustomImageView!
    @IBOutlet weak var detailLbl: UILabel!
    
    let categories = ["Friends", "Following", "Events Atteneded", "Log Off"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as? CustomProfileTBCell{
            cell.titleLbl.text = categories[indexPath.row]
            return cell
        }else{
            return CustomProfileTBCell()
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3{
            let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_ID)
            print("JUDE : ID Removed from keychain \(keychainResult)")
            try! FIRAuth.auth()?.signOut()
            performSegue(withIdentifier: "goToSignIn", sender: self)
        }
    }

    
}
