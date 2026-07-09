//
//  MapView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-08.
//

import SwiftUI
import MapKit

struct MapView: View {
  @State private var viewModel = MapVM()
  
  var body: some View {
    ZStack {
      Color.bg.ignoresSafeArea()
      
      VStack(spacing: 0) {
        if viewModel.isAuthorized {
          mapSection
        }
        else {
          permissionDeniedView
        }
      }
    }
    .onAppear {
      viewModel.checkAuthorization()
      viewModel.loadSessions()
    }
    .onReceive(NotificationCenter.default.publisher(for: .gameSessionAdded)) { _ in
      viewModel.loadSessions()
    }
    .sheet(item: $viewModel.selectedLocation) { cluster in
      LocationDetailSheet(cluster: cluster, viewModel: viewModel)
    }
  }
  
  private var mapCameraPosition: MapCameraPosition {
    if let location = LocationService.shared.location {
      .region(MKCoordinateRegion(
        center: location.coordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      ))
    } else {
      .automatic
    }
  }
  
  private var mapSection: some View {
    Map(initialPosition: mapCameraPosition) {
      ForEach(viewModel.locationClusters) { cluster in
        Annotation(
          coordinate: cluster.coordinate,
          content: {
            mapPin(cluster: cluster)
          }
        ) {
          EmptyView()
        }
      }
    }
    .mapStyle(.standard)
    .mapControls {
      MapUserLocationButton()
      MapCompass()
    }
  }
  
  private var mapRegion: MKCoordinateRegion {
    if let location = LocationService.shared.location {
      MKCoordinateRegion(
        center: location.coordinate,
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      )
    }
    else {
      MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)
      )
    }
  }
  
  private func mapPin(cluster: LocationCluster) -> some View
  {
    let count = viewModel.gameCount(at: cluster)
    let totalScore = viewModel.totalScore(at: cluster)
    
    return Button {
      viewModel.selectedLocation = cluster
    } label: {
      ZStack {
        Rectangle()
          .fill(.bg.opacity(0.5))
          .frame(width: 44, height: 44)
          .offset(x: 3, y: 3)
        
        Rectangle()
          .fill(pinColor(for: totalScore))
          .frame(width: 44, height: 44)
          .overlay(
            Rectangle()
              .stroke(.text, lineWidth: 2)
          )
        
        VStack(spacing: 0) {
          Text("\(count)")
            .font(Font.custom("Pixelify Sans", size: 16))
            .foregroundStyle(.bg)
          
          Image(systemName: "gamecontroller.fill")
            .font(.system(size: 10))
            .foregroundStyle(.bg)
        }
      }
    }
  }
  
  private func pinColor(for score: Int) -> Color
  {
    switch score {
    case 0...50: return .inactive
    case 51...200: return .secondaryAccent
    case 201...500: return .on
    default: return .title
    }
  }
  
  private var permissionDeniedView: some View {
    VStack(spacing: 24) {
      Spacer()
      
      ZStack {
        Rectangle()
          .fill(.sectionBg)
          .frame(width: 80, height: 80)
          .overlay(
            Rectangle()
              .stroke(.on, lineWidth: 2)
          )
        
        Image(systemName: "location.slash.fill")
          .font(.system(size: 36))
          .foregroundStyle(.text)
      }
      
      Text("Location Access Needed")
        .font(Font.custom("Pixelify Sans", size: 28))
        .foregroundStyle(.text)
      
      Text("Enable location services to see where you've played your games.")
        .font(Font.custom("Pixelify Sans", size: 16))
        .foregroundStyle(.title.opacity(0.8))
        .multilineTextAlignment(.center)
        .padding(.horizontal, 32)
      
      Button {
        viewModel.requestPermission()
      } label: {
        Text("Grant Permission")
          .font(Font.custom("Pixelify Sans", size: 18))
          .foregroundStyle(.bg)
          .padding(.horizontal, 24)
          .padding(.vertical, 12)
          .background(.on)
          .overlay(
            Rectangle()
              .stroke(.text, lineWidth: 2)
          )
      }
      
      Spacer()
    }
  }
}

struct LocationDetailSheet: View {
  let cluster: LocationCluster
  let viewModel: MapVM
  
  var body: some View {
    ZStack {
      Color.bg.ignoresSafeArea()
      
      ScrollView {
        VStack(spacing: 20) {
          headerSection
          statsSection
          sessionSection
        }
        .padding()
      }
    }
  }
  
  private var headerSection: some View {
    VStack(spacing: 8) {
      ZStack {
        Text("GAME LOCATION")
          .font(Font.custom("Pixelify Sans", size: 14))
          .foregroundStyle(.bg)
          .padding(.horizontal, 12)
          .padding(.vertical, 4)
          .background(.on)
      }
      
      Text(formattedCoordinate)
        .font(Font.custom("Pixelify Sans", size: 12))
        .foregroundStyle(.title.opacity(0.6))
        .monospacedDigit()
    }
  }
  
  private var formattedCoordinate: String {
    String(format: "%.4f°, %.4f°", cluster.coordinate.latitude, cluster.coordinate.longitude)
  }
  
  private var statsSection: some View {
    HStack(spacing: 12) {
      statBox(
        value: viewModel.gameCount(at: cluster),
        label: "Games",
        color: .on
      )
      
      statBox(
        value: viewModel.totalScore(at: cluster),
        label: "Total",
        color: .secondaryAccent
      )
      
      statBox(
        value: viewModel.bestScore(at: cluster),
        label: "Best",
        color: .title
      )
    }
  }
  
  private func statBox(value: Int, label: String, color: Color) -> some View
  {
    VStack(spacing: 4) {
      Text("\(value)")
        .font(Font.custom("Pixelify Sans", size: 28))
        .foregroundStyle(color)
        .monospacedDigit()
      
      Text(label)
        .font(Font.custom("Pixelify Sans", size: 12))
        .foregroundStyle(.title.opacity(0.6))
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 16)
    .background(.sectionBg)
    .overlay(
      Rectangle()
        .stroke(color.opacity(0.4), lineWidth: 2)
    )
  }
  
  private var sessionSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("SESSIONS")
        .font(Font.custom("Pixelify Sans", size: 16))
        .foregroundStyle(.title.opacity(0.7))
      
      VStack(spacing: 8) {
        ForEach(cluster.sessions) { session in
          sessionRow(session)
        }
      }
    }
  }
  
  private func sessionRow(_ session: GameSession) -> some View
  {
    HStack {
      VStack(alignment: .leading, spacing: 2) {
        Text(session.mode.rawValue)
          .font(Font.custom("Pixelify Sans", size: 16))
          .foregroundStyle(.text)
        
        Text(formattedDate(session.timestamp))
          .font(Font.custom("Pixelify Sans", size: 12))
          .foregroundStyle(.title.opacity(0.5))
      }
      
      Spacer()
      
      Text("\(session.score)")
        .font(Font.custom("Pixelify Sans", size: 24))
        .foregroundStyle(.on)
        .monospacedDigit()
    }
    .padding(12)
    .background(.sectionBg.opacity(0.5))
    .overlay(
      Rectangle()
        .stroke(.bg, lineWidth: 1)
    )
  }
  
  private func formattedDate(_ date: Date) -> String
  {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter.string(from: date)
  }
}

#Preview {
    MapView()
}
