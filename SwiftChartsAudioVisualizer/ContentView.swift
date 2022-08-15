//
//  ContentView.swift
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

struct ContentView: View {
    
    let audioProcessing = AudioProcessing.shared
    
    @State var isPlaying = false
    @State var data: [Float] = Array(repeating: 0, count: Constants.barAmount)
        .map { _ in Float.random(in: 1...Constants.magnitudeLimit) }
    @State var playerProgress: Double = 0.0
    
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
                            hue: 0.3 - Double((magnitude / Constants.magnitudeLimit) / 5),
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
                
                playerControls
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(radius: 40)
            .padding()
        }
        .background {
            backgroundPicture
        }
        .preferredColorScheme(.dark)
    }
    
    var playerControls: some View {
        Group {
            ProgressView(value: playerProgress)
                .tint(.secondary)
            
            Text("Fantaisie - Impromptu, Op. 66")
                .font(.title2)
                .lineLimit(1)
            
            Text("Frederic Chopin")
            
            HStack(spacing: 40) {
                Image(systemName: "backward.fill")

                Button(action: playButtonTapped) {
                    Image(systemName: "\(isPlaying ? "pause" : "play").circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                Image(systemName: "forward.fill")
            }
            .padding(10)
            .foregroundColor(.secondary)
        }
    }
    
    var backgroundPicture: some View {
        AsyncImage(url: URL(string: "https://images.fineartamerica.com/images/artworkimages/mediumlarge/1/frederic-chopin-the-tragic-genius-english-school.jpg"), transaction: Transaction(animation: .easeOut(duration: 1))) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            default:
                Color.clear
            }
        }
        .overlay {
            LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)
        }
        .ignoresSafeArea()
    }
    
    func playButtonTapped() {
        if isPlaying {
            audioProcessing.player.pause()
        } else {
            audioProcessing.player.play()
        }
        isPlaying.toggle()
    }
    
    func updateData(_: Date) {
        if isPlaying {
            withAnimation(.easeOut(duration: 0.08)) {
                data = audioProcessing.fftMagnitudes.map {
                    min($0, Constants.magnitudeLimit)
                }
                print("player progress: \(audioProcessing.currentProgress)")
                playerProgress = audioProcessing.currentProgress
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
