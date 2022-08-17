//
//  TrackRowView.swift
//  SwiftChartsAudioVisualizer
//
//  Created by Songyee Park on 2022/08/17.
//

import SwiftUI

struct TrackRowView: View {
    
    let track: Track
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "music.note")
                Text(track.title)
                    .font(.title2)
            }
            Text(track.artistName)
                .font(.subheadline)
                .padding(.top, 8)
        }
        .frame(height: 100)
    }
}

struct TrackRowView_Previews: PreviewProvider {
    static var previews: some View {
        TrackRowView(track: Track.example())
    }
}
