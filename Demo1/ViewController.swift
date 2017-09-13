//
//  ViewController.swift
//  Demo1
//
//  Created by Benjamin Dagg on 9/2/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    /*======= Outlets ========*/
    @IBOutlet var binaryConvererLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var convertButton: UIButton!
    @IBOutlet var resultLabel: UILabel!
    
    //error alert
    let alert = UIAlertController(title: "Error", message: "Must enter a value", preferredStyle: UIAlertControllerStyle.alert)
    
   
    //implement text field delegate
    func textField(_ tf: UITextField,shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let notAllowedCharacters = ".23456789"
        let set = NSCharacterSet(charactersIn: notAllowedCharacters)
        let inverted = set.inverted
        let filtered = string.components(separatedBy: inverted).joined(separator: "")
        let char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if isBackSpace == -92 {
            return true
        }
        return filtered != string
        
    }
    
        
    
    
    //return num^pow recursively
    func power(num: Int, pow: Int) -> Int {
        if pow <= 0{
            return 1
        }
        return num * power(num:num,pow:pow - 1)
    }
    
    //takes in string of binary characters and converts to decimal
    func  binaryToDecimal(binary: String) -> Int? {
        var result: Int = 0
        
        for (index, element) in binary.characters.enumerated(){
            if element == "1" {
                result = result + power(num:2,pow: (binary.characters.count - 1) - index)
            }
        }
        
        return result
    }
    
    //this is called when the convert button is presssed
    //takes the text in the text field and converts it to binary
    @IBAction func convert(_sender: UIButton){
        
        //check if anything is entered in text field
        if let text = textField.text, textField.text?.isEmpty == false {
            let result: Int! = binaryToDecimal(binary: text)
            
            //check if conversion is valid
            if let r = result {
                let text = "Result: \(String(r))"
                resultLabel.text = text
                resultLabel.isHidden = false
            }
            else{
                print("Something went wrong in conversion")
            }
        }
        else{
            self.present(alert,animated: true,completion: nil)
            print("Error. Nothing entered in text field")
            resultLabel.text = ""
        }
    }
    
    @IBAction func dismissKeyboard(_sender: UITapGestureRecognizer){
            textField.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height / 10
        
        resultLabel.isHidden = true
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        //top rectangle
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}

