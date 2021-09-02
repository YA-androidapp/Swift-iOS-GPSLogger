//
//  ContentView.swift
//  GPSLogger
//
//  Created by Yu on 2021/08/27.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var preferenceManager: PreferenceManager
    
    @State private var exportedFilename = ""
    @State private var isExportAlertShowed = false
    @State private var logs = ""
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if self.preferenceManager.isDebugMode {
                Text("Debug mode is enabled!").foregroundColor(Color.red)
            }
            HStack {
                Text(" Logs:")
                Spacer()
            }
            ScrollView(.vertical, showsIndicators: true) {
                Text(logs)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 8))
                    .onReceive(timer, perform: { time in
                        logs = (UserDefaults.standard.object(forKey: "logs") as! [String]).joined(separator: "\n")
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
                                self.preferenceManager.isLogging = true
                            }
                            .opacity(self.preferenceManager.isLogging ? 0 : 1)
                        
                        // Stop
                        Image(systemName: "stop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .onTapGesture {
                                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                                appDelegate?.stopLocating()
                                self.preferenceManager.isLogging = false
                            }
                            .opacity(self.preferenceManager.isLogging ? 1 : 0)
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
