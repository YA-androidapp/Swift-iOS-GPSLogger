//
//  AppDelegate.swift
//  GPSLogger
//
//  Created by Yu on 2021/08/27.
//

import UIKit

import CoreLocation
import Swifter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {
    var window: UIWindow?
    
    private var locationManager : CLLocationManager!
    
    private var homeAreaRadius: Double = -1.0
    private var homeAreaLocation: CLLocation?
    
    private func log(fil: String, lin: Int, clm: Int, cls: String, fun: String, key: String, val: String){
        if UserDefaults.standard.bool(forKey: "isDebugMode")  {
            DebugUtil.log(fil: fil, lin: lin,clm: clm,cls: cls, fun: fun, key: key, val: val)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        
        let homeAreaLatitude = UserDefaults.standard.double(forKey: "homeAreaLatitude")
        let homeAreaLongitude = UserDefaults.standard.double(forKey: "homeAreaLongitude")
        homeAreaRadius = UserDefaults.standard.double(forKey: "homeAreaRadius")
        if -90 <= homeAreaLatitude && homeAreaLatitude <= 90 && -180 <= homeAreaLongitude && homeAreaLongitude <= 180 && 0 <= homeAreaRadius {
            homeAreaLocation = CLLocation(latitude: homeAreaLatitude, longitude: homeAreaLongitude)
            log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "homeAreaLocation", val: "\(String(describing: homeAreaLocation?.coordinate.latitude)),\(String(describing: homeAreaLocation?.coordinate.longitude))")
        }
        
        locationManager = CLLocationManager.init()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        locationManager.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        
        // デバイスの位置情報が有効の場合
        if CLLocationManager.locationServicesEnabled() {
            log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "LLocationManager.locationServicesEnabled", val: "")
            
            // locationManager!.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
        
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "")
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        locationManager.startMonitoringSignificantLocationChanges()
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        locationManager.startMonitoringSignificantLocationChanges()
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        locationManager.startMonitoringSignificantLocationChanges()
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "")
    }
    
    func startLocating() -> Void {
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        locationManager.startUpdatingLocation()
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "")
    }
    
    func stopLocating() -> Void {
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        locationManager.stopUpdatingLocation()
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "")
    }
    
    func addLog(_ message: String) -> Void {
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        if UserDefaults.standard.object(forKey: "logs") == nil {
            UserDefaults.standard.set([], forKey: "logs")
        }
        var logs : [String] = UserDefaults.standard.object(forKey: "logs") as! [String]
        logs.insert(message, at: 0)
        UserDefaults.standard.set(logs, forKey: "logs")
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "")
    }
    
    func removeLogs() -> Void {
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        UserDefaults.standard.set([], forKey: "logs")
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "")
    }
    
    func formatGPSLogRecord(location: CLLocation) -> String{
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let timestamp = df.string(from: location.timestamp)
        
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "")
        
        return timestamp + "\t" +
            String(format: "%+.09f", location.coordinate.latitude) + "\t" +
            String(format: "%+.09f", location.coordinate.longitude) + "\t" +
            String(format: "%+.03f", location.altitude) + "\t" +
            String(format: "%+.03f", location.horizontalAccuracy) + "\t" +
            String(format: "%+.03f", location.verticalAccuracy) + "\t" +
            String(format: "%+.06f", location.speed) + "\t" +
            String(format: "%+.06f", location.speedAccuracy) + "\t" +
            String(format: "%+.03f", location.course) + "\t" +
            String(format: "%+.03f", location.courseAccuracy)
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        
        let location : CLLocation = locations.last!;
        
        if(homeAreaLocation == nil || location.distance(from: homeAreaLocation!) > homeAreaRadius){
            self.addLog(formatGPSLogRecord(location: location))
            
            UserDefaults.standard.set(location.coordinate.latitude, forKey: "currentLatitude")
            UserDefaults.standard.set(location.coordinate.longitude, forKey: "currentLongitude")
            
            print(
                formatGPSLogRecord(location: location)
            )
        }
        
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "start", val: "")
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "error", val: "\(error)")
        log(fil: #file, lin: #line,clm: #column,cls: String(describing: type(of: self)), fun: #function, key: "end", val: "")
    }
}
