import SwiftUI

struct NavButton {
    var text: String
}

struct ButtonViewLight: View {
    
    let text: String
    
    var body: some View {
        Text("\(text)")
            .font(.system(size: 24))
            .fontWeight(.bold)
            .frame(width: 100, height: 50, alignment: .center)
            .foregroundStyle(.primary)
            .foregroundColor(.primary)
            .background(.ultraThinMaterial)
    }
}

struct ButtonViewDark: View {
    
    let text: String
    
    var body: some View {
        Text("\(text)")
            .font(.system(size: 24))
            .fontWeight(.bold)
            .frame(width: 100, height: 50, alignment: .center)
            .foregroundStyle(.primary)
            .background(.regularMaterial)
    }
}
