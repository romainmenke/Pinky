//
//  RowsColumnsAndPoints.swift
//  Pinky
//
//  Created by Romain Menke on 08/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import Foundation


class DataPoint {
    
    var stringValue : String = ""
    var floatValue : Float = 0 {
        didSet {
            stringValue = "\(floatValue)"
        }
    }
    
    init() {
    }
    
    init(float_I: Float) {
        floatValue = float_I
        stringValue = "\(floatValue)"
    }
    init(string_I: String) {
        stringValue = string_I
    }
}


class RowColumnBase {
    
    var dataPoints : [DataPoint] = []
    
    var floatArray : [Float] {
        get {
            return makeFloatArray()
        } set {
            dataPoints = addFloatArray(floatArray)
        }
    }
    
    var stringArray : [String] {
        get {
            return makeStringArray()
        } set {
            dataPoints = addStringArray(stringArray)
        }
    }
    
    init() {
        
    }
    
    init(floatArray:[Float]) {
        
        self.dataPoints = addFloatArray(floatArray)
        
    }
    
    init(stringArray:[String]) {
        
        self.dataPoints = addStringArray(stringArray)
        
    }
    
    private func makeStringArray() -> [String] {
        
        return dataPoints.map {$0.stringValue}
        
    }
    
    private func addStringArray(array: [String]) -> [DataPoint] {
        
        let tempDataPoints = array.map { DataPoint(string_I: $0) }
        return tempDataPoints
    }
    
    private func makeFloatArray() -> [Float] {
        
        return dataPoints.map {$0.floatValue}
        
    }
    
    private func addFloatArray(array: [Float]) -> [DataPoint] {
        
        let tempDataPoints = array.map { DataPoint(float_I: $0) }
        return tempDataPoints
    }
    
    func clear() {
        
        dataPoints = []
        
    }
}

class DataRow : RowColumnBase {
    
    var cluster : Int = 0
    var distance : Float = 0
    
    override init() {
        super.init()
    }
    
    override init(floatArray: [Float]) {
        super.init(floatArray: floatArray)
    }
    
    override init(stringArray: [String]) {
        super.init(stringArray: stringArray)
    }
    
}

class DataColumn : RowColumnBase {
    
    
    override init() {
        
        super.init()
    }
    
    override init(floatArray: [Float]) {
        super.init(floatArray: floatArray)
    }
    
    override init(stringArray: [String]) {
        super.init(stringArray: stringArray)
    }
    
}