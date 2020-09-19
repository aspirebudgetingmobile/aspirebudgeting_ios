//
//  CardView.swift
//  Aspire Budgeting
//

import SwiftUI

struct CardView: View {

  let colorInfo: ColorInfo
  let cardViewItem: CardViewItem
  var minY: CGFloat = 0
  var curY: CGFloat = 0

  @State private var showDetails = false

  private let cornerRadius: CGFloat = 24
  private let height: CGFloat = 163

  private let shadowRadius: CGFloat = 14
  private let shadowYOffset: CGFloat = 4

  private var gradient: LinearGradient {

    let startColor = Gradient.Stop(color: colorInfo.gradientStartColor, location: 0)

    let endColor = Gradient.Stop(color: colorInfo.gradientEndColor, location: 1)

    let startPoint = UnitPoint(x: 0.5, y: -0.48)

    let endPoint = UnitPoint(x: -0.46, y: 0.52)

    let gradient = Gradient(stops: [startColor, endColor])
    return LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
  }

  private var offsetY: CGFloat {
    curY < minY ? minY - curY : 0
  }

  var body: some View {
    ZStack(alignment: .top) {
      containerBox
      VStack(alignment: .leading) {
        topRow
        secondRow
        progressBar
        fourthRow
      }.sheet(isPresented: $showDetails) {
        Rectangle()
      }
    }
    .offset(y: offsetY)
  }
}

extension CardView {
  private var containerBox: some View {
    Rectangle()
      .fill(gradient)
      .cornerRadius(cornerRadius)
      .frame(height: height)
  }

  private var topRow: some View {
    HStack {
      ZStack {
        Circle()
          .fill(Color.white)
          .opacity(0.2)
          .frame(width: 32, height: 32)

        Image("moneyBag")
      }.padding(.horizontal, 10)

      Text(cardViewItem.title)
        .font(.nunitoBold(size: 18))
        .foregroundColor(.white)

      Spacer()

      Button(action: {
        self.showDetails.toggle()
      }, label: {
        Text("Details >")
          .font(.karlaRegular(size: 12))
          .lineSpacing(3)
          .foregroundColor(.white)
          .overlay(
            RoundedRectangle(cornerRadius: 14)
              .stroke(Color.white, lineWidth: 1)
              .frame(width: 79, height: 28)
          )
          .padding()
          .padding(.trailing)
      })

    }.padding(.top, 5)
  }

  private var secondRow: some View {
    HStack {
      Text("AVAILABLE")
        .foregroundColor(.white)
        .font(.nunitoRegular(size: 13))
        .lineSpacing(3)
        .padding(.horizontal, 10)

      Spacer()

      Text("BUDGETED")
        .foregroundColor(.white)
        .font(.nunitoRegular(size: 13))
        .lineSpacing(3)
        .padding(.trailing)
    }
  }

  private var progressBar: some View {
    ZStack(alignment: .leading) {
      GeometryReader { geo in
        RoundedRectangle(cornerRadius: 6)
          .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12)))

        RoundedRectangle(cornerRadius: 6)
          .strokeBorder(self.colorInfo.shadowColor, lineWidth: 0.5)

        RoundedRectangle(cornerRadius: 6)
          .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
          .frame(width: geo.frame(in: .local).width *
                  CGFloat(self.cardViewItem.progressFactor == 0 ?
                            0.1 : self.cardViewItem.progressFactor),
                 height: 12)
          .shadow(color: Color(#colorLiteral(red: 0.8198039531707764, green: 0.8295795917510986, blue: 0.8882334232330322, alpha: 0.5033401250839233)), radius: 14, x: 0, y: 12)
      }

      Text("\(String(format: "%.1f", self.cardViewItem.progressFactor * 100))%")
        .font(.custom("Karla Bold", size:10))
        .foregroundColor(self.colorInfo.gradientEndColor)
        .lineSpacing(3)
        .padding(.leading, 10)
    }
    .compositingGroup()
    .frame(height: 12)
    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 1, x: 0, y: 2)
    .padding(.horizontal, 10)
  }

  private var fourthRow: some View {
    HStack {
      Text(self.cardViewItem.lowerBound)
        .foregroundColor(.white)
        .font(.nunitoRegular(size: 13))
        .lineSpacing(3)
        .padding(.horizontal, 10)

      Spacer()

      Text(self.cardViewItem.upperBound)
        .foregroundColor(.white)
        .font(.nunitoRegular(size: 13))
        .lineSpacing(3)
        .padding(.trailing)
    }
  }
}

// MARK: - Internal Types
extension CardView {
  struct ColorInfo {
    let gradientStartColor: Color
    let gradientEndColor: Color
    let shadowColor: Color
  }

  struct CardViewItem {
    let title: String
    let lowerBound: String
    let upperBound: String
    let progressFactor: Double
  }
}

// MARK: - Previews
struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      Group {
        CardView(colorInfo: .init(gradientStartColor: .blueGreenFondStartColor,
                                  gradientEndColor: .blueGreenFondEndColor,
                                  shadowColor: .blueGreenFondShadowColor),
                 cardViewItem: MockProvider.cardViewItems[0])

        CardView(colorInfo: .init(gradientStartColor: .blueFondStartColor,
                                  gradientEndColor: .blueFondEndColor,
                                  shadowColor: .blueFondShadowColor),
                 cardViewItem: MockProvider.cardViewItems[1])
      }
    }
  }
}
