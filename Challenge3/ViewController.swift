//
//  ViewController.swift
//  Challenge3
//
//  Created by Benjamin Dagg on 10/2/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//
/*
 This app shows how to make the scrollview scroll up and adjust
 for the keyboard pop up
 */

import UIKit


class ViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var containerView:UIView!
    @IBOutlet var typeField: UITextField!
    @IBOutlet var locaionField:UITextField!
    @IBOutlet var descriptionField: UITextView!
    @IBOutlet var submitButton:UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    weak var delegate:CrimeInfoTransferDelegate?
    
    //error alert
    let alert = UIAlertController(title: "Error", message: "One or more fields empty.", preferredStyle: UIAlertControllerStyle.alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        scrollView.delegate = self
        //sets scrollview frame to size of screen
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        //sets scrollview content size
        scrollView.contentSize = CGSize(width: containerView.frame.size.width, height: view.frame.size.height)
        
        //keyboard notificaions
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        
        
        
    }
    
    
    
    
    
    /*
        Implementation of scrollview delegate function
        to disable horizontal scrolling
    */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 || scrollView.contentOffset.x < 0{
            scrollView.contentOffset.x = 0
        }
    }
    
    
    /*
     This function called when recieve a notification
     that the keyboard has popped up
    */
    func keyboardWillShow(notification: NSNotification){
        print("TRIGGERED")
        
        //get size of keyboard
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        //adjust scrollview insets for keyboard
        var contentInsets = scrollView.contentInset
        contentInsets.bottom = keyboardSize.height
        scrollView.contentInset = contentInsets
        
        //scroll scrollview up
        scrollView.contentOffset.y += keyboardSize.height
    }
    
    
    /*
     this  function called when recieve notificationn that
     keyboard has been dismissed
    */
    func keyboardWillHide(notification:NSNotification){
        print("TRIGGERED")
        
        //get size of keyboard
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        
        //adjust scrollview insets
        var contentInsets = scrollView.contentInset
        contentInsets.bottom  = contentInsets.bottom - keyboardSize.height
        scrollView.contentInset = contentInsets
        
    }
    
    func formIsValid() -> Bool {
        
        if (typeField.text?.isEmpty)! {
            return false
        }
        else if (locaionField.text?.isEmpty)! {
            return false
        }
        else if descriptionField.text.isEmpty {
            return false
        }
        else{
            return true
        }
        
    }
    
    @IBAction func addButtonPressed(sender: UIBarButtonItem){
        print("add button pressed")
        if formIsValid() == false{
            self.present(alert,animated: true,completion: nil)
        }
        else{
            var newcrime = Crime(type: typeField.text!, location: locaionField.text!, description: descriptionField.text)
            delegate?.updateCrimeList(crime: newcrime)
            print("delegate method called in vc")
            self.performSegue(withIdentifier: "UnwindSegue", sender: self)
            
        }
    }
    
    func submitButtonPressed(sender:UIButton){
        if formIsValid() == false{
            self.present(alert,animated: true,completion: nil)
        }
        else{
            var newcrime = Crime(type: typeField.text!, location: locaionField.text!, description: descriptionField.text)
            
            
        }
    }
    
    
    
    @IBAction func cancelButtonPressed(sender:UIBarButtonItem){
        print("cancel button pressed")
        //self.performSegue(withIdentifier: "UnwindSegue", sender: self)
    }


}
extension UIViewController {
    
    
    func hideKeyboardWhenTappedAround(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
}

