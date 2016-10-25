//
//  MainTabViewController.swift
//  MyWallet
//
//  Created by jiangchao on 21/10/2016.
//  Copyright © 2016 jiangchao. All rights reserved.
//

import Cocoa

class MainTabViewController: NSTabViewController {

    deinit {
        obj?.pointee = NSArray()
    }
    
    var topLevelArray = NSArray()
    var obj: AutoreleasingUnsafeMutablePointer<NSArray>?
    
    lazy var loginPanel: LoginPanel? = {
        var panel: LoginPanel?
        let nib = NSNib.init(nibNamed: "LoginPanel", bundle: Bundle.main)
        self.obj = AutoreleasingUnsafeMutablePointer<NSArray>(&(self.topLevelArray))
        
        if let success = nib?.instantiate(withOwner: self, topLevelObjects: self.obj) {
            if success {
                for obj in self.topLevelArray {
                    if obj is LoginPanel {
                        panel = obj as? LoginPanel
                        break
                    }
                }
            }
        }
        
        return panel
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do view setup here.
    
        let success = GlobalData.instance.dataStoreHelper.initDataStore()
        if !success {
            JCLogger.log(level: .Error, "DataStore is open failed.")
            exit(0)
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.loginPanel?.parent = self.view.window
        self.view.window?.beginSheet(self.loginPanel!, completionHandler: { returnCode in
            print("returnCode = \(returnCode)")
        })
    }
    
}
