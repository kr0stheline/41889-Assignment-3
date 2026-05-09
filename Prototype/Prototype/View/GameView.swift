//
//  GameView.swift
//  Prototype
//
//  Created by DONGWOO WON on 4/30/26.
//

import SwiftUI
import UIKit

struct GameView: View {
    @StateObject private var gameViewModel: GameViewModel
    
    @State private var finalTotalTime = 0
    @State private var finalStagesCleared = 0
    
    @State private var skippedStages: Set<Int> = []
    @State private var clearedStages: Set<Int> = []
    
    private let totalStages = 8
    
    init(topic: String, difficulty: String) {
        _gameViewModel = StateObject(wrappedValue: GameViewModel(topic: topic, difficulty: difficulty))
    }
    
    var body: some View {
        GeometryReader { geo in
            let screenWidth = geo.size.width
            let screenHeight = geo.size.height
            
            let contentWidth = min(screenWidth * 0.86, 345)
            let imageSize = min(contentWidth, screenHeight * 0.255)
            let tileSize = min(54, calculateTileSize(contentWidth: contentWidth))
            let topSpace = max(42, geo.safeAreaInsets.top + 18)
            
            ZStack {
                backgroundView(width: screenWidth, height: screenHeight)
                
                VStack(spacing: 9) {
                    Spacer()
                        .frame(height: topSpace)
                    
                    topInfoCard
                        .frame(width: contentWidth)
                    
                    stageProgressCard(width: contentWidth)
                    
                    imageCard(size: imageSize)
                    
                    instructionCard
                        .frame(width: contentWidth * 0.92)
                    
                    answerSlots(tileSize: tileSize)
                        .frame(width: contentWidth)
                        .padding(.top, 2)
                    
                    letterBank(tileSize: tileSize)
                        .padding(.top, 2)
                    
                    bottomActionButtons(width: contentWidth)
                        .padding(.top, 3)
                    
                    resultMessage
                    
                    Spacer(minLength: geo.safeAreaInsets.bottom + 10)
                }
                .frame(width: screenWidth, height: screenHeight)
            }
            .frame(width: screenWidth, height: screenHeight)
        }
        .ignoresSafeArea()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            resetStageTracking()
            gameViewModel.startGame()
        }
        .onDisappear {
            gameViewModel.stopGame()
        }
        .onChange(of: gameViewModel.isCorrect) { _, newValue in
            if newValue == true {
                clearedStages.insert(currentStage)
                skippedStages.remove(currentStage)
                
                finalTotalTime = gameViewModel.time
                finalStagesCleared = clearedStages.count
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    gameViewModel.nextWord()
                }
            }
        }
        .onChange(of: gameViewModel.currentWord) { oldValue, newValue in
            let oldStage = min(oldValue + 1, totalStages)
            
            if newValue > oldValue {
                if !clearedStages.contains(oldStage) && !skippedStages.contains(oldStage) {
                    skippedStages.insert(oldStage)
                }
            }
            
            finalTotalTime = gameViewModel.time
            finalStagesCleared = clearedStages.count
        }
        .navigationDestination(isPresented: $gameViewModel.isGameOver) {
            ResultView(
                score: gameViewModel.score,
                stagesCleared: finalStagesCleared,
                totalStages: totalStages,
                totalTime: finalTotalTime,
                clearedStages: clearedStages,
                skippedStages: skippedStages
            )
        }
    }
}

// MARK: - UI Components

extension GameView {
    
    private func backgroundView(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            Color(red: 0.45, green: 0.78, blue: 0.16)
            
            Image("gameBackground")
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
            
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.clear,
                    Color(red: 0.42, green: 0.78, blue: 0.14).opacity(0.18)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .frame(width: width, height: height)
    }
    
