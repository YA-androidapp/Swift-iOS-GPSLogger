//
//  FileUtil.swift
//  GPSLogger
//
//  Created by Yu on 2021/08/31.
//

import Foundation

class FileUtil{
    private static func log(fil: String, lin: Int, clm: Int, cls: String, fun: String, key: String, val: String){
        DebugUtil.log(fil: fil, lin: lin,clm: clm,cls: cls, fun: fun, key: key, val: val)
    }
    
    static func getFilename(prefix: String, ext: String) -> String {
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let now = Date()
        
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: prefix + formatter.string(from: now) + ext)
        
        return prefix + formatter.string(from: now) + ext
    }
    
    static func write(filename: String, content: String) -> String{
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        
        let dir = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!
        let fileUrl = dir.appendingPathComponent(filename)

        var result = ""
        do {
            try content.write(to: fileUrl, atomically: false, encoding: .utf8)
            result = filename
        } catch {
            print("Error: \(error)")
        }
        
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: result)
        
        return result
    }
}
