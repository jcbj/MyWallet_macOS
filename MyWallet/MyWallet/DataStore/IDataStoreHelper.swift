//
//  IDataStoreHelper.swift
//  MyWallet
//
//  Created by jiangchao on 18/10/2016.
//  Copyright © 2016 jiangchao. All rights reserved.
//

import Foundation

protocol IDataStoreHelper {
 
    func initDataStore() -> Bool
    
    func register(name: String, password: String, email: String) -> Bool    
    func login(name: String, password: String) -> Bool
    func logout()
    
}
