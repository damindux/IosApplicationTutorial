//
//  MapVM.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-09.
//

import SwiftUI
import MapKit

@Observable
class MapVM {
  private let gameService: GameSessionService
  private let locationService: LocationService
  
  var sessions: [GameSession] = []
  var selectedLocation: LocationCluster?
  var authorizationStatus: CLAuthorizationStatus = .notDetermined
  
  var isAuthorized: Bool {
    locationService.isAuthorized()
  }
  
  var locationClusters: [LocationCluster] {
    let grouped = Dictionary(grouping: sessions) { session in
      CoordinateKey(latitude: session.latitude, longitude: session.longitude)
    }
    return grouped.map { key, sessions in
        LocationCluster(
          coordinate: CLLocationCoordinate2D(latitude: key.latitude, longitude: key.longitude),
          sessions: sessions.sorted { $0.timestamp > $1.timestamp }
        )
    }
  }
  
  var mapCamera: MapCameraPosition {
    if let location = locationService.location {
      .region(MKCoordinateRegion(
        center: location.coordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      ))
    }
    else {
      .automatic
    }
  }
  
  init(
    gameService: GameSessionService = .shared,
    locationService: LocationService = .shared
  )
  {
    self.gameService = gameService
    self.locationService = locationService
    self.authorizationStatus = locationService.authorizationStatus
  }
  
  func loadSessions()
  {
    sessions = gameService.load()
  }
  
  func checkAuthorization()
  {
    authorizationStatus = locationService.authorizationStatus
  }
  
  func requestPermission() {
    locationService.requestPermission()
  }
  
  func totalScore(at cluster: LocationCluster) -> Int
  {
    cluster.sessions.reduce(0) { $0 + $1.score }
  }
  
  func bestScore(at cluster: LocationCluster) -> Int
  {
    cluster.sessions.map(\.score).max() ?? 0
  }
  
  func gameCount(at cluster: LocationCluster) -> Int
  {
    cluster.sessions.count
  }
}

struct LocationCluster: Identifiable {
  let id = UUID()
  let coordinate: CLLocationCoordinate2D
  let sessions: [GameSession]
}

private struct CoordinateKey: Hashable {
  let latitude: Double
  let longitude: Double
  
  init(latitude: Double, longitude: Double)
  {
    self.latitude = (latitude * 1000).rounded() / 1000
    self.longitude = (longitude * 1000).rounded() / 1000
  }
}
