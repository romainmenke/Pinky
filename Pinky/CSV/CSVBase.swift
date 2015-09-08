//
//  CSVArray.swift
//  WinterMute
//
//  Created by Romain Menke on 05/05/15.
//  Copyright (c) 2015 Menke Dev. All rights reserved.
//

import Foundation

class CSV {
    
    var dataSet : DataSuperSet = DataSuperSet()
    
    private var headerCount : Int = 0
    
    var delimiter = NSCharacterSet(charactersInString: ",")
    
    init(contentsOfURL url: NSURL, delimiter: NSCharacterSet) throws {
        let csvString: String?
        do {
            csvString = try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        } catch _ {
            csvString = nil
        };
        if let csvStringToParse = csvString {
            self.delimiter = delimiter
            
            let newline = NSCharacterSet.newlineCharacterSet()
            var lines: [String] = []
            csvStringToParse.stringByTrimmingCharactersInSet(newline).enumerateLines { line, stop in lines.append(line) }
            
            
            let tempSet = DataSet(dataRows_I: self.parseRows(fromLines: lines), headers_I: self.parseHeaders(fromLines: lines))

            self.dataSet.masterSet = tempSet
            
            
            
        }
    }
    
    convenience init(contentsOfURL url: NSURL) throws {
        let comma = NSCharacterSet(charactersInString: ",")
        try self.init(contentsOfURL: url, delimiter: comma)
    }
    
    private func parseHeaders(fromLines lines: [String]) -> [String] {
        let headers = lines[0].componentsSeparatedByCharactersInSet(self.delimiter)
        headerCount = headers.count
        return headers
    }
    
    
    private func parseRows(fromLines lines: [String]) -> [DataRow] {
        var rows: [DataRow] = []
        
        for (lineNumber, line) in lines.enumerate() {
            if lineNumber == 0 {
                continue
            }
            let row = DataRow()
            let values = line.componentsSeparatedByCharactersInSet(self.delimiter)
            for index in 0..<self.headerCount {
                let value = values[index]
                row.dataPoints.append(DataPoint(string_I: value))
            }
            rows.append(row)
        }
        
        return rows
    }
}