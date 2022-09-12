//
//  PreferenceView.swift
//  GPSLogger
//
//  Created by Yu on 2021/09/02.
//

import SwiftUI

struct PreferenceView: View {
    //モーダル表示
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var preferenceManager: PreferenceManager
    
    // @State private var currentLatitude: Double = 0
    // @State private var currentLongitude: Double = 0
    // @State private var locatingError: Double = 0.001
    
    @State private var isDebugMode = false
    @State private var homeAreaLatitude = ""
    @State private var homeAreaLongitude = ""
    @State private var homeAreaRadius = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Debug mode")) {
                    Toggle(isOn: $isDebugMode) {
                        Text("Enable debug mode")
                    }
                }
                
                Section(header: Text("Home area")) {
                    TextField("Latitude", text: $homeAreaLatitude).keyboardType(.decimalPad)
                    TextField("Longitude", text: $homeAreaLongitude).keyboardType(.decimalPad)
                    TextField("Radius", text: $homeAreaRadius).keyboardType(.decimalPad)
                }
                
                Section(header: Text("Save")) {
                    Button(action: {
                        UserDefaults.standard.set(self.isDebugMode, forKey: "isDebugMode")
                        
                        if let latitudeValue = Double(self.homeAreaLatitude){
                            if -90 <= latitudeValue && latitudeValue <= 90{
                                UserDefaults.standard.set(latitudeValue, forKey: "homeAreaLatitude")
                            }
                            else{
                                UserDefaults.standard.set(-91.0, forKey: "homeAreaLatitude")
                            }
                        }
                        else{
                            UserDefaults.standard.set(-91.0, forKey: "homeAreaLatitude")
                        }
                        
                        if let longitudeValue = Double(self.homeAreaLongitude){
                            if -180 <= longitudeValue && longitudeValue <= 180{
                                UserDefaults.standard.set(longitudeValue, forKey: "homeAreaLongitude")
                            }
                            else{
                                UserDefaults.standard.set(-181.0, forKey: "homeAreaLongitude")
                            }
                        }
                        else{
                            UserDefaults.standard.set(-181.0, forKey: "homeAreaLongitude")
                        }
                        
                        if let radiusValue = Double(self.homeAreaRadius){
                            if 0 <= radiusValue{
                                UserDefaults.standard.set(radiusValue, forKey: "homeAreaRadius")
                                
                            }
                            else{
                                UserDefaults.standard.set(-1.0, forKey: "homeAreaRadius")
                            }
                        }
                        else{
                            UserDefaults.standard.set(-1.0, forKey: "homeAreaRadius")
                        }
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("Done")
                            Image(systemName: "checkmark.circle")
                            Spacer()
                        }
                    }
                }
            }.onAppear(perform: {
                isDebugMode = UserDefaults.standard.bool(forKey: "isDebugMode")
                
                homeAreaLatitude = String(UserDefaults.standard.double(forKey: "homeAreaLatitude"))
                homeAreaLongitude = String(UserDefaults.standard.double(forKey: "homeAreaLongitude"))
                homeAreaRadius = String(UserDefaults.standard.double(forKey: "homeAreaRadius"))
            })
        }
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView().environmentObject(PreferenceManager())
    }
}
