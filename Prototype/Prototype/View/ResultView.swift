//
//  ResultView.swift
//  Prototype
//
//  Created by DONGWOO WON on 4/30/26.
//


import SwiftUI

struct ResultView: View {
    var body: some View {
        VStack(spacing: 20) {

            Text("Amazing!")
                .font(.largeTitle)

            
            VStack {
                Text("Total Score")
                Text("12,450")
                    .font(.title)
            }
            .padding()
           
            

            // Stats
            HStack {
                VStack {
                 
                }
                Spacer()
                VStack {
                  
                }
                Spacer()
                VStack {
                   
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .border(Color.gray)

          
            HStack {
                
            }
            .padding()
            .border(Color.gray)

          
            HStack {
                Button("Play Again") {
                }
                Spacer()
                Button("Home") {
                }
            }
        }
        .padding()
    }
}

#Preview {
    ResultView()
}
