//
//  DataDetection.swift
//  Pinky
//
//  Created by Romain Menke on 08/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import Foundation


extension String {
    
    func isNumber() -> Bool {
        
        if Double(self) != nil {
            return true
        } else {
            return false
        }
    }
    
}


// fade this out
func stringIsNumber(string:String) -> Bool {
    
    print(string)
    
    if Double(string) != nil {
        return true
    }
    else {
        print("not a float")
        return false
    }
    
}





