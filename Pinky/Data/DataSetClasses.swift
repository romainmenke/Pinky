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
    
    
    init(dataRows_I: [DataRow]) {
        
        rows = dataRows_I.map { DataRow(floatArray: $0.floatArray) }
        
        buildColumns()
        
    }
    
    func buildColumns() {
        
        columns = []
        
        for iA in 0..<rows[0].dataPoints.count {
            let column = DataColumn()
            column.dataPoints = rows.map { $0.dataPoints[iA] }
            columns.append(column)
        }
    }
    
    func buildRows() {
        
        rows = []
        
        for iA in 0..<columns[0].dataPoints.count {
            let row = DataRow()
            row.dataPoints = columns.map { $0.dataPoints[iA] }
            rows.append(row)
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
    
    
    init(dataRows_I: [DataRow], headers_I: [String]) {
        
        super.init()
        
        headers = headers_I
        
        rows = dataRows_I.map { DataRow(floatArray: $0.floatArray) }
        
        buildColumns()
        
    }
}


private class DataSubSet : DataSetBase {
    
    var types : [DerivedDataType] = []
    
    override init() {
        super.init()
    }
    
    
    init(dataColumn_I: DataColumn, header_I: String) {
        
        super.init()
        
        headers = [header_I]
        
        columns = [DataColumn(floatArray: dataColumn_I.floatArray)]
        
        buildRows()
        
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
    //var subSetCount : Int = 0
    
    var masterSet : DataSet {
        
        get {
            return createUniformSet()
        } set {
            //subSetCount = masterSet.columns.count
            subSets = []
            for i in 0..<masterSet.columns.count {
                let newSubSet = DataSubSet(dataColumn_I: masterSet.columns[i], header_I: masterSet.headers[i])
                subSets.append(newSubSet)
            }
        }
        
    }
    
    init() {
        
    }
    
    func getRow(index: Int) -> DataRow {
        let row = DataRow()
        for i in 0..<subSets.count {
            row.dataPoints += subSets[i].rows[index].dataPoints
        }
        return row
    }
    
    
    private func createUniformSet() -> DataSet {
        
        let set = DataSet()
        
        for iS in 0..<subSets.count {
            
            set.columns += subSets[iS].columns
            set.headers += subSets[iS].headers
            
        }
        
        set.buildRows()
        return set
        
    }
    
}

protocol DataSetDelegate {
    
    func dataSetIsBuild()
    
}


