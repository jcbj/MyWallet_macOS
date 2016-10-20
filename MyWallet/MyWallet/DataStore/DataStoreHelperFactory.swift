//
//  DataStoreHelperFactory.swift
//  MyWallet
//
//  Created by jiangchao on 18/10/2016.
//  Copyright © 2016 jiangchao. All rights reserved.
//

import Foundation

enum DataStoreType {
    case Default
    case SQLite3
}

class DataStoreHelperFactory {

    static func createDataStoreHelper(type: DataStoreType) -> IDataStoreHelper {
        switch type {
        case .SQLite3:
            return SQLite3Helper.instance
        default:
            return SQLite3Helper.instance
        }
    }
}
