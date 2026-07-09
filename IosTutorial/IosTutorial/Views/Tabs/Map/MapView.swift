//
//  MapView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-08.
//

import SwiftUI
import MapKit

struct MapView: View {
  @State private var locationService = LocationService.shared
  @State private var gameService = GameSessionService.shared
  @State private var sessions: [GameSession] = []
  @State private var selectedSession: GameSession?
  
  var body: some View {
    ZStack {
      Color.bg.ignoresSafeArea()
      
      VStack {
        if locationService.isAuthorized() {
          Map(selection: $selectedSession) {
            ForEach(sessions) { session in
              Marker(
                session.mode.rawValue,
                coordinate: CLLocationCoordinate2D(latitude: session.latitude, longitude: session.longitude)
              )
              .tag(session)
            }
          }
          .mapStyle(.standard)
          .sheet(item: $selectedSession) { session in
            SessionDetailsView(session: session)
          }
          .onAppear {
            sessions = gameService.load()
          }
          .onReceive(NotificationCenter.default.publisher(for: .gameSessionAdded)) { _ in
              sessions = gameService.load()
          }
        }
        else {
          Text("We don't have permission to access your location.")
            .font(Font.custom("Pixelify Sans", size: 22))
            .foregroundStyle(.text)
            .multilineTextAlignment(.center)
        }
      }
    }
  }
}

#Preview {
    MapView()
}
