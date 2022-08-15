//
//  BackgroundPictureView.swift
//  SwiftChartsAudioVisualizer
//
//  Created by Songyee Park on 2022/08/16.
//

import SwiftUI

struct BackgroundPictureView: View {
    
    var imageUrl: String

    var body: some View {
        AsyncImage(url: URL(string: imageUrl), transaction: Transaction(animation: .easeOut(duration: 1))) { phase in
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
    
}

struct BackgroundPictureView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundPictureView(imageUrl: Track.example().imageUrl)
    }
}
