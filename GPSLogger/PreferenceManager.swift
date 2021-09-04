//
//  PreferenceManager.swift
//  GPSLogger
//
//  Created by Yu on 2021/09/02.
//

import Foundation
import SwiftUI

class PreferenceManager: NSObject, ObservableObject {
    @Published var isPreferenceViewOpened: Bool = false
}
