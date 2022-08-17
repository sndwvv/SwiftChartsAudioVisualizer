//
//  Track.swift
//  SwiftChartsAudioVisualizer
//
//  Created by Songyee Park on 2022/08/16.
//

import Foundation

struct Track: Identifiable {
    
    let id: Int
    let title: String
    let artistName: String
    let imageUrl: String
    let localFileName: String
    
    static func example() -> Track {
        return Track(id: 1,
                     title: "Fantaisie - Impromptu, Op. 66",
                     artistName: "Frederic Chopin",
                     imageUrl: "https://images.fineartamerica.com/images/artworkimages/mediumlarge/1/frederic-chopin-the-tragic-genius-english-school.jpg",
                     localFileName: "chopin")
    }
    
    static func example2() -> Track {
        return Track(id: 2,
                     title: "Moonlight Sonata Op. 27 No. 2 - III Presto",
                     artistName: "Ludwig van Beethoven",
                     imageUrl: "https://europa.eu/youth/d8/sites/default/files/nnfe-people/70.Beethoven_Reporters_91539.jpg",
                     localFileName: "beethoven")
    }

}
