//
//  PreferenceManager.swift
//  GPSLogger
//
//  Created by Yu on 2021/09/02.
//

import Foundation
import SwiftUI

class PreferenceManager: NSObject, ObservableObject {
    // Status
    @Published var currentLatitude: Double = 0
    @Published var currentLongitude: Double = 0
    
    @Published var isDebugMode: Bool = false
    @Published var isLogging: Bool = true
    
    // View
    @Published var isPreferenceViewOpened: Bool = false
    
    // // Setting items
    // @Published var profileImageUrlHttps: String = ""
    // @Published var locatingIntervalMeters: Int = 5 // (unit: m)
    // @Published var locatingIntervalMilliseconds: Int = 10 * 1000
    // @Published var locatingError: Double = 0.001
    // @Published var weatherForecastBaseUrl: String = ""

}
