//
//  MapView.swift
//  GPSLogger
//
//  Created by Yu on 2023/05/04.
//

import Foundation
import SwiftUI
import UIKit
import MapboxMaps


//struct MapViewWrapper : UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> ViewController {
//        return ViewController()
//    }
//
//    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
//}
//
//class ViewController: UIViewController {
//    internal var mapView: MapView!
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//
//        lazy var token: String = {
//            return Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as! String
//        }()
//        // print("token", token)
//        let myResourceOptions = ResourceOptions(accessToken: token)
//        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
//        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
//        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        self.view.addSubview(mapView)
//    }
//}


struct MapViewWrapper : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

public class ViewController: UIViewController {
    
    private var mapView: MapView!
    private var cameraLocationConsumer: CameraLocationConsumer!
    private lazy var styleToggle = UISegmentedControl(items: Style.allCases.map(\.name))
    private var style: Style = .satelliteStreets {
        didSet {
            mapView.mapboxMap.style.uri = style.uri
        }
    }
    
    private enum Style: Int, CaseIterable {
        var name: String {
            switch self {
            case .light:
                return "Light"
            case .satelliteStreets:
                return "Satelite"
            case .customUri:
                return "Custom"
            }
        }
        
        var uri: StyleURI {
            switch self {
            case .light:
                return .light
            case .satelliteStreets:
                return .satelliteStreets
            case .customUri:
                let localStyleURL = Bundle.main.url(forResource: "blueprint_style", withExtension: "json")!
                return .init(url: localStyleURL)!
            }
        }
        
        case light
        case satelliteStreets
        case customUri
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        lazy var token: String = {
            return Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as! String
        }()
        let myResourceOptions = ResourceOptions(accessToken: token)
        
        // Set initial camera settings
        let options = MapInitOptions(
            resourceOptions: myResourceOptions,
            cameraOptions: CameraOptions(center: CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125), zoom: 8),
            styleURI: style.uri
        )
        
        mapView = MapView(frame: view.bounds, mapInitOptions: options)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
        addStyleToggle()
        
        cameraLocationConsumer = CameraLocationConsumer(mapView: mapView)
        
        // Add user position icon to the map with location indicator layer
        mapView.location.options.puckType = .puck2D()
        
        // Allows the delegate to receive information about map events.
        mapView.mapboxMap.onNext(event: .mapLoaded) { [weak self] _ in
            guard let self = self else { return }
            // Register the location consumer with the map
            // Note that the location manager holds weak references to consumers, which should be retained
            self.mapView.location.addLocationConsumer(newConsumer: self.cameraLocationConsumer)
            
        }
    }
    
    @objc func switchStyle(sender: UISegmentedControl) {
        style = Style(rawValue: sender.selectedSegmentIndex) ?? . satelliteStreets
    }
    
    func addStyleToggle() {
        // Create a UISegmentedControl to toggle between map styles
        styleToggle.selectedSegmentIndex = style.rawValue
        styleToggle.addTarget(self, action: #selector(switchStyle(sender:)), for: .valueChanged)
        styleToggle.translatesAutoresizingMaskIntoConstraints = false
        
        // set the segmented control as the title view
        navigationItem.titleView = styleToggle
    }
}

// Create class which conforms to LocationConsumer, update the camera's centerCoordinate when a locationUpdate is received
public class CameraLocationConsumer: LocationConsumer {
    weak var mapView: MapView?
    
    init(mapView: MapView) {
        self.mapView = mapView
    }
    
    public func locationUpdate(newLocation: Location) {
        mapView?.camera.ease(
            to: CameraOptions(center: newLocation.coordinate, zoom: 8),
            duration: 1.3)
    }
}
