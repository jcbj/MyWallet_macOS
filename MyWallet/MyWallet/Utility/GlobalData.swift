//
//  GlobalData.swift
//  MyWallet
//
//  Created by jiangchao on 18/10/2016.
//  Copyright © 2016 jiangchao. All rights reserved.
//

import Foundation

final class GlobalData {
    
    private init() {
        
    }
    
    static let Instance: GlobalData = { () -> GlobalData in
        return GlobalData()
    }()
    
}
