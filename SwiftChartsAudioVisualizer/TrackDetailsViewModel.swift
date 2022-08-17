//
//  TrackDetailsViewModel.swift
//  SwiftChartsAudioVisualizer
//
//  Created by Songyee Park on 2022/08/16.
//

import Foundation

class TrackDetailsViewModel: ObservableObject {
    
    let audioProcessing: AudioProcessing
    let track: Track
    
    @Published var playerProgress: Double = 0.0
    @Published var isPlaying: Bool = false
    
    init(track: Track) {
        self.track = track
        audioProcessing = AudioProcessing(fileName: track.localFileName)
    }
    
    static func example() -> TrackDetailsViewModel {
        return TrackDetailsViewModel(track: Track.example2())
    }
    
}


