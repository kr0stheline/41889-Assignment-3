//
//  ResultView.swift
//  Prototype
//
//  Created by DONGWOO WON on 4/30/26.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedTopic: String? = nil
    @State private var selectedDifficulty: String? = nil
    
    var body: some View {
        GeometryReader { geo in
            
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack {
                
                // MARK: - Background
                Image("settingBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: w * 1.04, height: h * 1.08)
                    .position(x: w * 0.5, y: h * 0.5)
                    .ignoresSafeArea()
                
                // MARK: - Back Button
                CircleButton(systemName: "arrow.left") {
                    dismiss()
                }
                .position(x: w * 0.105, y: h * 0.070)
                
                // MARK: - Gear Button
                CircleButton(systemName: "gearshape.fill") {
                    print("Gear tapped")
                }
                .position(x: w * 0.895, y: h * 0.070)
                
                // MARK: - Title
                Text("Game Settings")
                    .font(.system(
                        size: w * 0.092,
                        weight: .heavy,
                        design: .rounded
                    ))
                
                    .foregroundColor(Color(red: 0.31, green: 0.23, blue: 0.17))
                    .position(x: w * 0.5, y: h * 0.13)
                
                // MARK: - Topic Guide
                Text("Choose a topic to practice!")
                    .font(.system(
                        size: w * 0.040,
                        weight: .heavy,
                        design: .rounded
                    ))
                    .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.18))
                    .padding(.horizontal, w * 0.070)
                    .padding(.vertical, h * 0.010)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.90, green: 0.80, blue: 0.70).opacity(0.92))
                    )
                    .position(x: w * 0.5, y: h * 0.2)
                
                // MARK: - Topic Cards Row 1
                TopicImageButton(
                    imageName: "btnAnimals",
                    isSelected: selectedTopic == "Animals",
                    hasSelection: selectedTopic != nil
                ) {
                    selectedTopic = "Animals"
                }
                .frame(width: w * 0.415, height: h * 0.175)
                .position(x: w * 0.32, y: h * 0.325)
                
                TopicImageButton(
                    imageName: "btnFruits",
                    isSelected: selectedTopic == "Fruits",
                    hasSelection: selectedTopic != nil
                ) {
                    selectedTopic = "Fruits"
                }
                .frame(width: w * 0.415, height: h * 0.175)
                .position(x: w * 0.68, y: h * 0.325)
                
                // MARK: - Topic Cards Row 2
                TopicImageButton(
                    imageName: "btnNature",
                    isSelected: selectedTopic == "Nature",
                    hasSelection: selectedTopic != nil
                ) {
                    selectedTopic = "Nature"
                }
                .frame(width: w * 0.415, height: h * 0.175)
                .position(x: w * 0.32, y: h * 0.51)
                
                TopicImageButton(
                    imageName: "btnScience",
                    isSelected: selectedTopic == "Science",
                    hasSelection: selectedTopic != nil
                ) {
                    selectedTopic = "Science"
                }
                .frame(width: w * 0.415, height: h * 0.175)
                .position(x: w * 0.68, y: h * 0.51)
                
                // MARK: - Difficulty Guide
                Text("After that, choose a difficulty!")
                    .font(.system(
                        size: w * 0.037,
                        weight: .heavy,
                        design: .rounded
                    ))
                    .foregroundColor(Color(red: 0.33, green: 0.25, blue: 0.18))
                    .padding(.horizontal, w * 0.060)
                    .padding(.vertical, h * 0.009)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.94, green: 0.86, blue: 0.78).opacity(0.94))
                    )
                    .position(x: w * 0.5, y: h * 0.63)
                
                // MARK: - Difficulty Panel Background
                RoundedRectangle(cornerRadius: 36)
                    .fill(Color.white.opacity(0.91))
                    .frame(width: w * 0.88, height: h * 0.235)
                    .position(x: w * 0.5, y: h * 0.782)
                
                // MARK: - Difficulty Title
                Text("Difficulty")
                    .font(.system(
                        size: w * 0.055,
                        weight: .heavy,
                        design: .rounded
                    ))
                    .foregroundColor(Color(red: 0.31, green: 0.23, blue: 0.17))
                    .position(x: w * 0.5, y: h * 0.69)
                
                // MARK: - Difficulty Cards
                DifficultyImageButton(
                    imageName: "btnEasy",
                    isSelected: selectedDifficulty == "Easy",
                    hasSelection: selectedDifficulty != nil
                ) {
                    selectedDifficulty = "Easy"
                }
                .frame(width: w * 0.265, height: h * 0.170)
                .position(x: w * 0.265, y: h * 0.795)
                
                DifficultyImageButton(
                    imageName: "btnMedium",
                    isSelected: selectedDifficulty == "Medium",
                    hasSelection: selectedDifficulty != nil
                ) {
                    selectedDifficulty = "Medium"
                }
                .frame(width: w * 0.265, height: h * 0.170)
                .position(x: w * 0.500, y: h * 0.795)
                
                DifficultyImageButton(
                    imageName: "btnHard",
                    isSelected: selectedDifficulty == "Hard",
                    hasSelection: selectedDifficulty != nil
                ) {
                    selectedDifficulty = "Hard"
                }
                .frame(width: w * 0.265, height: h * 0.170)
                .position(x: w * 0.735, y: h * 0.795)
                
                // MARK: - Start Button
                Button {
                    print("Start tapped")
                    print("Topic:", selectedTopic ?? "None")
                    print("Difficulty:", selectedDifficulty ?? "None")
                } label: {
                    HStack(spacing: w * 0.045) {
                        Image(systemName: "play.fill")
                            .font(.system(size: w * 0.085, weight: .bold))
                        
                        Text("Start")
                            .font(.system(
                                size: w * 0.082,
                                weight: .heavy,
                                design: .rounded
                            ))
                    }
                    .foregroundColor(.white)
                    .frame(width: w * 0.72, height: h * 0.086)
                    .background(
                        RoundedRectangle(cornerRadius: 36)
                            .fill(Color(red: 0.18, green: 0.58, blue: 1.0))
                    )
                    .shadow(
                        color: Color.blue.opacity(0.28),
                        radius: 0,
                        x: 0,
                        y: 8
                    )
                }
                .buttonStyle(.plain)
                .position(x: w * 0.5, y: h * 0.927)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Topic Image Button

