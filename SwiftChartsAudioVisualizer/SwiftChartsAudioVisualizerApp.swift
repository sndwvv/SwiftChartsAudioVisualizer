//
//  SwiftChartsAudioVisualizerApp.swift
//  SwiftChartsAudioVisualizer
//
//  Created by Songyee Park on 2022/08/14.
//

import SwiftUI

@main
struct SwiftChartsAudioVisualizerApp: App {
    var body: some Scene {
        WindowGroup {
            TrackListView(tracks: [Track.example(), Track.example2()])
        }
    }
}
