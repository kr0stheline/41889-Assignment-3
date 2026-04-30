//
//  CharacterView.swift
//  Prototype
//
//  Created by DONGWOO WON on 4/30/26.
//
import SwiftUI

struct CharacterView: View {
    let imageName: String

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
    }
}
