//
//  LoginPanel.swift
//  MyWallet
//
//  Created by jiangchao on 21/10/2016.
//  Copyright © 2016 jiangchao. All rights reserved.
//

import Cocoa

class LoginPanel: NSPanel {
    
    @IBOutlet weak var labelUserName: NSTextField!
    @IBOutlet weak var labelPassword: NSTextField!
    @IBOutlet weak var labelEmail: NSTextField!
    
    @IBOutlet weak var tfUserName: NSTextField!
    @IBOutlet weak var tfPassword: NSTextField!
    @IBOutlet weak var tfEmail: NSTextField!
    
    @IBOutlet weak var btnRegister: NSButton!
    @IBOutlet weak var btnLogin: NSButton!
    
    @IBOutlet weak var btnRCancel: NSButton!
    @IBOutlet weak var btnROk: NSButton!
    
    @IBAction func registerClick(_ sender: NSButton) {
        self.parent?.endSheet(self, returnCode: 1)
    }
    
    @IBAction func loginClick(_ sender: NSButton) {
        self.parent?.endSheet(self, returnCode: 0)
    }
    
    @IBAction func rCancelClick(_ sender: NSButton) {
        self.parent?.endSheet(self, returnCode: 0)
    }
    
    @IBAction func rOkClick(_ sender: NSButton) {
        self.parent?.endSheet(self, returnCode: 1)
    }
}
