//
//  DataSetClasses.swift
//  Pinky
//
//  Created by Romain Menke on 08/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import Foundation


enum DerivedDataType : Int {
    
    case Value = 0
    case Average = 1
    case Min = 2
    case Max = 3
    case Trend = 4
    
}

class DataSetBase {
    
    var headers : [String] = []
    var rows : [DataRow] = []
    var columns : [DataColumn] = []
    
    init() {
        
    }
    
    init(dataRows_I: [DataRow], headers_I: [String], completion: (finished: Bool) -> Void) {
        
        headers = headers_I
        
        rows = dataRows_I.map { DataRow(floatArray: $0.floatArray) }
        
        buildColumns { (finished) -> Void in
            completion(finished: true)
        }

    }
    
    init(dataRowsWithStrings_I: [DataRow], headers_I: [String], completion: (finished: Bool) -> Void) {
        
        headers = headers_I
        
        rows = dataRowsWithStrings_I.map { DataRow(stringArray: $0.stringArray)}
        
        buildColumns { (finished) -> Void in
            completion(finished: true)
        }

    }
    
    func buildColumns(completion: (finished: Bool) -> Void) {
        
        columns = []
        
        if rows[0].dataPoints.count == 0 {
            print("oops")
        }
        
        for iA in 0..<rows[0].dataPoints.count {
            let column = DataColumn()
            column.dataPoints = rows.map { $0.dataPoints[iA] }
            columns.append(column)
            
            if iA == (rows[0].dataPoints.count - 1) {
                completion(finished: true)
            }
        }
    }
    
    func buildRows(completion: (finished: Bool) -> Void) {
        
        rows = []
        
        for iA in 0..<columns[0].dataPoints.count {
            let row = DataRow()
            row.dataPoints = columns.map { $0.dataPoints[iA] }
            rows.append(row)
            
            if iA == (columns[0].dataPoints.count - 1) {
                completion(finished: true)
            }
        }
    }
    
}

class DataSet : DataSetBase {
    
    var inputs : [Int] = []
    var outputs : [Int] = []
    
    var delegate : DataSetDelegate?
    
    var columnCounter : Int = 0
    
    override init() {
        super.init()
    }
    
    
    override init(dataRows_I: [DataRow], headers_I: [String], completion: (finished: Bool) -> Void) {
        super.init(dataRows_I: dataRows_I, headers_I: headers_I) { (finished) -> Void in
            completion(finished: true)
        }
    }
    
    override init(dataRowsWithStrings_I: [DataRow], headers_I: [String], completion: (finished: Bool) -> Void) {
        super.init(dataRowsWithStrings_I: dataRowsWithStrings_I, headers_I: headers_I) { (finished) -> Void in
            completion(finished: true)
        }
    }
}


private class DataSubSet : DataSetBase {
    
    var types : [DerivedDataType] = []
    
    override init() {
        super.init()
    }
    
    override init(dataRows_I: [DataRow], headers_I: [String], completion: (finished: Bool) -> Void) {
        super.init(dataRows_I: dataRows_I, headers_I: headers_I) { (finished) -> Void in
            completion(finished: true)
        }
    }
    
    override init(dataRowsWithStrings_I: [DataRow], headers_I: [String], completion: (finished: Bool) -> Void) {
        super.init(dataRowsWithStrings_I: dataRowsWithStrings_I, headers_I: headers_I) { (finished) -> Void in
            completion(finished: true)
        }
    }
    
    func filterByDerivedDataType(types_I: [DerivedDataType]) -> [DataColumn] {
        
        var filteredColumns : [DataColumn] = []
        
        for iC in 0..<types.count {
            
            for iT in 0..<types_I.count {
                
                if types[iC] == types_I[iT] {
                    
                    filteredColumns.append(columns[iC])
                    
                }
            }
        }
        
        return filteredColumns
        
    }
}

class DataSuperSet {
    
    private var subSets : [DataSubSet] = []
    var locationFlags : [Int] = []
    
    var masterSet : DataSet = DataSet()
    
    init() {
        
    }
    
    func getRow(index: Int) -> DataRow {
        let row = DataRow()
        for i in 0..<subSets.count {
            row.dataPoints += subSets[i].rows[index].dataPoints
        }
        return row
    }
    
    func concatenateLocationColumns() {
        
        var tempDictOfSets = [Int: DataSubSet]()
        let locationSet = DataSubSet()
        
        for i in 0..<subSets.count {
            
            tempDictOfSets[i] = subSets[i]
            
        }
        
        for i in 0..<locationFlags.count {
            
            if i == 0 {
                locationSet.rows = subSets[locationFlags[i]].rows
            }
            
            for row in 0..<subSets[locationFlags[i]].rows.count {
                
                locationSet.rows[row].dataPoints[0].stringValue += ", " + subSets[locationFlags[i]].rows[row].dataPoints[0].stringValue
                
            }
            tempDictOfSets.removeValueForKey(locationFlags[i])
        }
        
        var setArray : [DataSubSet] = []
        for set in tempDictOfSets.values {
            setArray.append(set)
        }

        subSets = setArray
        
    }
    
    func setMasterSet(set_I: DataSet, completion: (finished: Bool) -> Void) {
        
        for i in 0..<set_I.columns.count {
            
            let newSet = DataSubSet()
            let stringArray = set_I.columns[i].stringArray
            let newColumn = DataColumn(stringArray: stringArray)
            
            newSet.columns.append(newColumn)
            newSet.buildRows({ (finished) -> Void in
                
                self.subSets.append(newSet)
                if i == (set_I.columns.count - 1) {
                    completion(finished: true)
                }
            })
            
        }
        
    }
    
    func getMasterSet(completion: (finished: Bool) -> Void) {
        
        let set = DataSet()
        
        for iS in 0..<subSets.count {
            
            set.columns += subSets[iS].columns
            set.headers += subSets[iS].headers
            
        }
        
        set.buildRows { (finished) -> Void in
            self.masterSet = set
            completion(finished: true)
        }
        
    }
    
}

protocol DataSetDelegate {
    
    func dataSetIsBuild()
    
}


