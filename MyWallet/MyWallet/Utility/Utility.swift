//
//  Utility.swift
//  MyWallet
//
//  Created by jiangchao on 18/10/2016.
//  Copyright © 2016 jiangchao. All rights reserved.
//

import Foundation

final class Utility {
    
    //Singleton - Lazy Load
    static var instance: Utility {
        struct LazyUtility {
            static let sharedInstance = Utility()
        }
        
        return LazyUtility.sharedInstance
    }
    
    private init() {
        
    }
    
    /*
     applicationDirectory : /Users/jc/Applications
     */
    func getSystemPath(_ directory: FileManager.SearchPathDirectory) -> String {
        
        let documentPaths = NSSearchPathForDirectoriesInDomains(directory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        return documentPaths[0]
    }
    
    func combinePath(_ first: String, _ second: String) -> String? {
        
        if second.hasPrefix("/") {
            return first + second
        }
        
        return first + "/" + second
    }
    
    func createDirectory(atPath: String, withIntermediateDirectories: Bool, attributes: [String : Any]) -> Bool {
        
        var result = true
        
        let fileManager = FileManager()
//        if fileManager.fileExists(atPath: atPath, isDirectory: UnsafeMutablePointer<ObjCBool>?)
        do {
            try fileManager.createDirectory(atPath: atPath, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes)
        } catch {
            result = false
        }
        
        return result
    }
}
