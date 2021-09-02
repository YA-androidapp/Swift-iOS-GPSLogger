//
//  OpenPreferenceButtonView.swift
//  GPSLogger
//
//  Created by Yu on 2021/09/02.
//

import Foundation

import SwiftUI

struct OpenPreferenceButtonView: View {
    @EnvironmentObject var preferenceManager: PreferenceManager
    
    var body: some View {
        Image(systemName: "ellipsis.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 32, height: 32)
            .onTapGesture {
                self.preferenceManager.isPreferenceViewOpened = true
            }
    }
}

struct OpenPreferenceButtonView_Previews: PreviewProvider {
    static var previews: some View {
        OpenPreferenceButtonView()
            .environmentObject(PreferenceManager())
            .previewLayout(.sizeThatFits)
    }
}
