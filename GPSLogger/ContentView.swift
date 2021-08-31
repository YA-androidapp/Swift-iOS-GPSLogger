//
//  ContentView.swift
//  GPSLogger
//
//  Created by Yu on 2021/08/27.
//

import SwiftUI

struct ContentView: View {
    
    @State var isMainMenuOpened: Bool = false
    @State var logs = ""
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.startLocating()
                }, label: {
                    Text("Start locating")
                }).frame(minWidth: 0, maxWidth: .infinity)
                Button(action: {
                    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.stopLocating()
                }, label: {
                    Text("Stop locating")
                }).frame(minWidth: 0, maxWidth: .infinity)
            }
            HStack {
                Button(action: {
                    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.removeLogs()
                }, label: {
                    Text("Clear logs")
                }).frame(minWidth: 0, maxWidth: .infinity)
                Button(action: {
                    if UserDefaults.standard.object(forKey: "logs") != nil {
                        logs = (UserDefaults.standard.object(forKey: "logs") as! [String]).joined(separator: "\n")
                    }
                }, label: {
                    Text("Reload logs")
                }).frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding()
            HStack {
                Text(" Logs:")
                Spacer()
            }
            ScrollView(.vertical, showsIndicators: true) {
                Text(logs)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 8))
            }
            .frame(maxWidth: .infinity, maxHeight: 360.0)
            .background(Color.white)
            
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
