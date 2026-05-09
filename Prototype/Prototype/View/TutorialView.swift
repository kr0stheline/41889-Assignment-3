import SwiftUI

struct TutorialView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Image("tutorial_background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 1.2, height: geometry.size.height * 1.2)
                    .ignoresSafeArea()
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height * 0.45
                    )
                
                // Tutorial guide image
                Image("tutorial_guide")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 1.12)
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height * 0.48
                    )
                
                // Got it button
                Button {
                    dismiss()
                } label: {
                    Image("got_it_button")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.68)
                }
                .buttonStyle(.plain)
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height * 0.95
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        TutorialView()
    }
}