    private var topInfoCard: some View {
        HStack(spacing: 0) {
            infoItem(
                title: "Time",
                value: "\(gameViewModel.time)",
                icon: "clock.fill",
                color: .blue
            )
            
            divider
            
            infoItem(
                title: "Score",
                value: "\(Int(gameViewModel.score))",
                icon: "star.fill",
                color: .orange
            )
            
            divider
            
            infoItem(
                title: "Level",
                value: gameViewModel.difficulty,
                icon: "flag.fill",
                color: .purple
            )
            
            divider
            
            infoItem(
                title: "Topic",
                value: gameViewModel.topic,
                icon: topicIconName,
                color: .green
            )
        }
        .padding(.vertical, 9)
        .padding(.horizontal, 9)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.96))
                .shadow(color: .black.opacity(0.16), radius: 8, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.9), lineWidth: 2)
        )
    }
    
    private func infoItem(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 8.5, weight: .semibold))
                .foregroundColor(.black.opacity(0.65))
            
            Text(value)
                .font(.system(size: 11.5, weight: .heavy, design: .rounded))
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.45)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var divider: some View {
        Rectangle()
            .fill(Color.orange.opacity(0.22))
            .frame(width: 1.2, height: 38)
            .padding(.horizontal, 3)
    }
    
    private func stageProgressCard(width: CGFloat) -> some View {
        VStack(spacing: 7) {
            Text("Stage Progress")
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundColor(.brown)
            
            HStack(spacing: 8) {
                ForEach(1...totalStages, id: \.self) { stage in
                    VStack(spacing: 3) {
                        Text("\(stage)")
                            .font(.system(size: 8, weight: .bold, design: .rounded))
                            .foregroundColor(.brown.opacity(0.75))
                        
                        ZStack {
                            Circle()
                                .fill(stageCircleColor(stage))
                                .frame(width: 18, height: 18)
                                .shadow(
                                    color: stage == currentStage ? .orange.opacity(0.35) : .clear,
                                    radius: 4,
                                    x: 0,
                                    y: 2
                                )
                            
                            if skippedStages.contains(stage) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 9, weight: .heavy))
                                    .foregroundColor(.white)
                            } else if clearedStages.contains(stage) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 9, weight: .heavy))
                                    .foregroundColor(.white)
                            } else if stage == currentStage {
                                Text("!")
                                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .frame(width: width)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white.opacity(0.94))
                .shadow(color: .black.opacity(0.12), radius: 7, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.orange.opacity(0.25), lineWidth: 1.5)
        )
    }
    
    private func imageCard(size: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.orange.opacity(0.95),
                                    Color.yellow.opacity(0.9),
                                    Color.orange.opacity(0.95)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 5
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 26)
                        .stroke(Color.white.opacity(0.95), lineWidth: 2)
                        .padding(6)
                )
            
            if UIImage(named: currentWordImageName) != nil {
                Image(currentWordImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.82, height: size * 0.82)
            } else {
                VStack(spacing: 10) {
                    Image(systemName: "photo")
                        .font(.system(size: 58))
                        .foregroundColor(.gray)
                    
                    Text("No image: \(currentWordImageName)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: size, height: size)
    }
    
    private var instructionCard: some View {
        HStack(spacing: 8) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.orange)
            
            Text("Tap the letters in the right order!")
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .foregroundColor(.brown)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
            
            Image(systemName: "sparkles")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.yellow)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 21)
                .fill(Color.white.opacity(0.95))
                .shadow(color: .black.opacity(0.13), radius: 6, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 21)
                .stroke(Color.orange.opacity(0.35), lineWidth: 1.7)
        )
    }
    
    private func answerSlots(tileSize: CGFloat) -> some View {
        HStack(spacing: 26) {
            ForEach(0..<gameViewModel.currentAttempt.count, id: \.self) { slotIndex in
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .frame(width: tileSize, height: tileSize)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.orange.opacity(0.38), lineWidth: 2)
                    )
                    .overlay(
                        Text(gameViewModel.currentAttempt[slotIndex].map { String($0.letterChar) } ?? "")
                            .font(.system(size: tileSize * 0.48, weight: .heavy, design: .rounded))
                            .foregroundColor(.brown)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                    .onTapGesture {
                        gameViewModel.tapSlot(at: slotIndex)
                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func letterBank(tileSize: CGFloat) -> some View {
        HStack(spacing: 20) {
            ForEach(gameViewModel.letters) { letter in
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: tileSize, height: tileSize)
                    .overlay(
                        Text(String(letter.letterChar))
                            .font(.system(size: tileSize * 0.48, weight: .heavy, design: .rounded))
                            .foregroundColor(letterColor(for: letter.letterChar))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray.opacity(0.18), lineWidth: 1.5)
                    )
                    .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 3)
                    .onTapGesture {
                        gameViewModel.tapLetterFromBank(letter)
                    }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.92))
                .shadow(color: .black.opacity(0.14), radius: 7, x: 0, y: 5)
        )
    }
    
    private func bottomActionButtons(width: CGFloat) -> some View {
        HStack(spacing: 14) {
            checkButton
                .frame(width: width - 80)
            
            skipButton
                .frame(width: 62, height: 62)
        }
        .frame(width: width, alignment: .center)
    }
    
    private var checkButton: some View {
        Button {
            gameViewModel.confirmAttempt()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "checkmark")
                    .font(.system(size: 26, weight: .heavy))
                
                Text("Check")
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 31)
                        .fill(
                            gameViewModel.isAttemptComplete
                            ? Color(red: 1.0, green: 0.67, blue: 0.07)
                            : Color.white.opacity(0.23)
                        )
                    
                    RoundedRectangle(cornerRadius: 31)
                        .stroke(Color.white.opacity(0.7), lineWidth: 3)
                }
            )
            .shadow(
                color: gameViewModel.isAttemptComplete ? .orange.opacity(0.42) : .clear,
                radius: 8,
                x: 0,
                y: 5
            )
        }
        .disabled(!gameViewModel.isAttemptComplete)
    }
    
    private var skipButton: some View {
        Button {
            skippedStages.insert(currentStage)
            clearedStages.remove(currentStage)
            
            finalTotalTime = gameViewModel.time
            finalStagesCleared = clearedStages.count
            
            gameViewModel.nextWord()
        } label: {
            Image(systemName: "forward.fill")
                .font(.system(size: 24, weight: .heavy))
                .foregroundColor(.blue)
                .frame(width: 62, height: 62)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.96))
                        .shadow(color: .black.opacity(0.16), radius: 5, x: 0, y: 3)
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.85), lineWidth: 2)
                )
        }
    }
    
    private var resultMessage: some View {
        Group {
            if let isCorrect = gameViewModel.isCorrect {
                if isCorrect {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .bold))
                        
                        Text("Correct!")
                            .font(.system(size: 15, weight: .heavy, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(Color.green)
                            .shadow(color: .green.opacity(0.25), radius: 5, x: 0, y: 3)
                    )
                } else {
                    HStack(spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .bold))
                        
                        Text("Try again")
                            .font(.system(size: 15, weight: .heavy, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(Color.red.opacity(0.92))
                            .shadow(color: .red.opacity(0.24), radius: 5, x: 0, y: 3)
                    )
                }
            } else {
                Text("")
                    .padding(.vertical, 7)
            }
        }
        .frame(height: 34)
    }
}

