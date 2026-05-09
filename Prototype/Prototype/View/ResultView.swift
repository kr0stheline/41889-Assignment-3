//
//  ResultView.swift
//  Prototype
//

import SwiftUI

struct ResultView: View {
    let score: Double
    let stagesCleared: Int
    let totalStages: Int
    let totalTime: Int
    let clearedStages: Set<Int>
    let skippedStages: Set<Int>
    
    @State private var goToSettings = false
    @State private var goToHome = false
    
    init(
        score: Double,
        stagesCleared: Int = 8,
        totalStages: Int = 8,
        totalTime: Int = 0,
        clearedStages: Set<Int> = [],
        skippedStages: Set<Int> = []
    ) {
        self.score = score
        self.stagesCleared = stagesCleared
        self.totalStages = totalStages
        self.totalTime = totalTime
        self.clearedStages = clearedStages
        self.skippedStages = skippedStages
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                backgroundView
                
                VStack(spacing: 0) {
                    Spacer()
                        .frame(height: geo.safeAreaInsets.top + 16)
                    
                    resultPanel
                    
                    Spacer(minLength: 12)
                }
                .padding(.horizontal, 16)
            }
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToSettings) {
            SettingView()
                .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $goToHome) {
            HomeView()
                .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Main UI

extension ResultView {
    
    private var backgroundView: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.25, green: 0.80, blue: 1.0),
                    Color(red: 0.82, green: 0.95, blue: 1.0),
                    Color(red: 1.0, green: 0.96, blue: 0.82)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            
            sunburstLayer
            confettiLayer
        }
    }
    
    private var resultPanel: some View {
        VStack(spacing: 13) {
            titleBanner
            
            completedText
            
            mainScoreCard
            
            stageAndTimeCard
            
            stageProgressCard
            
            achievementBadge
            
            Spacer(minLength: 8)
            
            bottomButtons
        }
        .padding(.horizontal, 14)
        .padding(.top, 4)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 650)
        .background(
            RoundedRectangle(cornerRadius: 34)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.97),
                            Color(red: 1.0, green: 0.98, blue: 0.90).opacity(0.96)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 34)
                        .stroke(Color.white.opacity(0.9), lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.16), radius: 12, x: 0, y: 7)
        )
    }
    
    private var titleBanner: some View {
        Image("amazingHeader")
            .resizable()
            .scaledToFit()
            .frame(height: 118)
            .padding(.horizontal, -20)
            .padding(.top, -4)
            .shadow(color: .orange.opacity(0.25), radius: 6, x: 0, y: 4)
    }
    
    private var completedText: some View {
        Text("You completed the challenge!")
            .font(.system(size: 15, weight: .heavy, design: .rounded))
            .foregroundColor(.brown)
            .padding(.top, -8)
    }
}

// MARK: - Cards

extension ResultView {
    
    private var mainScoreCard: some View {
        VStack(spacing: 10) {
            HStack(spacing: 7) {
                Image(systemName: "sparkles")
                    .foregroundColor(.orange)
                
                Text("Total Score")
                    .font(.system(size: 19, weight: .heavy, design: .rounded))
                    .foregroundColor(.brown)
                
                Image(systemName: "sparkles")
                    .foregroundColor(.orange)
            }
            
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.yellow.opacity(0.35),
                                    Color.orange.opacity(0.15)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 82, height: 82)
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 54))
                        .foregroundColor(.yellow)
                        .shadow(color: .orange.opacity(0.45), radius: 4, x: 0, y: 3)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(Int(score))")
                        .font(.system(size: 58, weight: .heavy, design: .rounded))
                        .foregroundColor(.green)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    
                    Text(scoreRankText)
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(scoreBadgeColor)
                        )
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
    }
    
    private var stageAndTimeCard: some View {
        HStack(spacing: 0) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.yellow.opacity(0.28))
                        .frame(width: 58, height: 58)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.yellow)
                        .shadow(color: .orange.opacity(0.35), radius: 3, x: 0, y: 2)
                }
                
                Text("Stages Cleared")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundColor(.brown)
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(stagesCleared)")
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .foregroundColor(.green)
                    
                    Text("/ \(totalStages)")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundColor(.green.opacity(0.9))
                }
            }
            .frame(maxWidth: .infinity)
            
            Rectangle()
                .fill(Color.orange.opacity(0.18))
                .frame(width: 1.5, height: 105)
            
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.16))
                        .frame(width: 58, height: 58)
                    
                    Image(systemName: "stopwatch.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.blue)
                        .shadow(color: .blue.opacity(0.25), radius: 3, x: 0, y: 2)
                }
                
                Text("Total Time")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundColor(.brown)
                
                Text(formattedTotalTime)
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 14)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
    }
    
    private var stageProgressCard: some View {
        VStack(spacing: 14) {
            Text("Stage Progress")
                .font(.system(size: 19, weight: .heavy, design: .rounded))
                .foregroundColor(.brown)
            
            HStack(spacing: 9) {
                ForEach(1...totalStages, id: \.self) { stage in
                    VStack(spacing: 6) {
                        Text("\(stage)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.brown.opacity(0.8))
                        
                        ZStack {
                            Circle()
                                .fill(resultStageColor(stage))
                                .frame(width: 27, height: 27)
                                .shadow(
                                    color: resultStageShadow(stage),
                                    radius: 3,
                                    x: 0,
                                    y: 2
                                )
                            
                            if skippedStages.contains(stage) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 13, weight: .heavy))
                                    .foregroundColor(.white)
                            } else if clearedStages.contains(stage) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 13, weight: .heavy))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
    }
    
    private var achievementBadge: some View {
        HStack(spacing: 10) {
            Image(systemName: achievementIcon)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(achievementIconColor)
            
            Text(achievementText)
                .font(.system(size: 16, weight: .heavy, design: .rounded))
                .foregroundColor(.brown)
            
            Image(systemName: "sparkle")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.yellow)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 18)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.yellow.opacity(0.20),
                            Color.orange.opacity(0.10)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.orange.opacity(0.22), lineWidth: 1.5)
                )
        )
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.white.opacity(0.96))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.orange.opacity(0.18), lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.10), radius: 6, x: 0, y: 4)
    }
}

