//
//  ScoreboardView.swift
//  Prototype
//
//  Created by DONGWOO WON on 4/30/26.
//

import SwiftUI

struct ScoreboardView: View {


//    @ObservedObject var scoreBoard: HighScoreViewModel

    var body: some View {
        ZStack {
            Color.purple.opacity(0.15)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Scoreboard")
                    .font(.largeTitle)
                    .bold()

                Text("Scores will be displayed here.")


                List {
                    //ForEach(scores)
                }

            }
        }
        .navigationTitle("Scoreboard")
    }
}

#Preview {
    ScoreboardView()
}
