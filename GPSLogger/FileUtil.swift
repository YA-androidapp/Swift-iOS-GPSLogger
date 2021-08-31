//
//  FileUtil.swift
//  GPSLogger
//
//  Created by Yu on 2021/08/31.
//

import Foundation

class FileUtil{
    static func getFilename(prefix: String, ext: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let now = Date()
        
        return prefix + formatter.string(from: now) + ext
    }
    
    static func write(filename: String, content: String){
        let dir = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
        let fileUrl = dir.appendingPathComponent(filename)

        do {
            try content.write(to: fileUrl, atomically: false, encoding: .utf8)
        } catch {
            print("Error: \(error)")
        }
    }
}