// MARK: - Buttons

extension ResultView {
    
    private var bottomButtons: some View {
        HStack(spacing: 12) {
            Button {
                goToSettings = true
            } label: {
                HStack(spacing: 7) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 19, weight: .heavy))
                    
                    Text("Play Again")
                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 21)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.72, blue: 0.05),
                                    Color(red: 1.0, green: 0.50, blue: 0.02)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                )
                .shadow(color: .orange.opacity(0.34), radius: 6, x: 0, y: 4)
            }
            
            Button {
                goToHome = true
            } label: {
                HStack(spacing: 7) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 19, weight: .heavy))
                    
                    Text("Home")
                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                }
                .foregroundColor(.brown)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 21)
                        .fill(Color.white.opacity(0.96))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 21)
                        .stroke(Color.orange.opacity(0.28), lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.10), radius: 5, x: 0, y: 3)
            }
        }
    }
}

// MARK: - Decoration

extension ResultView {
    
    private var sunburstLayer: some View {
        ZStack {
            ForEach(0..<14, id: \.self) { index in
                Rectangle()
                    .fill(Color.white.opacity(0.12))
                    .frame(width: 28, height: 460)
                    .rotationEffect(.degrees(Double(index) * 13 - 85))
                    .offset(y: -210)
            }
        }
        .blur(radius: 0.5)
    }
    
    private var confettiLayer: some View {
        ZStack {
            ForEach(0..<34, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(confettiColor(index))
                    .frame(
                        width: CGFloat(5 + (index % 3) * 2),
                        height: CGFloat(10 + (index % 4) * 2)
                    )
                    .rotationEffect(.degrees(Double(index * 29)))
                    .position(
                        x: CGFloat((index * 47) % 360) + 12,
                        y: CGFloat((index * 59) % 250) + 12
                    )
                    .opacity(index % 5 == 0 ? 0.45 : 0.85)
            }
        }
    }
}

// MARK: - Helpers

extension ResultView {
    
    private var formattedTotalTime: String {
        let minutes = totalTime / 60
        let seconds = totalTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var scoreRankText: String {
        if stagesCleared == totalStages {
            return "PERFECT!"
        } else if stagesCleared >= 6 {
            return "GREAT JOB!"
        } else if stagesCleared >= 4 {
            return "GOOD TRY!"
        } else {
            return "KEEP GOING!"
        }
    }
    
    private var scoreBadgeColor: Color {
        if stagesCleared == totalStages {
            return .pink.opacity(0.88)
        } else if stagesCleared >= 6 {
            return .pink.opacity(0.88)
        } else if stagesCleared >= 4 {
            return .orange.opacity(0.88)
        } else {
            return .red.opacity(0.88)
        }
    }
    
    private var achievementText: String {
        if stagesCleared == totalStages {
            return "All stages cleared!"
        } else if skippedStages.count > 0 {
            return "\(skippedStages.count) stage\(skippedStages.count == 1 ? "" : "s") missed!"
        } else {
            return "\(totalStages - stagesCleared) stages left to master!"
        }
    }
    
    private var achievementIcon: String {
        if stagesCleared == totalStages {
            return "party.popper.fill"
        } else if skippedStages.count > 0 {
            return "xmark.circle.fill"
        } else {
            return "star.fill"
        }
    }
    
    private var achievementIconColor: Color {
        if stagesCleared == totalStages {
            return .orange
        } else if skippedStages.count > 0 {
            return .red
        } else {
            return .yellow
        }
    }
    
    private func resultStageColor(_ stage: Int) -> Color {
        if skippedStages.contains(stage) {
            return .red
        } else if clearedStages.contains(stage) {
            return .green
        } else {
            return Color.gray.opacity(0.25)
        }
    }
    
    private func resultStageShadow(_ stage: Int) -> Color {
        if skippedStages.contains(stage) {
            return .red.opacity(0.28)
        } else if clearedStages.contains(stage) {
            return .green.opacity(0.25)
        } else {
            return .clear
        }
    }
    
    private func confettiColor(_ index: Int) -> Color {
        let colors: [Color] = [
            .yellow,
            .pink,
            .blue,
            .green,
            .orange,
            .purple,
            .white
        ]
        
        return colors[index % colors.count]
    }
}

#Preview {
    NavigationStack {
        ResultView(
            score: 780,
            stagesCleared: 4,
            totalStages: 8,
            totalTime: 12,
            clearedStages: [1, 2, 4, 5],
            skippedStages: [3, 6, 7, 8]
        )
    }
}
