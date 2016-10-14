//
//  JCLogger.swift
//  MyWallet
//
//  Created by jiangchao on 14/10/2016.
//  Copyright © 2016 jiangchao. All rights reserved.
//

import Foundation

struct LogLevel: OptionSet {
    let rawValue: Int
    
    static let Info = LogLevel(rawValue: 1 << 0)
    static let Alert = LogLevel(rawValue: 1 << 1)
    static let Error = LogLevel(rawValue: 1 << 2)
    static let Debug = LogLevel(rawValue: 1 << 3)
    static let All: LogLevel = [.Info, .Alert, .Error, .Debug]
}

struct FileOutputStream: TextOutputStream {
    lazy var fileHandle: FileHandle? = {
        let fileHandle = FileHandle(forWritingAtPath: self.logPath)
        return fileHandle
    }()
    
    lazy var logPath: String = {
        let filePath = Bundle.main.bundlePath + "/log.txt"
        
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        
        print(filePath)
        
        return filePath
        
    }()
    
    mutating func write(_ string: String) {
        print(fileHandle)
        fileHandle?.seekToEndOfFile()
        fileHandle?.write(string.data(using: String.Encoding.utf8)!)
    }
}

struct StdOutputStream: TextOutputStream {
    
    mutating func write(_ string: String) {
        fputs(string, __stdoutp)
    }
}

struct StringOutputStream: TextOutputStream {
    var out = ""
    
    mutating func write(_ string: String) {
        out += string
    }
    
    mutating func reset() {
        out = ""
    }
}

let gDefaultDateFormatter = { () -> DateFormatter in
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    return dateFormatter
}()

class JCLogger {
    static var level: LogLevel = .All
    
    static var outStream = FileOutputStream() //StdOutputStream()
    
    static var includeCaller = false
    
    static var defaultDateFormatter: DateFormatter {
        get {
            return gDefaultDateFormatter
        }
    }
    
    static var dateFormatter = defaultDateFormatter
    
    static func _log(level: LogLevel, _ items: [Any], separator: String = " ", terminator: String = "\n", _ file: String = #file, _ line: Int = #line, _ function: String = #function)
    {
        guard self.level.contains(level) else {
            return
        }
        
        var bIsDebug = false
        
        #if DEBUG
            
            bIsDebug = true
            
        #endif
        
        if level == .Debug && !bIsDebug {
            return
        }
        
        var info = ""
        switch level {
        case LogLevel.Info:
            info = "[INFO]"
        case LogLevel.Alert:
            info = "[Alert]"
        case LogLevel.Error:
            info = "[Error]"
        case LogLevel.Debug:
            info = "[Debug]"
        default:
            break
        }
        
        var stream = StringOutputStream()
        info += separator + dateFormatter.string(from: Date()) + separator
        
        if includeCaller {
            info += file + ":\(line):" + function + separator
        }
        
        var i = 1
        let len = items.count
        for item in items {
            debugPrint(item, to: &stream)
            info += stream.out
            stream.reset()
            if i == len {
                info += terminator
                break
            }
            info += separator
            i += 1
        }
        outStream.write(info)
    }
    
    static func log(level: LogLevel, _ items: Any ..., separator: String = " ", terminator: String = "\n", _ file: String = #file, _ line: Int = #line, _ function: String = #function)
    {
        _log(level: level, items, separator: separator, terminator: terminator, file, line, function)
    }
}

















