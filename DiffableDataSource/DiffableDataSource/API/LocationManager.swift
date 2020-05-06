//
//  LocationManager.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/6/20.
//  Copyright © 2020 Jammsoft. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationManagerDelegate: class {
    func updatedLocation(coordinate: CLLocationCoordinate2D)
}

class LocationManager: NSObject {
    
    private let manager = CLLocationManager()
    
    
    var localCoordinates: CLLocationCoordinate2D?
    
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            manager.startUpdatingLocation()
        }
    }
    
    func updateLocation() {
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse  || status == .authorizedAlways {
            if CLLocationManager.locationServicesEnabled() {
                manager.stopUpdatingLocation()
                manager.startUpdatingLocation()
            }
        } else {
            requestAuthorization(status: status)
        }
    }
    
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coord = manager.location?.coordinate else { return }
        print("Location: Latitude: \(coord.latitude), Longitude: \(coord.longitude)")
        
        localCoordinates = coord
        
        delegate?.updatedLocation(coordinate: coord)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let firstValidation = UserDefaults.standard.object(forKey: "FirstValidation") as? Bool {
            if firstValidation {
                requestAuthorization(status: status)
            }
        } else {
            UserDefaults.standard.set(true, forKey: "FirstValidation")
        }
    }
    
    func requestAuthorization(status: CLAuthorizationStatus) {
        if status == .notDetermined || status == .denied {
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error!", message: "GPS access is restricted. In order to use tracking, please enable GPS in the Settigs app under Privacy, Location Services.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Go to Settings now", style: .default, handler: { (alert: UIAlertAction!) in
                    let url = URL(string: UIApplication.openSettingsURLString)
                    UIApplication.shared.open( url!, options: [:], completionHandler: { (success) in
                        print("Open url : \(success)")
                    })
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                alert.addAction(alertAction)
                alert.addAction(cancelAction)
                
                AppDelegate.shared.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension LocationManager {
    public static let `default` =  LocationManager()
}
