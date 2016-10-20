//
//  SQLite3Helper.swift
//  MyWallet
//
//  Created by jiangchao on 18/10/2016.
//  Copyright © 2016 jiangchao. All rights reserved.
//

import Foundation

class SQLite3Helper: IDataStoreHelper {
    
    //MARK: - Init / Singleton
    private init() {
        
    }
    
    public static let instance = SQLite3Helper()
    
    //MARK: - Static Field
    static let USERIDTABLENAME = "UserIDTN"
    static let USERIDTABLECOLUMNNAME = ["ID","Name","Password","Email"]
    
    //MARK: - Private Field
    var mCurrentLoginUserName: String?
    
    
    
    //MARK: - Operate DB
    var db: OpaquePointer?
    
    func initDataStore() -> Bool {
        
        var result = false
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        guard let dbPathBase = Utility.instance.combinePath(path[0], "SqliteDB"),
                let dbPath = Utility.instance.combinePath(dbPathBase, "Wallet.db")
        else {
            JCLogger.log(level: .Alert, "combinePath is nil.")
            return result
        }
        
        if !Utility.instance.createDirectory(atPath: dbPathBase, withIntermediateDirectories: true, attributes: [String : Any]()) {
            JCLogger.log(level: .Error, "Create Directory is failed: \(dbPathBase) ")
            return false
        }
        
        JCLogger.log(level: .Info, "DBPath: \(dbPath)")
        
        //If the DB file does not exists, create a new file and open it.
        //If the DB file already exists, open it
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            JCLogger.log(level: .Info, "Open DB is success.")
            
            result = self.createUserIDTable()
        } else {
            
            JCLogger.log(level: .Info, "Open DB is failed.")
        }
        
        return result
    }
    
    func execSQL(_ sql: String) -> Int32 {
        return Int32(sqlite3_exec(self.db, sql, nil, nil, nil))
    }
    
    func checkIsExist(_ sql: String) -> Bool {
        
        var statement: OpaquePointer?
        
        sqlite3_prepare_v2(self.db, sql, -1, &statement, nil)
        
        while sqlite3_step(statement) == SQLITE_ROW {
            
            return true
        }
        
        return false
    }

    //MARK: UserIDTable
    func createUserIDTable() -> Bool {
        let sql = "CREATE TABLE IF NOT EXISTS \(SQLite3Helper.USERIDTABLENAME) (\(SQLite3Helper.USERIDTABLECOLUMNNAME[0]) INTEGER PRIMARY KEY AUTOINCREMENT, \(SQLite3Helper.USERIDTABLECOLUMNNAME[1]) TEXT, \(SQLite3Helper.USERIDTABLECOLUMNNAME[2]) TEXT, \(SQLite3Helper.USERIDTABLECOLUMNNAME[3]) TEXT)"
        
        let result = self.execSQL(sql)
        
        if result == SQLITE_OK {
            return true
        }
        
        JCLogger.log(level: .Error, "Create \(SQLite3Helper.USERIDTABLENAME) is failed, SQLiteErrorCode:\(result)")
        
        return false
    }
    
    func register(name: String, password: String, email: String) -> Bool {
        
        var sql = "SELECT * FROM \(SQLite3Helper.USERIDTABLENAME) WHERE \(SQLite3Helper.USERIDTABLECOLUMNNAME[1]) = '\(name)'"
        
        var result = self.checkIsExist(sql)
        
        if result {
            JCLogger.log(level: .Info, "User name already exists: \(name)")
            
            return false
        }
        
        sql = "INSERT INTO \(SQLite3Helper.USERIDTABLENAME) (\(SQLite3Helper.USERIDTABLECOLUMNNAME[1]),\(SQLite3Helper.USERIDTABLECOLUMNNAME[2]),\(SQLite3Helper.USERIDTABLECOLUMNNAME[3])) VALUES('\(name)','\(password)','\(email)')"
        
        let code = self.execSQL(sql)
        
        if code == SQLITE_OK {
            result = true
        } else {
            JCLogger.log(level: .Error, "Insert to db failed(\(code)): '\(name)','\(password)','\(email)'")
            result = false
        }
        
        return result
    }
    
    func login(name: String, password: String) -> Bool {
        let sql = "SELECT * FROM \(SQLite3Helper.USERIDTABLENAME) WHERE \(SQLite3Helper.USERIDTABLECOLUMNNAME[1]) = '\(name)' AND \(SQLite3Helper.USERIDTABLECOLUMNNAME[2]) = '\(password)'"
        
        let result = self.checkIsExist(sql)
        
        if result {
            self.mCurrentLoginUserName = name
        } else {
            JCLogger.log(level: .Info, "Logon failure: name = \(name) and password: \(password)")
        }
        
        return result
    }
    
    func logout() {
        self.mCurrentLoginUserName = nil
    }
    
    
    
    deinit {
        if (self.db != nil) {
            sqlite3_close_v2(self.db)
        }
    }
}

