//
//  ViewController.swift
//  Pinky
//
//  Created by Romain Menke on 08/09/15.
//  Copyright © 2015 menke dev. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSOpenSavePanelDelegate {

    var csvReader : CSVReader?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func importCSV(sender: NSButton) {
        
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.allowedFileTypes = ["csv"]
        openPanel.delegate = self
        
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                let url = openPanel.URL!
                if url.pathExtension == "csv" {
                    
                    self.csvReader = CSVReader(path: url)
                    
                }
                
            }
        }
        
    }
    

}

