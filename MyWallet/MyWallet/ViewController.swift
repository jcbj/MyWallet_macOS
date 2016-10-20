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
        
//        //Test Login Part DB
//        if GlobalData.instance.dataStoreHelper.initDataStore() {
//            
//            if GlobalData.instance.dataStoreHelper.register(name: "jc", password: "jc123", email: "jc@126.com") {
//                if GlobalData.instance.dataStoreHelper.login(name: "jc", password: "jc") {
//                    JCLogger.log(level: .Alert, "DB Failed.")
//                } else if GlobalData.instance.dataStoreHelper.login(name: "jc", password: "jc123") {
//                    GlobalData.instance.dataStoreHelper.logout()
//                }
//            }
//        }
        
        
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

