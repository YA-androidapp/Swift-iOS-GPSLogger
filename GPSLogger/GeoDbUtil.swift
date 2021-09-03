//
//  GeoDbUtil.swift
//  GPSLogger
//
//  Created by Yu on 2021/09/04.
//

import Foundation
import SwiftUI

class GeoDbUtil {
    private static let DB_FILE_NAME = "database.db"
    
    static func getDatabaseFilePath() -> String{
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent(DB_FILE_NAME)
        
        if fileManager.fileExists(atPath: url.path) {
            return url.path
        }
        else{
            return ""
        }
    }
    
}
