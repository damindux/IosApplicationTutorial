//
//  LocationService.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-08.
//

import Foundation
import CoreLocation

@Observable
final class LocationService: NSObject {
  static let shared = LocationService()
  
  var location: CLLocation?
  var authorizationStatus: CLAuthorizationStatus = .notDetermined
  
  private let manager = CLLocationManager()
  
  override init() {
    super.init()
    
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func requestLocation() {
    switch manager.authorizationStatus {
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
      
    case .authorizedWhenInUse, .authorizedAlways:
      manager.requestLocation()
      
    case .restricted, .denied:
      print("Location permission denied")
      
    @unknown default:
      break
    }
  }
}

extension LocationService: CLLocationManagerDelegate {
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationStatus = manager.authorizationStatus
    
    switch manager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      manager.requestLocation()
      
    default:
      break
    }
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]
  ) {
    location = locations.first
  }
  
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print("Location error:", error.localizedDescription)
  }
}
