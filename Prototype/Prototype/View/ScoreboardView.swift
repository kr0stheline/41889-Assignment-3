//
//  ScoreboardView.swift
//  Prototype
//
//  Created by DONGWOO WON on 4/30/26.
//

import SwiftUI

struct ScoreboardView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var scoreBoard: HighScoreViewModel
    
    var body: some View {
        ZStack {
            celebrationBackground
            
            VStack(spacing: 16) {
                backButton
                
                titleBanner
                
                Text("Best Players")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.brown)
                
                topScoreCard(score: scoreBoard.topScore ?? 0)
                
                leaderboardList
                
                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.top, 16)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var backButton: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.brown)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.95))
                            .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 3)
                    )
            }
            
            Spacer()
        }
    }
    
    private var titleBanner: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 1.0, green: 0.86, blue: 0.05),
                            Color(red: 1.0, green: 0.58, blue: 0.02)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 78)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.65), lineWidth: 2)
                )
                .shadow(color: .orange.opacity(0.45), radius: 8, x: 0, y: 5)
            
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .foregroundColor(.white)
                    .font(.system(size: 23, weight: .bold))
                
                Text("Scoreboard")
                    .font(.system(size: 38, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .orange, radius: 1, x: 2, y: 2)
                
                Image(systemName: "sparkles")
                    .foregroundColor(.white)
                    .font(.system(size: 23, weight: .bold))
            }
        }
    }
    
    private func topScoreCard(score: Int) -> some View {
        HStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(Color.yellow.opacity(0.28))
                    .frame(width: 105, height: 105)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 62))
                    .foregroundColor(.orange)
                    .shadow(color: .yellow.opacity(0.5), radius: 4, x: 0, y: 3)
            }
            
            VStack(spacing: 8) {
                Text("TOP SCORE")
                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 7)
                    .background(
                        Capsule()
                            .fill(Color.pink)
                    )
                
                Text(score.formatted())
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundColor(.green)
                    .minimumScaleFactor(0.65)
                    .lineLimit(1)
                
                Text(score == 0 ? "PLAY TO START!" : "NEW BEST!")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundColor(.pink)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
    }
    
    private var leaderboardList: some View {
        VStack(spacing: 11) {
            if scoreBoard.scores.isEmpty {
                emptyScoreView
            } else {
                ForEach(Array(scoreBoard.scores.prefix(5).enumerated()), id: \.element.id) { index, result in
                    LeaderboardRow(
                        rank: index + 1,
                        result: result
                    )
                }
            }
        }
    }
    
    private var emptyScoreView: some View {
        VStack(spacing: 12) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 54))
                .foregroundColor(.orange)
            
            Text("No scores yet!")
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .foregroundColor(.brown)
            
            Text("Play a game to save your first score.")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.brown.opacity(0.75))
                .multilineTextAlignment(.center)
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 26)
            .fill(Color(red: 1.0, green: 0.96, blue: 0.86))
            .overlay(
                RoundedRectangle(cornerRadius: 26)
                    .stroke(Color.orange.opacity(0.25), lineWidth: 2)
            )
            .shadow(color: .brown.opacity(0.12), radius: 5, x: 0, y: 4)
    }
    
    private var celebrationBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.62, blue: 1.0),
                    Color(red: 0.62, green: 0.88, blue: 1.0),
                    Color.white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
                ConfettiView()
                    .frame(height: 170)
                Spacer()
            }
            
            RoundedRectangle(cornerRadius: 36)
                .fill(Color.white.opacity(0.90))
                .padding(.horizontal, 14)
                .padding(.top, 92)
                .padding(.bottom, 24)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        }
    }
}

struct LeaderboardRow: View {
    let rank: Int
    let result: GameResult
    
    var body: some View {
        HStack(spacing: 12) {
            rankBadge
            
            if rank == 1 {
                Image(systemName: "crown.fill")
                    .foregroundColor(.orange)
                    .font(.system(size: 21))
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(result.playerName)
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundColor(.brown)
                    .lineLimit(1)
                
                Text("\(result.topic) • \(result.difficulty) • \(result.correctCount) correct")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundColor(.brown.opacity(0.65))
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(result.score.formatted())
                .font(.system(size: 21, weight: .heavy, design: .rounded))
                .foregroundColor(.green)
                .lineLimit(1)
            
            Image(systemName: "star.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 21))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(rank == 1 ? Color.yellow.opacity(0.28) : Color(red: 1.0, green: 0.97, blue: 0.90))
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(rank == 1 ? Color.orange : Color.orange.opacity(0.18), lineWidth: rank == 1 ? 2 : 1)
                )
                .shadow(color: .brown.opacity(0.10), radius: 4, x: 0, y: 3)
        )
    }
    
    private var rankBadge: some View {
        ZStack {
            Circle()
                .fill(badgeColor)
                .frame(width: 46, height: 46)
                .shadow(color: .black.opacity(0.13), radius: 3, x: 0, y: 2)
            
            Text("\(rank)")
                .font(.system(size: 23, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
        }
    }
    
    private var badgeColor: Color {
        switch rank {
        case 1:
            return .orange
        case 2:
            return .gray
        case 3:
            return .brown
        case 4:
            return .blue
        default:
            return .purple
        }
    }
}

struct ConfettiView: View {
    let pieces: [ConfettiPiece] = [
        ConfettiPiece(x: 30, y: 30, color: .yellow, rotation: 20),
        ConfettiPiece(x: 85, y: 70, color: .pink, rotation: -18),
        ConfettiPiece(x: 145, y: 35, color: .green, rotation: 35),
        ConfettiPiece(x: 210, y: 85, color: .orange, rotation: -25),
        ConfettiPiece(x: 275, y: 45, color: .purple, rotation: 10),
        ConfettiPiece(x: 335, y: 80, color: .yellow, rotation: -30),
        ConfettiPiece(x: 55, y: 125, color: .cyan, rotation: 15),
        ConfettiPiece(x: 180, y: 130, color: .yellow, rotation: -20),
        ConfettiPiece(x: 310, y: 125, color: .pink, rotation: 28)
    ]
    
    var body: some View {
        GeometryReader { _ in
            ForEach(pieces) { piece in
                RoundedRectangle(cornerRadius: 3)
                    .fill(piece.color)
                    .frame(width: 15, height: 25)
                    .rotationEffect(.degrees(piece.rotation))
                    .position(x: piece.x, y: piece.y)
                
                Image(systemName: "sparkle")
                    .foregroundColor(.white.opacity(0.9))
                    .font(.system(size: 18))
                    .position(x: piece.x + 18, y: piece.y + 16)
            }
        }
    }
}

struct ConfettiPiece: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let color: Color
    let rotation: Double
}

#Preview {
    ScoreboardView(scoreBoard: HighScoreViewModel())
}
