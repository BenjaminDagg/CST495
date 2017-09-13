//
//  ImageFilterViewController.swift
//  Demo1
//
//  Created by Benjamin Dagg on 9/2/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

import UIKit
import CoreImage


class ImageFilterViewController: UIViewController {
    
    //******* scrollview Views *******//
    @IBOutlet var scrollView: UIScrollView!
    var containerView: UIView!
    
    
    //image view
    @IBOutlet var imageView: UIImageView?
    var originalImage:UIImage! // holds original image w/o filters
    
    //array of FilterButton objects to hold filter info for each button
    var filterArr: [FilterButton] = []
    
    //alrt
    //creates alert
    let alert = UIAlertController(title: "Success", message: "Filter Applied", preferredStyle: UIAlertControllerStyle.alert)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //copy original image
        if let image = imageView?.image{
            originalImage = image
        }
        
        //adding different filters to filter array
        filterArr.append(FilterButton(filterString: "CIGaussianBlur", buttonTitle: "Blur"))
        filterArr.append(FilterButton(filterString: "CISepiaTone", buttonTitle: "Sepia"))
        filterArr.append(FilterButton(filterString: "CIBloom", buttonTitle: "Bloom"))
        filterArr.append(FilterButton(filterString: "CIPhotoEffectMono", buttonTitle: "B & W"))
        filterArr.append(FilterButton(filterString: "CIColorInvert", buttonTitle: "Negative"))
        filterArr.append(FilterButton(filterString: "CIColorPosterize", buttonTitle: "Posterize"))
        filterArr.append(FilterButton(filterString: "CIPhotoEffectTransfer", buttonTitle: "Vintage"))
        filterArr.append(FilterButton(filterString: "CIColorControls", buttonTitle: "Saturate"))
        filterArr.append(FilterButton(filterString: "CIComicEffect", buttonTitle: "Comic"))
        filterArr.append(FilterButton(filterString: "CIEdgeWork", buttonTitle: "Pencil"))
        

        let buttonSpacing: Int = 110 //horiz. space between each button in the scrollView
        
        //add ok button action to the alert
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        
        //create scrollView view
        scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: buttonSpacing * 10, height: 100)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        //scrollView container UIView
        containerView = UIView()
        
        
        //adding buttons to the scrollView container
        for index in 0...9 {
            
            //set frame for each button horizonttally
            filterArr[index].frame = CGRect(x: index * buttonSpacing, y: 0, width: 100, height: 45)
            //set title of each button
           filterArr[index].setTitle(filterArr[index].buttonTitle, for: UIControlState.normal)
            //set action of buttons to set the buttons filter
            filterArr[index].addTarget(self, action: #selector(applyFilter(sender:)),for: UIControlEvents.touchUpInside)
            //add buttons to scrollview container view
            self.containerView.addSubview(filterArr[index])
            
        }
        //add scrolview container view to the scrollview
        scrollView.addSubview(containerView)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        //add scrollView to UIViewController
        view.addSubview(scrollView)
        
        //***** scrollview constraints ******
        let scrollViewTopAnchor = scrollView.topAnchor.constraint(equalTo: (imageView?.bottomAnchor)!, constant: 50)
        scrollViewTopAnchor.isActive = true
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //gets screen dimensions
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        //sets frame for scrollView
        scrollView.frame = CGRect(x: 0, y: 450, width: screenWidth, height: 100)
        
        //sets frame for scrollView's container view
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        
    }
    
    //displays alert. Called when filter button successfully applies
    func showAlert(){
        
        //display alert
        self.present(alert,animated: true,completion: nil)
    }
    
    /*
    This is called when one of the filter buttons in the scrollview is clicked. It creates a CIFilter object with the string in the button and applies the paramaters for the filtr then applies it
    */
    func applyFilter(sender:FilterButton){
        
        //reset image to original
        imageView?.image = originalImage
        
        //make sure image view is not nil
        if let image = imageView?.image, let cgimg = imageView?.image?.cgImage{
            
            //convert image views UIImage to CIImage
            let coreImage = CIImage(cgImage: cgimg)
            
            //create filter object based on pressed buttons value
            let filter = CIFilter(name: sender.filterString)
            filter?.setValue(coreImage,forKey:kCIInputImageKey)
            
            //apply different values based on which filter
            //blur filter
            if sender.filterString == "CIGaussianBlur"{
                filter?.setValue(8, forKey: kCIInputRadiusKey)
            }
            //negative
            else if sender.filterString == "CIColorInvert"{
                
            }
            //bloom
            else if sender.filterString == "CIBloom"{
                filter?.setValue(10, forKey: kCIInputRadiusKey)
                filter?.setValue(0.5, forKey: kCIInputIntensityKey)
            }
            // B & W
            else if sender.filterString == "CIPhotoEffectMono"{
                filter?.setDefaults()
                
            }
            //posterize
            else if sender.filterString == "CIColorPosterize" {
                filter?.setDefaults()
            }
            //vintage
            else if sender.filterString == "CIPhotoEffectTransfer"{
            }
            //saturate
            else if sender.filterString == "CIColorControls"{
                filter?.setValue(3.5, forKey: "inputSaturation")
                filter?.setValue(0.3, forKey: "inputBrightness")
                filter?.setValue(1.0, forKey: "inputContrast")
            }
            //comic
            else if sender.filterString == "CIComicEffect"{
                //do nothing
            }
            //pencil
            else if sender.filterString == "CIEdgeWork"{
                imageView?.backgroundColor = UIColor.black
                filter?.setValue(0.5, forKey: "inputRadius")
            }
            //sepia
            else{
                filter?.setValue(1.0, forKey: kCIInputIntensityKey)
            }
            
            //check that the filter was successfully applied
            if let output = filter?.value(forKey: kCIOutputImageKey)  {
                //change image views image tto the filter image
                let filteredImage = UIImage(ciImage: output as! CIImage)
                imageView?.image = filteredImage
                
                //display alert to show it successfully applied filter
                showAlert()
            }
            else{
                print("image filtering failed")
            }
            
        }
        else{
            print("imageview has no image")
        }
        
    }
   
}