struct TopicImageButton: View {
    
    let imageName: String
    let isSelected: Bool
    let hasSelection: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaleEffect(scaleValue)
                .opacity(opacityValue)
                .animation(.spring(response: 0.25, dampingFraction: 0.75), value: isSelected)
                .animation(.spring(response: 0.25, dampingFraction: 0.75), value: hasSelection)
        }
        .buttonStyle(.plain)
    }
    
    private var scaleValue: CGFloat {
        if isSelected {
            return 1.06
        } else if hasSelection {
            return 0.90
        } else {
            return 1.0
        }
    }
    
    private var opacityValue: Double {
        if isSelected {
            return 1.0
        } else if hasSelection {
            return 0.65
        } else {
            return 1.0
        }
    }
}

// MARK: - Difficulty Image Button

struct DifficultyImageButton: View {
    
    let imageName: String
    let isSelected: Bool
    let hasSelection: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaleEffect(scaleValue)
                .opacity(opacityValue)
                .animation(.spring(response: 0.25, dampingFraction: 0.75), value: isSelected)
                .animation(.spring(response: 0.25, dampingFraction: 0.75), value: hasSelection)
        }
        .buttonStyle(.plain)
    }
    
    private var scaleValue: CGFloat {
        if isSelected {
            return 1.07
        } else if hasSelection {
            return 0.88
        } else {
            return 1.0
        }
    }
    
    private var opacityValue: Double {
        if isSelected {
            return 1.0
        } else if hasSelection {
            return 0.65
        } else {
            return 1.0
        }
    }
}

// MARK: - Circle Button

struct CircleButton: View {
    
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .font(.system(size: 23, weight: .heavy))
                .foregroundColor(Color(red: 0.27, green: 0.23, blue: 0.20))
                .frame(width: 58, height: 58)
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.95))
                        .shadow(
                            color: .black.opacity(0.12),
                            radius: 4,
                            x: 0,
                            y: 3
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SettingView()
    }
}
