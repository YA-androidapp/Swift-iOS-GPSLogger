//
//  AppDelegate.swift
//  GPSLogger
//
//  Created by Yu on 2021/08/27.
//

import UIKit

import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ObservableObject {
    var window: UIWindow?
    
    var locationManager : CLLocationManager!
    
    private var homeAreaRadius: Double = -1.0
    private var homeAreaLocation: CLLocation?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        let homeAreaLatitude = UserDefaults.standard.double(forKey: "homeAreaLatitude")
        let homeAreaLongitude = UserDefaults.standard.double(forKey: "homeAreaLongitude")
        homeAreaRadius = UserDefaults.standard.double(forKey: "homeAreaRadius")
        if -90 <= homeAreaLatitude && homeAreaLatitude <= 90 && -180 <= homeAreaLongitude && homeAreaLongitude <= 180 && 0 <= homeAreaRadius {
            homeAreaLocation = CLLocation(latitude: homeAreaLatitude, longitude: homeAreaLongitude)
        }
        
        locationManager = CLLocationManager.init()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1
        locationManager.delegate = self
        CLLocationManager.authorizationStatus()
        
        if launchOptions?[.location] != nil {
            locationManager.startMonitoringSignificantLocationChanges()
        }
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func startLocating() -> Void {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocating() -> Void {
        locationManager.stopUpdatingLocation()
    }
    
    func addLog(_ log: String) -> Void {
        if UserDefaults.standard.object(forKey: "logs") == nil {
            UserDefaults.standard.set([], forKey: "logs")
        }
        var logs : [String] = UserDefaults.standard.object(forKey: "logs") as! [String]
        logs.insert(log, at: 0)
        UserDefaults.standard.set(logs, forKey: "logs")
    }
    
    func removeLogs() -> Void {
        UserDefaults.standard.set([], forKey: "logs")
    }
}

func formatGPSLogRecord(location: CLLocation) -> String{
    let df = DateFormatter()
    df.dateFormat = "yyyy/MM/dd HH:mm:ss"
    let timestamp = df.string(from: location.timestamp)
    
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

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location : CLLocation = locations.last!;
        
        if(homeAreaLocation == nil || location.distance(from: homeAreaLocation!) > homeAreaRadius){
            self.addLog(formatGPSLogRecord(location: location))
            
            print(
                formatGPSLogRecord(location: location)
            )
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .restricted) {
            print("status: restricted")
        }
        else if (status == .denied) {
            print("status: denied")
        }
        else if (status == .authorizedWhenInUse) {
            print("status: authorizedWhenInUse")
        }
        else if (status == .authorizedAlways) {
            locationManager.startUpdatingLocation()
        }
    }
}
