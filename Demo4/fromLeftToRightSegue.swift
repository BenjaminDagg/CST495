//
//  fromLeftToRightSegue.swift
//  Demo4
//
//  Created by Benjamin Dagg on 11/27/17.
//  Copyright © 2017 Benjamin Dagg. All rights reserved.
//

/*
Custom segue to segue when user swipes left on screen
*/

import UIKit

class fromLeftToRightSegue: UIStoryboardSegue {
    
    override func perform() {
        let firstVC = self.source.view as UIView!
        let secondVC = self.destination.view as UIView!
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        secondVC?.frame = CGRect(x: -screenWidth, y: 0, width: screenWidth, height: screenHeight)
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVC!, aboveSubview: firstVC!)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            firstVC?.frame = (firstVC?.frame.offsetBy(dx: CGFloat(0.0), dy: CGFloat(0.0)))!
            secondVC?.frame = (secondVC?.frame.offsetBy(dx:screenWidth, dy: CGFloat(0.0)))!
        }) {(finished) -> Void in
            self.source.present(self.destination as UIViewController, animated: false, completion: nil)
        }
    }
    
}
