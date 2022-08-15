//
//  AudioProcessing.swift
//  SwiftChartsAudioVisualizer
//
//  Created by Vinicius Nakamura on 22/07/22.
//

import AVFoundation
import Accelerate

/**
 - I'm no expert in audio processing. What I did here, I learnt from this Article:
   - __Audio Visualization in Swift Using Metal and Accelerate__
   - _By Alex Barbulescu_
   - https://betterprogramming.pub/audio-visualization-in-swift-using-metal-accelerate-part-1-390965c095d7
 
 This works for the purposes of this demo, but if you want to add a sound visualizer to a real app,
 consider using something more robust, like the [AudioKit](https://audiokit.io/) framework.
 */
class AudioProcessing {
    
    private let engine = AVAudioEngine()
    private let bufferSize = 1024
    
    let player = AVAudioPlayerNode()
    var fftMagnitudes: [Float] = []
    
    var duration: TimeInterval = 0
    
    init(fileName: String) {
        
        _ = engine.mainMixerNode
        
        engine.prepare()
        try! engine.start()
        
        let audioFile = try! AVAudioFile(
            forReading: Bundle.main.url(forResource: fileName, withExtension: "mp3")!
        )
        
        print("audio duration: \(audioFile.duration)")
        duration = audioFile.duration
        
        let format = audioFile.processingFormat
            
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: format)
            
        player.scheduleFile(audioFile, at: nil)
            
        let fftSetup = vDSP_DFT_zop_CreateSetup(
            nil,
            UInt(bufferSize),
            vDSP_DFT_Direction.FORWARD
        )
            
        engine.mainMixerNode.installTap(
            onBus: 0,
            bufferSize: UInt32(bufferSize),
            format: nil
        ) { [self] buffer, _ in
            let channelData = buffer.floatChannelData?[0]
            fftMagnitudes = fft(data: channelData!, setup: fftSetup!)
        }
    }
    
    func fft(data: UnsafeMutablePointer<Float>, setup: OpaquePointer) -> [Float] {
        var realIn = [Float](repeating: 0, count: bufferSize)
        var imagIn = [Float](repeating: 0, count: bufferSize)
        var realOut = [Float](repeating: 0, count: bufferSize)
        var imagOut = [Float](repeating: 0, count: bufferSize)
            
        for i in 0 ..< bufferSize {
            realIn[i] = data[i]
        }
        
        vDSP_DFT_Execute(setup, &realIn, &imagIn, &realOut, &imagOut)
        
        var magnitudes = [Float](repeating: 0, count: Constants.barAmount)
        
        realOut.withUnsafeMutableBufferPointer { realBP in
            imagOut.withUnsafeMutableBufferPointer { imagBP in
                var complex = DSPSplitComplex(realp: realBP.baseAddress!, imagp: imagBP.baseAddress!)
                vDSP_zvabs(&complex, 1, &magnitudes, 1, UInt(Constants.barAmount))
            }
        }
        
        var normalizedMagnitudes = [Float](repeating: 0.0, count: Constants.barAmount)
        var scalingFactor = Float(1)
        vDSP_vsmul(&magnitudes, 1, &scalingFactor, &normalizedMagnitudes, 1, UInt(Constants.barAmount))
            
        return normalizedMagnitudes
    }
    
    var playerProgress: Double {
        let progress = player.current / duration
        if progress < 0 {
            return 0
        } else {
            let roundedValue = round(progress * 1000) / 1000.0
            return roundedValue
        }
    }
    
    var playerCurrentTimeString: String {
        let current = player.current
        return DateComponentsFormatter().string(from: current) ?? ""
    }
    
    var playerDurationTimeString: String {
        return DateComponentsFormatter().string(from: duration) ?? ""
    }
    
}


extension AVAudioFile {

    var duration: TimeInterval {
        let sampleRateSong = Double(processingFormat.sampleRate)
        let lengthSongSeconds = Double(length) / sampleRateSong
        return lengthSongSeconds
    }

}


extension AVAudioPlayerNode {

    var current: TimeInterval {
        if let nodeTime = lastRenderTime, let playerTime = playerTime(forNodeTime: nodeTime) {
            return Double(playerTime.sampleTime) / playerTime.sampleRate
        }
        return 0
    }

}
