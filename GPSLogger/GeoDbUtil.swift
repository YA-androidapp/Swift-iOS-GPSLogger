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
    
    func getDatabaseFilePath() -> String{
//        let fileManager = FileManager.default
//        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
//        let url = cacheDirectory.appendingPathComponent(DB_FILE_NAME)
//
//        if fileManager.fileExists(atPath: url.path) {
//            return url.path
//        }
//        else{
//            return ""
//        }
        return ""
    }
    
    func searchTown(currentLat: Double, currentLon: Double) -> String{
        var searched = ""
        
        guard self.db.open() else {
            print("Unable to open database")
            return searched
        }
        
        do {
            let rs = try db.executeQuery(QUERY_SEARCH_CITY, values: [currentLat, currentLon])
            while rs.next() {
                if let city = rs.string(forColumn: "city"), let town = rs.string(forColumn: "town") {
                    print("\(city)\(town)")
                    searched = "\(city)\(town)"
                }
            }
        } catch {
            print("failed: \(error.localizedDescription)")
        }

        db.close()
        
        return searched
    }
    
}
