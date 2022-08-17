//
//  TrackListView.swift
//  SwiftChartsAudioVisualizer
//
//  Created by Songyee Park on 2022/08/16.
//

import SwiftUI

struct TrackListView: View {
    
    let tracks: [Track]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Classical")) {
                    ForEach(tracks) { track in
                        NavigationLink {
                            TrackDetailsView(viewModel: TrackDetailsViewModel(track: track))
                        } label: {
                            TrackRowView(track: track)
                        }
                    }
                }
            }
            .navigationTitle("Tracks")
        }
    }
}

struct TrackListView_Previews: PreviewProvider {
    static var previews: some View {
        TrackListView(tracks: [Track.example(), Track.example2()])
    }
}
