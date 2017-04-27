//
//  AttendingVC.swift
//  Local
//
//  Created by Jude Joseph on 1/21/17.
//  Copyright © 2017 Jude Joseph. All rights reserved.
//

import UIKit
import Firebase

class AttendingVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var numberOfEventsLbl: UILabel!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()

    //var eventId = [String]()
    var events : Events!
    var attendingEvents = [Events]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numberOfEventsLbl.text = "Attending \(self.attendingEvents.count) Events"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getKeys()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let likesref = DataService.ds.REF_USER_CURRENT.child("attending")
        print("TEST - \(likesref)")
        
        if self.attendingEvents.count < 1{
            self.numberOfEventsLbl.text = "Attending \(self.attendingEvents.count) Events"
        }
        self.tableView.reloadData()
        
    }
    
    func getKeys(){
        let likesref = DataService.ds.REF_USER_CURRENT.child("attending")
        likesref.observe(.value, with: { (snapshot) in
            print("TEST - reloaded")
            self.attendingEvents = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot{
                    let event = DataService.ds.REF_EVENTS.child(snap.key)
                    print("TEST - \(event)")
                    event.observe(.value, with: { (snapshot) in
                        let snap = snapshot
                        print("TEST - \(snap)")
                        if let eventDict = snap.value as? Dictionary<String, AnyObject>{
                            let event = Events(eventkey: snap.key, eventData: eventDict)
                            self.attendingEvents.append(event)
                            print("TEST - \(self.attendingEvents)")
                        }
                        self.numberOfEventsLbl.text = "Attending \(self.attendingEvents.count) Events"
                       // self.tableView.reloadData()
                        
                    })

                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendingEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let event = self.attendingEvents[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "goingcell", for: indexPath) as? CustomTBGoingCell{
            
            if let img = EventVC.imageCache.object(forKey: event.imageUrl as NSString){
                cell.configureCell(event: event, img: img)
            }else{
                cell.configureCell(event: event)
            }
            return cell
        }else{
            return CustomTBGoingCell()
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailz" ,
            let nextScene = segue.destination as? EventDetailsVC ,
            let indexPath = self.tableView.indexPathForSelectedRow {
            let event = attendingEvents[indexPath.row]
            nextScene.event = event
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailz", sender: self)
    }

}
