//
//  CitiesTableViewController.swift
//  APIChallenge
//
//  Created by Benjamin Dagg on 10/18/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit
import Reachability
import ReachabilitySwift

class CitiesTableViewController: UITableViewController {
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    
    //network alert
    let alert = UIAlertController(title: "Network Status Changed", message: "Must enter a value", preferredStyle: UIAlertControllerStyle.alert)
    var networkStatus:Bool = ReachabilityManager.shared.reachability?.currentReachabilityStatus != .notReachable
    
    var cities:[City] = []
    
    let cityArchiveURL : URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("cities.archive")
    }()
    
    var units:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //try to get users saved units if there is one
        if let tempUnits = UserPreferences.shared.tempUnits {
            self.units = tempUnits
        }
        
        //ReachabilityManager.shared.addListener(listener: self)
        
        //get the cities from memory and re-download their temps
        loadCities()
        getAllTemps()
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        if networkStatus == false {
            alert.title = "Network error"
            alert.message = "Nework unavailable"
            self.present(alert, animated: true)
        }
            
        self.settingsButton.title = NSString(string: "\u{2699}\u{0000FE0E}") as String
        if let font = UIFont(name: "Helvetica", size: 30.0){
            self.settingsButton.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        }
        self.navigationItem.leftBarButtonItem = settingsButton
        
    }
    
    //each time the view appears re-download the weather data for the cities
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //try to get users saved units if there is one
        if let tempUnits = UserPreferences.shared.tempUnits {
            self.units = tempUnits
        }
        
        
        getAllTemps()
        tableView.reloadData()
        
        ReachabilityManager.shared.addListener(listener: self)
        //networkSwitch.isOn = ReachabilityManager.shared.reachability?.currentReachabilityStatus != .notReachable
        
        self.settingsButton.title = NSString(string: "\u{2699}\u{0000FE0E}") as String
        if let font = UIFont(name: "Helvetica", size: 30.0){
            self.settingsButton.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        }
        self.navigationItem.leftBarButtonItem = settingsButton
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ReachabilityManager.shared.removeListener(listener: self)
    }

    //required method for tableview tells number of sections
    //in the tabble
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    //required method for table view tells the number of rows
    //to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cities.count
        
    }
    
    
    
    //required tableview method. Tells table view which
    //cell to draw
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //m custom cell ID
        let cellIdentifier = "Cell"
        
        //get a cell from the queue
        //and cast it as my cutsom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityTableViewCell else{
            fatalError("dequeue cell not instance of CrimeCell")
        }
        
        //crime objy.nect to display the crime info for this cell
        let city:City
        city = cities[indexPath.row]
        
        if !units {
            cell.subTitle?.text = String(city.temp) + " F"
        }else{
            cell.subTitle?.text = String(city.temp) + " C"
        }
        cell.title?.text = city.name
        let weatherData = WeatherResult(temp: city.temp, clouds: city.clouds, rain: city.rain)
        cell.weatherImage.image = getWeatherImg(data: weatherData)
        
        return cell
    }
    
    
    /*
    For each city in the list make a JSON request to the api
     in a seperate thread to find their temps. When all threads
     are finished then reload the table
    */
    func getAllTemps() {
        var unitStr:String
        if units {
            unitStr = "metric"
        }else{
            unitStr = "imperial"
        }
        
        let groupQueue = DispatchQueue(label: "dfdfds", attributes:.concurrent,target:.global(qos:.userInitiated))
        let  group = DispatchGroup()

        for i in 0..<cities.count {

            group.enter()
            groupQueue.async(group:group) {
               
                TempAPI.getData(name: self.cities[i].name, units: unitStr) { result in
                    self.cities[i].temp = result.temp
                    self.cities[i].clouds = result.clouds
                    self.cities[i].rain = result.rain
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main){
            self.tableView.reloadData()
        }
    }
    
    func getWeatherImg(data: WeatherResult) -> UIImage{
        var img:UIImage
        
        if data.rain > 0.0 {
            img = UIImage(named: "rain")!
        }
        else if (data.clouds >= 60){
            img = UIImage(named: "cloud")!
        }
        else {
            img = UIImage(named: "sun")!
        }
        return img
    }
    
    
    /*
     Saves the name of each city in the cities array into memory
     so it can be loaded next time the app opens
    */
    func saveChanges() -> Bool {
        
        print("saving cities...")
        return NSKeyedArchiver.archiveRootObject(cities, toFile: cityArchiveURL.path)
    }
    
    
    /*
     Retrieves the city names from memory and puts them in the cities array
    */
    func loadCities(){
        
        if let archivedItem = NSKeyedUnarchiver.unarchiveObject(withFile: cityArchiveURL.path) as? [City] {
            self.cities = archivedItem
        }
 
    }
    
    //sets the size for each cell to my custom cell size
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
        
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue){
        
        
    }
    
}
extension CitiesTableViewController : NetworkStatusListener {
    
    func networkStatusDidChange(status : Reachability.NetworkStatus){
        print("in vc saus did change")
        
        switch status {
        case .notReachable:
            print("not reachable")
            alert.title = "Network Error"
            alert.message = "Network unavailable"
            self.networkStatus = false
        case .reachableViaWiFi:
            print("wifi reachable")
            if self.networkStatus == false {
                print("in if statement")
                self.alert.title = "Network Status Changed"
                self.alert.message = "Nework is now available"
                self.tableView.reloadData()
                print("at end of if statment")
            }
            self.networkStatus = true
            print("at end of case wifi")
        case .reachableViaWWAN:
            print("WAN reachable")
            if networkStatus == false {
                alert.title = "Network Status Changed"
                alert.message = "Nework is now available"
                getAllTemps()
                self.tableView.reloadData()
            }
            self.networkStatus = true
        }
        self.present(self.alert,animated: true,completion: nil)        //networkSwitch.isOn = ReachabilityManager.shared.reachability?.currentReachabilityStatus != .notReachable
    }
    
}
