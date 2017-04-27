//
//  EventVC.swift
//  Local
//
//  Created by Jude Joseph on 1/21/17.
//  Copyright © 2017 Jude Joseph. All rights reserved.
//

import UIKit
import Firebase

class EventVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var events = [Events]()
    var refEvents = FIRDatabaseReference()
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupTable()
    }
    
    func setupTable(){
        refEvents = DataService.ds.REF_EVENTS
        
        refEvents.observe(.value, with: { (snapshot) in
            
            self.events = []
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshot{
                    if let eventDict = snap.value as? Dictionary<String, AnyObject>{
                        let key = snap.key
                        let event = Events(eventkey: key, eventData: eventDict)
                        self.events.append(event)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
                
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomEventTBCell{
            
            if let img = EventVC.imageCache.object(forKey: event.imageUrl as NSString){
                if let logo = EventVC.imageCache.object(forKey: event.orgLogoUrl as NSString){
                    cell.configureCell(event: event, img: img, logo : logo)
                }
            }else{
                cell.configureCell(event: event)
            }
            return cell
        }else{
            return CustomEventTBCell()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showDetails" ,
                let nextScene = segue.destination as? EventDetailsVC ,
                let indexPath = self.tableView.indexPathForSelectedRow {
                let event = events[indexPath.row]
                nextScene.event = event
            }
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
}

