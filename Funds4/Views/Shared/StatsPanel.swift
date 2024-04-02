import Foundation
import SwiftUI

struct StatsPanel: View {
    @Binding var openingBalance: Int
    @Binding var currentBalance: Int
    
    var body: some View {
        ZStack {
            Color(getBackgroundColor())
            
            VStack {
                Spacer()
                
                HStack {
                    Image(systemName: getArrowName())
                        .font(.largeTitle)
                        .bold()
                    
                    Spacer()
                    Text((currentBalance - openingBalance).asCurrency)
                        .font(.largeTitle)
                        .bold()
                }
                
                Spacer()
                
                HStack {
                    Text(openingBalance.asCurrency)
                    Image(systemName: "arrow.right")
                    Text(currentBalance.asCurrency)
                }.font(.subheadline)
                
                Spacer()
            }
            .foregroundColor(getForegroundColor())
            .padding([.horizontal], 8)
        }
        .cornerRadius(8)
        .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
    }
    
    func getBackgroundColor() -> Color {
        switch (currentBalance - openingBalance).signum() {
        case 1: return Color.Stats.backgroundPositive
        case -1: return Color.Stats.backgroundNegative
        default: return Color.Stats.backgroundZero
        }
    }
    
    func getForegroundColor() -> Color {
        switch (currentBalance - openingBalance).signum() {
        case 1: return Color.Stats.foregroundPositive
        case -1: return Color.Stats.foregroundNegative
        default: return Color.Stats.foregroundZero
        }

    }
    
    func getArrowName() -> String {
        switch (currentBalance - openingBalance).signum() {
        case 1: return "arrow.up.circle.fill"
        case -1: return "arrow.down.circle.fill"
        default: return "arrow.right.circle.fill"
        }
    }
}

#Preview {
    StatsPanel(openingBalance: .constant(0), currentBalance: .constant(5555))
}

#Preview("In Row") {
    VStack {
        HStack {
            StatsPanel(openingBalance: .constant(0), currentBalance: .constant(1))
        }
        
        Spacer()
    }
}
