//
//  ScoreboardView.swift
//  Prototype
//

import SwiftUI

struct ScoreboardView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var scoreBoard: HighScoreViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white.ignoresSafeArea()
                
                Image("scoreboardBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height * 1.05
                    )
                    .offset(y: -geo.size.height * 0.01)
                    .clipped()
                    .ignoresSafeArea()
                
                backButton
                    .position(
                        x: geo.size.width * 0.125,
                        y: geo.size.height * 0.220
                    )
                
                topScoreText(geo: geo)
                
                leaderboardRows(geo: geo)
                
                bottomSummary(geo: geo)

                if let errorMessage = scoreBoard.storageErrorMessage {
                    Text(errorMessage)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.red)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.9))
                        )
                        .position(
                            x: geo.size.width * 0.5,
                            y: geo.size.height * 0.94
                        )
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.brown)
                .frame(width: 38, height: 38)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.92))
                        .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                )
        }
    }
    
    private func topScoreText(geo: GeometryProxy) -> some View {
        let topScore = scoreBoard.topScore ?? 0
        
        return Text(topScore == 0 ? "-" : topScore.formatted())
            .font(.system(size: geo.size.width * 0.088, weight: .heavy, design: .rounded))
            .foregroundColor(Color(red: 0.10, green: 0.76, blue: 0.25))
            .lineLimit(1)
            .minimumScaleFactor(0.55)
            .frame(width: geo.size.width * 0.34)
            .position(
                x: geo.size.width * 0.650,
                y: geo.size.height * 0.34
            )
    }
    
    private func leaderboardRows(geo: GeometryProxy) -> some View {
        let results = Array(scoreBoard.scores.prefix(5).enumerated())
        
        return ZStack {
            if results.isEmpty {
                emptyScorePlaceholder(geo: geo)
            } else {
                ForEach(results, id: \.element.id) { index, result in
                    leaderboardRow(
                        rank: index + 1,
                        result: result,
                        geo: geo
                    )
                }
            }
        }
    }
    
    private func leaderboardRow(
        rank: Int,
        result: GameResult,
        geo: GeometryProxy
    ) -> some View {
        
       
        let rowYPositions: [CGFloat] = [
            0.480,
            0.545,
            0.61,
            0.675,
            0.740
        ]
        
        let y = geo.size.height * rowYPositions[rank - 1]
        
        return ZStack {
            Text(result.playerName)
                .font(.system(size: geo.size.width * 0.05, weight: .heavy, design: .rounded))
                .foregroundColor(.brown)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
                .frame(width: geo.size.width * 0.34, alignment: .leading)
                .position(
                    x: geo.size.width * 0.465,
                    y: y
                )
            
            Text(result.score.formatted())
                .font(.system(size: geo.size.width * 0.055, weight: .heavy, design: .rounded))
                .foregroundColor(Color(red: 0.10, green: 0.75, blue: 0.25))
                .lineLimit(1)
                .minimumScaleFactor(0.60)
                .frame(width: geo.size.width * 0.16, alignment: .trailing)
                .position(
                    x: geo.size.width * 0.730,
                    y: y
                )
        }
    }
    
    private func emptyScorePlaceholder(geo: GeometryProxy) -> some View {
        Text("No scores yet!")
            .font(.system(size: geo.size.width * 0.045, weight: .heavy, design: .rounded))
            .foregroundColor(.brown)
            .position(
                x: geo.size.width * 0.50,
                y: geo.size.height * 0.600
            )
    }
    
    private func bottomSummary(geo: GeometryProxy) -> some View {
        let totalGames = scoreBoard.scores.count
        let bestScore = scoreBoard.topScore ?? 0
        let averageScore = totalGames == 0
            ? 0
            : scoreBoard.scores.map { $0.score }.reduce(0, +) / totalGames
        
        return VStack(spacing: 8) {
            Text("Your Progress")
                .font(.system(size: geo.size.width * 0.05,
                              weight: .heavy, design: .rounded))
                .foregroundColor(.brown)
            
            HStack(spacing: 8) {
                SummaryStatBox(
                    icon: "gamecontroller.fill",
                    title: "Games",
                    value: "\(totalGames)",
                    screenWidth: geo.size.width*1.2
                    
                )
                
                SummaryStatBox(
                    icon: "star.fill",
                    title: "Best",
                    value: bestScore == 0 ? "-" : bestScore.formatted(),
                    screenWidth: geo.size.width
                )
                
                SummaryStatBox(
                    icon: "chart.bar.fill",
                    title: "Avg",
                    value: averageScore == 0 ? "-" : averageScore.formatted(),
                    screenWidth: geo.size.width
                )
            }
        }
        .padding(.horizontal, geo.size.width * 0.05)
        .padding(.vertical, geo.size.height * 0.02)
        .frame(width: geo.size.width * 0.9)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.52))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.orange.opacity(0.20), lineWidth: 1.3)
                )
        )
        .position(
            x: geo.size.width * 0.50,
            y: geo.size.height * 0.865
        )
    }
}

struct SummaryStatBox: View {
    let icon: String
    let title: String
    let value: String
    let screenWidth: CGFloat
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.system(size: screenWidth * 0.028, weight: .bold))
                .foregroundColor(.orange)
            
            Text(title)
                .font(.system(size: screenWidth * 0.03, weight: .bold, design: .rounded))
                .foregroundColor(.brown.opacity(0.75))
            
            Text(value)
                .font(.system(size: screenWidth * 0.03, weight: .heavy, design: .rounded))
                .foregroundColor(.green)
                .lineLimit(1)
                .minimumScaleFactor(0.55)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 13)
                .fill(Color.white.opacity(0.55))
        )
    }
}

#Preview {
    ScoreboardView(scoreBoard: HighScoreViewModel())
}
