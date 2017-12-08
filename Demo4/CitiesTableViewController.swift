//
//  CitiesTableViewController.swift
//  Demo4
//
//  Created by Benjamin Dagg on 11/27/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CitiesTableViewController: UITableViewController, LocationTransferDelegate {
    
    @IBOutlet weak var addBtn: UIBarButtonItem!

    var locations:[Location] = []
    private var swipeGestureRecognizer:UISwipeGestureRecognizer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creates swipe gesture recognizer and adds it to view
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        swipeGestureRecognizer?.direction = .right
        self.view.addGestureRecognizer(swipeGestureRecognizer!)
        
        //add delete function to delete button
        let deleteBtn = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(enableEditing))
        self.navigationItem.leftBarButtonItem = deleteBtn
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //deleteAll()
        
        //load users location from core data if they exist
        if let loc = load() {
            self.locations = loc
        }
 
        //reload table view with new data
        self.tableView.reloadData()
        
        //save user locations to core data in case they changed somethnig
        save()
    }

    
    
    //when leaving this view controller save the users locatin list to core data
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        save()
    }
    
    
    
    /*
    If table view is not in editing mode it puts it in editing mode then changes the delete button text to 'Done'. If is in editing mode it disables editing mode then puts delete button  text as 'Delete'
    */
    func enableEditing(sender: UIBarButtonItem) {
        
        //if not in ediint mode put in editng mode
        if self.tableView.isEditing == false {
            self.tableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }
        //if in editing mode then take out of editing mode
        else {
            self.tableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Delete"
            
        }
    }
    
    
    
    /*
    Implementatin of LocatinTransfer delegate method. Called from another view controller (either addLocationVC or MapVC). Adds the given location object into the location array in this view controller, reloads table view then saves changes to core data
    */
    func addLocation(location: Location) {
        
        self.locations.append(location)
        self.tableView.reloadData()
        save()
    }
    
    
    
    
    /*
    Prepare to segue for the custom swipe segue fromLeftToRightzsegue. Transfers data to map view controller before seguing
    */
    func swipeRight(recognizer: UISwipeGestureRecognizer) {
        
        let destinationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Map") as! MapViewController
        
        //transfer data to map vc
        destinationVC.title = "Map"
        destinationVC.userLocations = self.locations
        destinationVC.delegate = self
        
        //push map view controller and segue
        self.navigationController?.pushViewController(destinationVC, animated: false)
        
    }
    
    
    
    /*
    Prepare to segue transfers the relevant data from this view controller to the destinatin view controller
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //map segue
        if segue.identifier == "mapSegue"{
            print("in segue")
            if let destinationVC = segue.destination as? MapViewController {
                destinationVC.userLocations = self.locations
                destinationVC.delegate = self
            }
        }
        if segue.identifier == "addLocationSegue" {
            print("in add location prepare for segue")
            if let destinationVC = segue.destination as? AddLocationViewController {
                destinationVC.delegate = self
            }
        }
        if segue.identifier == "showLocationOnMap" {
            if let destinationVC = segue.destination as? MapViewController {
                
                guard let index = self.tableView.indexPathForSelectedRow?.row else {
                    return
                }
                destinationVC.userLocations = self.locations
                destinationVC.delegate = self
                destinationVC.selectedLocation = self.locations[index]
                
            }
        }
    }
    
    
    
    
    /*
    When click cell on table view, first decides if the index that was clicked is valid. If valid it segues, if invalid it doesnt segue
    */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showLocationOnMap" {
            
            //make sure a cell was pressed
            guard let index = self.tableView.indexPathForSelectedRow?.row else {
                return false
            }
            //make sure index in bounds
            if index < 0 || index > self.locations.count - 1 {
                return false
            } else {
                return true
            }
        }
        //all other segues can just pass
        return true
    }
    
    
    
    /*
    Load user locations from core data and put them in array
    */
    func load() -> [Location]? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //fetch only the entry in core data that has the given username
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
        
        do {
            let fetchResults = try context.fetch(fetchRequest) as! [Locations]
            if fetchResults.count != 0 {
                var results:[Location]   = []
                for fetch in fetchResults {
                    if let title = fetch.title {
                        print("title = \(title)")
                        let location = Location(name: title, coordinate: CLLocationCoordinate2D(latitude: fetch.lat, longitude: fetch.long), id: Int(fetch.id))
                        
                        //add to results if it doesnt exist
                        if let title = location.title {
                            if title != "" {
                                var exists:Bool = false
                                for l in results {
                                    if l.title == title {
                                        exists = true
                                    }
                                }
                                if exists == false{
                                    results.append(location)
                                }
                            }
                        }
                }
            }
            return results
            }
            
        }catch {
            print("error in loading")
            return nil
        }
        return nil
    }
    
    /*
    Save user locations to core data
    */
    func save() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        for location in self.locations {
            
            var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
            print("id = \(location.id)")
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", location.id as NSNumber)
            do {
                let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
                if let fetchResults = fetchResults {
                    //object already in core data so update it
                    if fetchResults.count != 0 {
                        print("object exists so updating")
                        var managedObject = fetchResults[0]
                        managedObject.setValue(location.coordinate.latitude , forKey:"lat")
                        managedObject.setValue(location.coordinate.longitude, forKey:"long")
                            managedObject.setValue(location.title, forKey: "title")
                            managedObject.setValue(location.id as NSNumber, forKey: "id")
                        do {
                            try context.save()
                        }catch {
                            
                        }
                        
                    }else {
                        print("object DNE so adding it")
                        let entity = NSEntityDescription.entity(forEntityName: "Locations", in: context)
                        let loc = NSManagedObject(entity: entity!, insertInto: context)
                        loc.setValue(location.coordinate.latitude , forKey:"lat")
                             loc.setValue(location.coordinate.longitude, forKey:"long")
                            loc.setValue(location.title, forKey: "title")
                            loc.setValue(location.id, forKey: "id")
                        do {
                            try context.save()
                        }catch {
                            print("failed to save")
                        }
                    }

                }
                
            }catch {
                
            }
            
            
        }
    }
    
    
    
    //Table view methods
   
    //determines # of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    //when click cell of table view segue to the map vc
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //make sure index in bounds
        if indexPath.row >= 0 && indexPath.row <= self.locations.count - 1 {
            self.performSegue(withIdentifier: "showLocationOnMap", sender: self)
        }
        
    }
    
    //draw cells for table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //storyboard id
        let cellIdentifier = "Cell"
        
        //create cell object
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UITableViewCell else{
            fatalError("dequeue cell not instance of CrimeCell")
        }
        
        //put info of location into cell labels
        let location = locations[indexPath.row]
        if let title = location.title {
            cell.textLabel?.text = title
        }
        
        //return cell
        return cell
    }
    
    //size of each table view cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    //when table view is put in editing mode lets user delete a row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
        
            if indexPath.row <= self.locations.count {
                
                //delete record from core data
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let id = self.locations[indexPath.row].id
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
                fetchRequest.predicate = NSPredicate(format:"id = %@", id as NSNumber)
                fetchRequest.fetchLimit = 1
                do {
                    let fetchResults = try context.fetch(fetchRequest) as? [NSManagedObject]
                    if let results = fetchResults {
                        //object already in core data so update it
                        if results.count != 0 {
                            let object = results[0]
                            print("object title is \(object.value(forKey: "title") as! String)")
                            context.delete(object)
                            print("deleted from core data")
                        }else { print("failed do delete. recor dnot found") }
                    }
                }catch {
                    
                }
                
                self.locations.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                
                //update table view
                if let newLocations = load() {
                    self.locations = newLocations
                    tableView.reloadData()
                }
                
                
            }
        }
        else if editingStyle == .insert {
            
        }
    }

    
    func deleteAll(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locations")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                let managedObjectData:NSManagedObject = object as! NSManagedObject
                context.delete(managedObjectData)
            }
        }catch {
            
        }
    }
    
    
    
    //functin used in other view controllers to segue back to this vc
    @IBAction func unwindToTableVC(segue: UIStoryboardSegue) {
        
    }
    
}
