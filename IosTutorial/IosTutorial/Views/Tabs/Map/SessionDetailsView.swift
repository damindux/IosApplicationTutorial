//
//  SessionDetailsView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-09.
//

import SwiftUI

struct SessionDetailsView: View {
  let session: GameSession
  @Environment(\.dismiss) private var dismiss
  
  var body: some View {
    NavigationStack {
      List {
        Section("Game Info") {
          LabeledContent("Mode", value: session.mode.rawValue)
          LabeledContent("Score", value: "\(session.score)")
          LabeledContent("Date", value: session.timestamp.formatted())
        }
        
        Section("Location") {
          LabeledContent("Latitude", value: String(format: "%.6f", session.latitude))
          LabeledContent("Longitude", value: String(format: "%.6f", session.longitude))
        }
      }
    }
  }
}

#Preview {
  SessionDetailsView(session: .init(mode: .TapFrenzy, score: 100, latitude: 10, longitude: 10))
}