/*
 1 #define SQLITE_OK           0   /* 成功 | Successful result */
 2 /* 错误码开始 */
 3 #define SQLITE_ERROR        1   /* SQL错误 或 丢失数据库 | SQL error or missing database */
 4 #define SQLITE_INTERNAL     2   /* SQLite 内部逻辑错误 | Internal logic error in SQLite */
 5 #define SQLITE_PERM         3   /* 拒绝访问 | Access permission denied */
 6 #define SQLITE_ABORT        4   /* 回调函数请求取消操作 | Callback routine requested an abort */
 7 #define SQLITE_BUSY         5   /* 数据库文件被锁定 | The database file is locked */
 8 #define SQLITE_LOCKED       6   /* 数据库中的一个表被锁定 | A table in the database is locked */
 9 #define SQLITE_NOMEM        7   /* 某次 malloc() 函数调用失败 | A malloc() failed */
 10 #define SQLITE_READONLY     8   /* 尝试写入一个只读数据库 | Attempt to write a readonly database */
 11 #define SQLITE_INTERRUPT    9   /* 操作被 sqlite3_interupt() 函数中断 | Operation terminated by sqlite3_interrupt() */
 12 #define SQLITE_IOERR       10   /* 发生某些磁盘 I/O 错误 | Some kind of disk I/O error occurred */
 13 #define SQLITE_CORRUPT     11   /* 数据库磁盘映像不正确 | The database disk image is malformed */
 14 #define SQLITE_NOTFOUND    12   /* sqlite3_file_control() 中出现未知操作数 | Unknown opcode in sqlite3_file_control() */
 15 #define SQLITE_FULL        13   /* 因为数据库满导致插入失败 | Insertion failed because database is full */
 16 #define SQLITE_CANTOPEN    14   /* 无法打开数据库文件 | Unable to open the database file */
 17 #define SQLITE_PROTOCOL    15   /* 数据库锁定协议错误 | Database lock protocol error */
 18 #define SQLITE_EMPTY       16   /* 数据库为空 | Database is empty */
 19 #define SQLITE_SCHEMA      17   /* 数据结构发生改变 | The database schema changed */
 20 #define SQLITE_TOOBIG      18   /* 字符串或二进制数据超过大小限制 | String or BLOB exceeds size limit */
 21 #define SQLITE_CONSTRAINT  19   /* 由于约束违例而取消 | Abort due to constraint violation */
 22 #define SQLITE_MISMATCH    20   /* 数据类型不匹配 | Data type mismatch */
 23 #define SQLITE_MISUSE      21   /* 不正确的库使用 | Library used incorrectly */
 24 #define SQLITE_NOLFS       22   /* 使用了操作系统不支持的功能 | Uses OS features not supported on host */
 25 #define SQLITE_AUTH        23   /* 授权失败 | Authorization denied */
 26 #define SQLITE_FORMAT      24   /* 附加数据库格式错误 | Auxiliary database format error */
 27 #define SQLITE_RANGE       25   /* 传递给sqlite3_bind()的第二个参数超出范围 | 2nd parameter to sqlite3_bind out of range */
 28 #define SQLITE_NOTADB      26   /* 被打开的文件不是一个数据库文件 | File opened that is not a database file */
 29 #define SQLITE_ROW         100  /* sqlite3_step() 已经产生一个行结果 | sqlite3_step() has another row ready */
 30 #define SQLITE_DONE        101  /* sqlite3_step() 完成执行操作 | sqlite3_step() has finished executing */
 */
