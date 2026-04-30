//
//  HomeView.swift
//  Prototype
//
//  Created by DONGWOO WON on 4/30/26.
//
import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.white.ignoresSafeArea()

                Image("homeBackground")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 1.08,
                           height: geo.size.height * 1.08)
                    .position(
                        x: geo.size.width / 2,
                        y: geo.size.height * 0.53
                    )
                    .ignoresSafeArea()
                
                
                VStack(spacing: 0) {
                    Spacer().frame(height: geo.size.height * 0.08)

                    Image("title")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .scaleEffect(1.8)
                    
                    Spacer().frame(height: geo.size.height * 0.04)

                    HStack(spacing: -10) {
                        CharacterView(imageName: "dino")
                            .frame(width: geo.size.width * 0.5)
                            .scaleEffect(1.4)

                        CharacterView(imageName: "rabbit")
                            .frame(width: geo.size.width * 0.45)
                            .scaleEffect(1.4)
                    }
                    .offset(y: 30)

                    Spacer().frame(height: geo.size.height * 0.03)

                    NavigationLink {
                        GameView()
                    } label: {
                        Image("startButton")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width * 0.78)
                    }

                    Spacer().frame(height: geo.size.height * 0.035)

                    HStack(spacing: geo.size.width * 0.08) {
                        NavigationLink {
                            ScoreboardView()
                        } label: {
                            Image("scoreboardButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.31)
                        }

                        NavigationLink {
                            TutorialView()
                        } label: {
                            Image("tutorialButton")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.31)
                        }
                    }

                    Spacer()
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
