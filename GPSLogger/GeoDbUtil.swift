//
//  GeoDbUtil.swift
//  GPSLogger
//
//  Created by Yu on 2021/09/04.
//

import FMDB
import Foundation
import SwiftUI

class GeoDbUtil {
    private let DB_FILE_NAME = "database.db"
    private let  QUERY_SEARCH_CITY =  " SELECT * , ( abs ( ? - lat ) + abs ( ? - lon ) ) as d FROM towns ORDER BY d ASC LIMIT 1 ; "
    
    private var db = FMDatabase()
    
    init() {
        self.db = FMDatabase(path: getDatabaseFilePath())
    }
    
    private func log(fil: String, lin: Int, clm: Int, cls: String, fun: String, key: String, val: String){
        if UserDefaults.standard.bool(forKey: "isDebugMode")  {
            DebugUtil.log(fil: fil, lin: lin,clm: clm,cls: cls, fun: fun, key: key, val: val)
        }
    }
    
    func getDatabaseFilePath() -> String {
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        
        let fileManager = FileManager.default
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return ""
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent(DB_FILE_NAME)
        let documentsURL = Bundle.main.resourceURL?.appendingPathComponent(DB_FILE_NAME)
        
        do {
            try? fileManager.removeItem(at: finalDatabaseURL)
            try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
            return finalDatabaseURL.path
        } catch let error as NSError {
            log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "error", val: "\(error.description)")
        }
        
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "")
        
        return ""
    }
    
    func searchTown(currentLat: Double, currentLon: Double) -> String{
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        
        var searched = ""
        
        guard self.db.open() else {
            log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "error", val: "cannot open database")
            return searched
        }
        
        do {
            let rs = try db.executeQuery(QUERY_SEARCH_CITY, values: [currentLat, currentLon])
            while rs.next() {
                if let city = rs.string(forColumn: "city"), let town = rs.string(forColumn: "town") {
                    searched = "\(city)\(town)"
                }
            }
        } catch {
            log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "error", val: "\(error.localizedDescription)")
        }
        
        db.close()
        
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "\(searched)")
        return searched
    }
}
