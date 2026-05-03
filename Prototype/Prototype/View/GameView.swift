//
//  GameView.swift
//  Prototype
//
//  Created by DONGWOO WON on 4/30/26.
//
import SwiftUI

struct GameView: View {
    @StateObject private var gameViewModel = GameViewModelModel()
    
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
                
                HStack() {
                    ForEach(0..<gameViewModel.currentAttempt.count, id: \.self) { slotIndex in
                        Rectangle()
                            .fill(Color.white)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Rectangle().stroke(Color.gray, lineWidth: 2)
                            )
                            .overlay(
                                Text(gameViewModel.currentAttempt[slotIndex].map { String($0.letterChar) } ?? "")
                                    .font(.largeTitle)
                                    .bold()
                            )
                            .onTapGesture {
                                gameViewModel.tapSlot(at: slotIndex)
                            }
                    }
                }
                
                HStack {
                    ForEach(gameViewModel.letters) { letter in
                        Rectangle()
                            .fill(Color.purple.opacity(0.3))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text(String(letter.letterChar))
                                    .font(.largeTitle)
                                    .bold()
                            )
                            .onTapGesture {
                                gameViewModel.tapLetterFromBank(letter)
                            }
                    }
                }
                
                Button("Submit") {
                    gameViewModel.confirmAttempt()
                }
                
                .buttonStyle(.borderedProminent)
                .disabled(!gameViewModel.isAttemptComplete)
                
                if let isCorrect = gameViewModel.isCorrect {
                    if isCorrect {
                        Text("Correct!")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.green)
                        Button("Next Word") {
                            gameViewModel.nextWord()
                        }
                        .buttonStyle(.bordered)
                    } else {
                        Text("Try again")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
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
