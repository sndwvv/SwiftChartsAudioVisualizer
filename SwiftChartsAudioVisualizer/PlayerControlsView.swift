//
//  PlayerControlsView.swift
//  SwiftChartsAudioVisualizer
//
//  Created by Songyee Park on 2022/08/16.
//

import SwiftUI

struct PlayerControlsView: View {

    @ObservedObject var viewModel: TrackDetailsViewModel
    
    var body: some View {
        VStack {
            ProgressView(value: viewModel.playerProgress)
                .tint(.secondary)
            
            Text(viewModel.track.title)
                .font(.title2)
                .lineLimit(1)
            
            Text(viewModel.track.artistName)
            
            HStack(spacing: 40) {
                Image(systemName: "backward.fill")

                Button(action: playButtonTapped) {
                    Image(systemName: "\(viewModel.isPlaying ? "pause" : "play").circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                Image(systemName: "forward.fill")
            }
            .padding(10)
            .foregroundColor(.secondary)
        }
    }
    
    func playButtonTapped() {
        if viewModel.isPlaying {
            viewModel.audioProcessing.player.pause()
        } else {
            viewModel.audioProcessing.player.play()
        }
        viewModel.isPlaying.toggle()
    }
}

struct PlayerControlsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerControlsView(viewModel: TrackDetailsViewModel.example())
    }
}
