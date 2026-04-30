//
//  GameView.swift
//  Prototype
//
//  Created by DONGWOO WON on 4/30/26.
//
import SwiftUI

struct GameView: View {
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.2)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("Game Screen")
                    .font(.largeTitle)
                    .bold()

                Text("Game logic will be added later.")
                    .multilineTextAlignment(.center)

                Text("Image + scrambled word area")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
            }
            .padding()
        }
        .navigationTitle("Game")
    }
}
