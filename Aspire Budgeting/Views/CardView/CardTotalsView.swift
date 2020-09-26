//
// CardTotalsView.swift
// Aspire Budgeting
//

import SwiftUI

struct CardTotalsView: View {
    let title: String
    let amount: AspireNumber

    var startColor: Color {
        amount.isNegative ? .redPinkFondStartColor : .greenFondStartColor
    }

    var endColor: Color {
        amount.isNegative ? .redPinkFondEndColor : .greenFondEndColor
    }

    var shadowColor: Color {
        amount.isNegative ? .redPinkFondShadowColor : .greenFondShadowColor
    }

    var graphImage: Image {
        amount.isNegative ? .minigraphDown : .minigraphUp
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.fondGradientFrom(startColor: startColor, endColor: endColor))
                .cornerRadius(10)
                .shadow(color: shadowColor, radius: 2, x: 0, y: 0)

            VStack(alignment: .leading) {
                HStack {
                    Text(title)
                        .font(.karlaRegular(size: 16))
                        .foregroundColor(.white)
                        .padding(.leading)
                    Spacer()
                    graphImage
                        .padding(.trailing)
                        .foregroundColor(.white)
                }

                Text(amount.stringValue)
                    .padding(.leading)
                    .font(.karlaBold(size: 20))
                    .foregroundColor(.white)

                Text("accross all categories below")
                    .padding(.leading)
                    .font(.karlaRegular(size: 10))
                    .foregroundColor(.white)
            }
        }
    }
}

struct CardTotalsView_Previews: PreviewProvider {
    static var previews: some View {
        CardTotalsView(title: "Budgeted",
                       amount: AspireNumber(stringValue: "$500"))
    }
}
