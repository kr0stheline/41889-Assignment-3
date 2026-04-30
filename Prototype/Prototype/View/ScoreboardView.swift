//
//  ScoreboardView.swift
//  Prototype
//
//  Created by DONGWOO WON on 4/30/26.
//

import SwiftUI

struct ScoreboardView: View {
<<<<<<< Updated upstream
=======
    @ObservedObject var scoreBoard: HighScoreViewModel
>>>>>>> Stashed changes
    var body: some View {
        ZStack {
            Color.purple.opacity(0.15)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Scoreboard")
                    .font(.largeTitle)
                    .bold()

                Text("Scores will be displayed here.")
<<<<<<< Updated upstream
=======
                List {
                    //ForEach(scores)
                }
>>>>>>> Stashed changes
            }
        }
        .navigationTitle("Scoreboard")
    }
}

#Preview {
    ScoreboardView()
}
