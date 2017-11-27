//
//  CrimeDetailsVC.swift
//  Challenge3
//
//  Created by Benjamin Dagg on 10/11/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit

class CrimeDeailsVC: UIViewController {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    
    var selectedCrime:Crime?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.typeLabel.text = selectedCrime?.type
        self.locationLabel.text = selectedCrime?.location
        self.descriptionField.text = selectedCrime?.desc
    }
    
}