// MARK: - Helpers

extension GameView {
    
    private var currentStage: Int {
        min(gameViewModel.currentWord + 1, totalStages)
    }
    
    private func resetStageTracking() {
        finalTotalTime = 0
        finalStagesCleared = 0
        skippedStages.removeAll()
        clearedStages.removeAll()
    }
    
    private func stageCircleColor(_ stage: Int) -> Color {
        if skippedStages.contains(stage) {
            return .red
        } else if clearedStages.contains(stage) {
            return .green
        } else if stage == currentStage {
            return .orange
        } else {
            return Color.gray.opacity(0.25)
        }
    }
    
    private func calculateTileSize(contentWidth: CGFloat) -> CGFloat {
        let answerCount = max(gameViewModel.currentAttempt.count, 1)
        let letterCount = max(gameViewModel.letters.count, 1)
        
        let answerSpacing: CGFloat = 26
        let letterSpacing: CGFloat = 20
        
        let answerTileSize = (contentWidth - CGFloat(answerCount - 1) * answerSpacing) / CGFloat(answerCount)
        let letterTileSize = (contentWidth - CGFloat(letterCount - 1) * letterSpacing - 40) / CGFloat(letterCount)
        
        return min(answerTileSize, letterTileSize)
    }
    
    private var currentWordImageName: String {
        guard gameViewModel.words.indices.contains(gameViewModel.currentWord) else {
            return "defaultImage"
        }
        
        return gameViewModel.words[gameViewModel.currentWord]
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
    }
    
    private var topicIconName: String {
        switch gameViewModel.topic {
        case "Animals":
            return "pawprint.fill"
        case "Fruits":
            return "apple.logo"
        case "Nature":
            return "leaf.fill"
        case "Science":
            return "atom"
        default:
            return "questionmark.circle.fill"
        }
    }
    
    private func letterColor(for char: Character) -> Color {
        let colors: [Color] = [
            .blue,
            .orange,
            .green,
            .red,
            .purple,
            .cyan,
            .pink
        ]
        
        let asciiValue = char.asciiValue.map { Int($0) } ?? 0
        let index = abs(asciiValue) % colors.count
        
        return colors[index]
    }
}

#Preview {
    NavigationStack {
        GameView(topic: "Animals", difficulty: "Medium")
    }
}
