//
// CardTotalsView.swift
// Aspire Budgeting
//

import SwiftUI

struct CardTotalsView: View {
  let title: String
  let amount: String
  let startColor: Color
  let endColor: Color
  let shadowColor: Color
  let graphImage: Image

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

        Text(amount)
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
                   amount: "$500",
                   startColor: .greenFondStartColor,
                   endColor: .greenFondEndColor,
                   shadowColor: .greenFondShadowColor,
                   graphImage: .minigraphUp)
  }
}
