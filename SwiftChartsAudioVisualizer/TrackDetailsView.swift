//
//  TrackDetailsView.swift
//  SwiftChartsAudioVisualizer
//
//  Created by Songyee Park on 2022/08/14.
//

import SwiftUI
import Charts


enum Constants {
    static let updateInterval = 0.03
    static let barAmount = 40
    static let magnitudeLimit: Float = 32
}

struct TrackDetailsView: View {
    
    @StateObject var viewModel: TrackDetailsViewModel
    
    @State var data: [Float] = Array(repeating: 0, count: Constants.barAmount)
        .map { _ in Float.random(in: 1...Constants.magnitudeLimit) }
    
    let timer = Timer.publish(
        every: Constants.updateInterval,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack {
                Chart(Array(data.enumerated()), id: \.0) { index, magnitude in
                    BarMark(
                        x: .value("Frequency", String(index)),
                        y: .value("Magnitude", magnitude)
                    )
                    .foregroundStyle(
                        Color(
                            hue: 0.5 - Double((magnitude / Constants.magnitudeLimit) / 5),
                            saturation: 1,
                            brightness: 1,
                            opacity: 0.7
                        )
                    )
                }
                .onReceive(timer, perform: updateData)
                .chartYScale(domain: 0...Constants.magnitudeLimit)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(height: 100)
                .padding()
                .background(
                    .black
                        .opacity(0.3)
                        .shadow(.inner(radius: 20))
                )
                .cornerRadius(10)
                
                PlayerControlsView(viewModel: viewModel)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(radius: 40)
            .padding()
        }
        .background {
            BackgroundPictureView(imageUrl: viewModel.track.imageUrl)
        }
        .preferredColorScheme(.dark)
    }
    
    func updateData(_: Date) {
        if viewModel.isPlaying {
            withAnimation(.easeOut(duration: 0.08)) {
                data = viewModel.audioProcessing.fftMagnitudes.map {
                    min($0, Constants.magnitudeLimit)
                }
                viewModel.playerProgress = viewModel.audioProcessing.playerProgress
            }
        }
    }
    
}


struct TrackDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TrackDetailsView(viewModel: TrackDetailsViewModel.example())
    }
}
