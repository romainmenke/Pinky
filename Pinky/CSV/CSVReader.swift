//
//  TrainingData.swift
//  ai
//
//  Created by Romain Menke on 07/04/15.
//  Copyright (c) 2015 Menke Dev. All rights reserved.
//

import Foundation


class CSVReader {
    
    var error : NSErrorPointer
    var csv : CSV

    init(filename:String) {
        error = nil
        let csvURL = NSBundle(forClass: CSVReader.self).URLForResource(filename, withExtension: "csv")
        csv = try! CSV(contentsOfURL: csvURL!)
    }
    
    init(path:NSURL) {
        error = nil
        csv = try! CSV(contentsOfURL: path)
    }
}