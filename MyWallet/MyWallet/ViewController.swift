//
//  ViewController.swift
//  MyWallet
//
//  Created by jiangchao on 12/10/2016.
//  Copyright © 2016 jiangchao. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        //Test import SQLite3
//        var db:OpaquePointer?
//        let sqlitepath = Bundle.main.bundlePath + "/Wallet.db"
//        let state = sqlite3_open(sqlitepath, &db)
//        if state == SQLITE_OK {
//            JCLogger.log(level: .Info, "Open db is success.")
//        } else {
//            JCLogger.log(level: .Error, "Open db is failed.")
//        }
//        //*********************
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

