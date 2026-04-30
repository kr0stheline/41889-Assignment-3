//
//  GameView.swift
//  Prototype
//
//  Created by DONGWOO WON on 4/30/26.
//
import SwiftUI

struct GameView: View {
    var body: some View {
        @StateObject var gameViewModel = GameViewModelModel()
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
                
                HStack() {
                    
                    ForEach(gameViewModel.letters) { letter in
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(String(letter.letterChar)))
                            
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                   


                }
            }
                
                
            .padding()
        }
        .navigationTitle("Game")
    }
}

#Preview {
    GameView()
}
