//
//  ContentView.swift
//  GPSLogger
//
//  Created by Yu on 2021/08/27.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @EnvironmentObject var preferenceManager: PreferenceManager
    
    @State private var exportedFilename = ""
    @State private var isExportAlertShowed = false
    @State private var logs = ""
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    private func log(fil: String, lin: Int, clm: Int, cls: String, fun: String, key: String, val: String){
        if UserDefaults.standard.bool(forKey: "isDebugMode")  {
            DebugUtil.log(fil: fil, lin: lin,clm: clm,cls: cls, fun: fun, key: key, val: val)
        }
    }
    
    private func notify(title: String, message: String){
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]){
            (granted, _) in
            print("granted: " + String(granted))
            if granted {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = message
                content.sound = UNNotificationSound.default
                
                let request = UNNotificationRequest(identifier: "gpsloggernotification", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
            }
        }
        
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
    }
    
    var body: some View {
        VStack {
            if UserDefaults.standard.bool(forKey: "isDebugMode") {
                Text("Debug mode is enabled!").foregroundColor(Color.red)
            }
            HStack {
                Text(" Logs:")
                Spacer()
            }
            MapViewWrapper()
            ScrollView(.vertical, showsIndicators: true) {
                Text(logs)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 8))
                    .onReceive(timer, perform: { time in
                        if UserDefaults.standard.object(forKey: "logs") != nil {
                            logs = (UserDefaults.standard.object(forKey: "logs") as! [String]).joined(separator: "\n")
                        }
                    })
            }
            .frame(maxWidth: .infinity, maxHeight: 360.0)
            .background(Color.white)
            
            .padding()
            HStack{
                VStack{
                    Text("Locating").font(.footnote)
                    HStack {
                        // Start
                        Image(systemName: "play.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                                appDelegate?.startLocating()
                                UserDefaults.standard.set(true, forKey: "isLogging")
                            }
                            .opacity(UserDefaults.standard.bool(forKey: "isLogging") ? 0 : 1)
                        
                        // Stop
                        Image(systemName: "stop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                                appDelegate?.stopLocating()
                                UserDefaults.standard.set(false, forKey: "isLogging")
                            }
                            .opacity(UserDefaults.standard.bool(forKey: "isLogging") ? 1 : 0)
                    }
                }
                VStack{
                    Text("Logs").font(.footnote)
                    HStack {
                        // Clear
                        Image(systemName: "xmark.bin.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                                appDelegate?.removeLogs()
                                logs = ""
                            }
                        
                        // Reload
                        Image(systemName: "repeat.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                if UserDefaults.standard.object(forKey: "logs") != nil {
                                    logs = (UserDefaults.standard.object(forKey: "logs") as! [String]).joined(separator: "\n")
                                }
                            }
                        
                        // Export
                        Image(systemName: "doc.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                if UserDefaults.standard.object(forKey: "logs") != nil {
                                    logs = (UserDefaults.standard.object(forKey: "logs") as! [String]).joined(separator: "\n")
                                    exportedFilename = FileUtil.write(filename: FileUtil.getFilename(prefix: "export_", ext: ".txt"), content: logs)
                                    
                                    self.isExportAlertShowed = true
                                }
                            }
                            .alert(isPresented: $isExportAlertShowed) {
                                Alert(title: Text("Exported"), message: Text("ファイル " + exportedFilename + " にエクスポートしました。"))
                            }
                    }
                    
                }
                VStack{
                    Text("Settings").font(.footnote)
                    OpenPreferenceButtonView()
                        .sheet(isPresented: $preferenceManager.isPreferenceViewOpened) {
                            PreferenceView()
                                .environmentObject(preferenceManager)
                        }
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(PreferenceManager())
        }
    }
}
