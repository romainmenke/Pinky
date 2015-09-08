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

protocol RowColumnProtocol {
    
    func makeFloatArray() -> [Float]
    
    func addFloatArray(array: [Float]) -> [DataPoint]
    
}

class RowColumnBase : RowColumnProtocol {
    
    var dataPoints : [DataPoint] = []
    
    var floatArray : [Float] {
        get {
            return makeFloatArray()
        } set {
            dataPoints = addFloatArray(floatArray)
        }
    }
    
    init() {
        
    }
    
    init(floatArray:[Float]) {
        
        self.dataPoints = addFloatArray(floatArray)
        
    }
    
    internal func makeFloatArray() -> [Float] {
        
        return dataPoints.map {$0.floatValue}
        
    }
    
    internal func addFloatArray(array: [Float]) -> [DataPoint] {
        
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
    
}

class DataColumn : RowColumnBase {
    
    
    override init() {
        
        super.init()
    }
    
    override init(floatArray: [Float]) {
        
        super.init(floatArray: floatArray)
    }
    
}