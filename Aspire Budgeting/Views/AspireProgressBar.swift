//
// AspireProgressBar.swift
// Aspire Budgeting
//

import SwiftUI

struct AspireProgressBar: View {
  enum BarType {
    case minimal, detailed
  }

  let barType: BarType
  let shadowColor: Color
  let tintColor: Color
  let progressFactor: Double

  private var displayProgressFactor: CGFloat {
    if progressFactor == 0 && barType == .minimal {
      return 0
    }

    if progressFactor == 0 && barType == .detailed {
      return 0.1
    }

    return CGFloat(progressFactor)
  }

  private var barHeight: CGFloat {
    barType == .detailed ? 12 : 6
  }

  private var barColor: Color {
    barType == .detailed ? Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)) : tintColor
  }

    var body: some View {
      ZStack(alignment: .leading) {
        GeometryReader { geo in
          RoundedRectangle(cornerRadius: 6)
            .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.12)))

          RoundedRectangle(cornerRadius: 6)
            .strokeBorder(shadowColor, lineWidth: 0.5)

          RoundedRectangle(cornerRadius: 6)
            .fill(barColor)
            .frame(width: geo.frame(in: .local).width * displayProgressFactor)
            .shadow(color: Color(#colorLiteral(red: 0.8198039531707764, green: 0.8295795917510986, blue: 0.8882334232330322, alpha: 0.5033401250839233))
                      .opacity(barType == .detailed ? 1 :0.6),
                    radius: 14,
                    x: 0,
                    y: 12)
        }

        if barType == .detailed {
          Text("\(String(format: "%.1f", progressFactor * 100))%")
            .font(.karlaBold(size: 10))
            .foregroundColor(tintColor)
            .lineSpacing(3)
            .padding(.leading, 10)
        }
      }
      .compositingGroup()
      .frame(height: barHeight)
      .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: 1, x: 0, y: 2)
    }
}

struct AspireProgressBar_Previews: PreviewProvider {
    static var previews: some View {
      AspireProgressBar(barType: .detailed,
                        shadowColor: .gray,
                        tintColor: .blue,
                        progressFactor: 0.4)
    }
}
