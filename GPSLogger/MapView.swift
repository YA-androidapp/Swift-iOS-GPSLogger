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

struct MapViewWrapper : UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}

class ViewController: UIViewController {
    internal var mapView: MapView!
    override public func viewDidLoad() {
        super.viewDidLoad()

        lazy var token: String = {
            return Bundle.main.object(forInfoDictionaryKey: "MBXAccessToken") as! String
        }()
        // print("token", token)
        let myResourceOptions = ResourceOptions(accessToken: token)
        let myMapInitOptions = MapInitOptions(resourceOptions: myResourceOptions)
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
    }
}
