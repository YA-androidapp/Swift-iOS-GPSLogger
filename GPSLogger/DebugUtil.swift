//
//  DebugUtil.swift
//  GPSLogger
//
//  Created by Yu on 2021/09/04.
//

import Foundation
import SwiftUI

class DebugUtil{
    static let DATE_FORMAT = "yyyy/MM/dd HH:mm:ss"
    static var dateFormatter = DateFormatter()
    
    static func formatDateTimeString(date: Date) -> String {
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: DATE_FORMAT, options: 0, locale: Locale(identifier: "ja_JP"))
        return dateFormatter.string(from: date)
    }
    
    static func log(fil: String, lin: Int, clm: Int, cls: String, fun: String, key: String, val: String) {
        let date = Date()
        
        print(
            formatDateTimeString(date: date),
            fil,
            lin,
            clm,
            cls,
            fun,
            key,
            val
        )
    }
}
