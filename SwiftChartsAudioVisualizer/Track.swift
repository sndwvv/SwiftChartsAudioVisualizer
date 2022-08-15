//
//  Track.swift
//  SwiftChartsAudioVisualizer
//
//  Created by Songyee Park on 2022/08/16.
//

import Foundation

struct Track {
    
    let title: String
    let artistName: String
    let imageUrl: String
    let localFileName: String
    
    static func example() -> Track {
        return Track(title: "Fantaisie - Impromptu, Op. 66",
                     artistName: "Frederic Chopin",
                     imageUrl: "https://images.fineartamerica.com/images/artworkimages/mediumlarge/1/frederic-chopin-the-tragic-genius-english-school.jpg",
                     localFileName: "music")
        
    }

}
