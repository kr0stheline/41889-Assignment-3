//
//  TutorialView.swift
//  Prototype
//
//  Created by DONGWOO WON on 4/30/26.
//
import SwiftUI

import SwiftUI

struct TutorialView: View {
    var body: some View {
        ZStack {
            Color.blue.opacity(0.15)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Tutorial")
                    .font(.largeTitle)
                    .bold()

                
            }
            .padding()
        }
        .navigationTitle("Tutorial")
    }
}
