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
    
    @State private var homeAreaLatitude = ""
    @State private var homeAreaLongitude = ""
    @State private var homeAreaRadius = ""
    
    @State private var consumerKey = ""
    @State private var consumerSecret = ""
    @State private var accessKey = ""
    @State private var accessSecret = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Debug mode")) {
                    Toggle(isOn: $preferenceManager.isDebugMode) {
                        Text("Enable debug mode")
                    }
                }
                
                Section(header: Text("Home area")) {
                    TextField("Latitude", text: $homeAreaLatitude).keyboardType(.decimalPad)
                    TextField("Longitude", text: $homeAreaLongitude).keyboardType(.decimalPad)
                    TextField("Radius", text: $homeAreaRadius).keyboardType(.decimalPad)
                }
                
                Section(header: Text("Twitter")) {
                    TextField("Consumer key", text: $consumerKey).autocapitalization(.none)
                    TextField("Consumer Secret", text: $consumerSecret).autocapitalization(.none)
                    TextField("Access key", text: $accessKey).autocapitalization(.none)
                    TextField("Access Secret", text: $accessSecret).autocapitalization(.none)
                }
                
                Section(header: Text("Save")) {
                    Button(action: {
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
                        
                        UserDefaults.standard.set(consumerKey, forKey: "consumerKey")
                        UserDefaults.standard.set(consumerSecret, forKey: "consumerSecret")
                        UserDefaults.standard.set(accessKey, forKey: "accessKey")
                        UserDefaults.standard.set(accessSecret, forKey: "accessSecret")
                        
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
                homeAreaLatitude = String(UserDefaults.standard.double(forKey: "homeAreaLatitude"))
                homeAreaLongitude = String(UserDefaults.standard.double(forKey: "homeAreaLongitude"))
                homeAreaRadius = String(UserDefaults.standard.double(forKey: "homeAreaRadius"))
                
                consumerKey = UserDefaults.standard.string(forKey: "consumerKey") ?? ""
                consumerSecret = UserDefaults.standard.string(forKey: "consumerSecret") ?? ""
                accessKey = UserDefaults.standard.string(forKey: "accessKey") ?? ""
                accessSecret = UserDefaults.standard.string(forKey: "accessSecret") ?? ""
            })
        }
    }
}

struct PreferenceView_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceView().environmentObject(PreferenceManager())
    }
}
