//
//  CrimeListTableViewController.swift
//  Challenge3
//
//  Created by Benjamin Dagg on 10/9/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit

class CrimeListTableViewController: UITableViewController, CrimeInfoTransferDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var crimesArray:[Crime] = []
    var crime:Crime?
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCrimes:[Crime] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        crimesArray.append(Crime(type: "robbery", location: "Seaside", description: "Man robbed outside of Target"))
        
        //search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        //refresh controller
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        
    }
    
    /*
     Called right before the view is about to appear on screen
    */
    override func viewWillAppear(_ animated: Bool) {
        
        //reload table view data on appearence
        tableView.reloadData()
    }
    
    
    //checks if search bar is empty
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /*
     Uses closure to search through crimesArray and find
     values that match the text in the search bar
    */
    func filteredContentsForSearchText(_ searchText: String, scope: String = "All"){
        
        //search through crimesArray for matches
        filteredCrimes = crimesArray.filter({( crime: Crime) -> Bool in
            return crime.type.lowercased().contains(searchText.lowercased()) || crime.location.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        //called right before segue to ViewController when
        //add button is pressed
        if segue.identifier == "ShowVCSegue" {
            print("in prepare for segue")
            let destinationVC = segue.destination as? ViewController
            //sets delegate to use the updateCrime delegate method
            destinationVC?.delegate = self
        }
        //called right before segue to CrimeDetailVC
        if segue.identifier == "CrimeDetailsSegue" {
            let distinationVC = segue.destination as? CrimeDeailsVC
            
            //set the crime info in the CrimedetailVC
            //so everything is loaded before you get there
            let selectedCrime = crimesArray[(tableView.indexPathForSelectedRow?.row)!]
            distinationVC?.selectedCrime = selectedCrime
            distinationVC?.navigationItem.title = selectedCrime.type
    
        }
    }
    
    /*
     Implements dlegate method. Called by VIewControler
     to pass a new crime to this view controller and add it
     to the crimesArray
    */
    func updateCrimeList(crime: Crime) {
        print("delegae mehod called")
        print(crime.type)
        crimesArray.append(crime)
        tableView.reloadData()
        
    }
    
    //required method for tableview tells number of sections
    //in the tabble
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    //required method for table view tells the number of rows
    //to display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if user entered something in search bar
        //then use the filtered results array
        if isFIltering() {
            return filteredCrimes.count
        }
        //if nothing is being searched for then display every row
        return crimesArray.count
        
    }
    
    //required tableview method. Tells table view which
    //cell to draw
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //m custom cell ID
        let cellIdentifier = "CrimeCell"
        
        //get a cell from the queue
        //and cast it as my cutsom cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CrimeCell else{
            fatalError("dequeue cell not instance of CrimeCell")
        }
        
        //crime object to display the crime info for this cell
        let crime:Crime
        //if user is searching for something then
        //take the crime info from the filtered array
        if isFIltering(){
            crime = filteredCrimes[indexPath.row]
        }
        //if not searching take the crime info from the normal array
        else{
            crime = crimesArray[indexPath.row]
        }
        //set the views for this cell
        cell.titleLabel.text = crime.type
        cell.titleLabel.sizeToFit()
        cell.subtitleLabel.text = crime.location
        cell.subtitleLabel.sizeToFit()
        
        return cell
    }
    
    //sets the size for each cell to my custom cell size
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
        
    }
    
    //called by ViewController to return to this viewcontroller
    //when either the cancel of done button is pressed
    @IBAction func unwindToDestinationViewController(sender: UIStoryboardSegue){
        
    }
    
    //checks if user is typing enything in the search bar
    func isFIltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    /*
     Called by refreshController when user refreshes
    */
    func refresh(refreshControl: UIRefreshControl){
        
        //reset search bar text
        self.searchController.searchBar.text? = ""
        //reload table view data
        self.tableView.reloadData()
        
        refreshControl.endRefreshing()
    }
    
    
    
}

extension CrimeListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController){
        filteredContentsForSearchText(searchController.searchBar.text!)
    }
}
