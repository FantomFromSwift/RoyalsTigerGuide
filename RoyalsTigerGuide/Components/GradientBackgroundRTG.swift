import SwiftUI

struct GradientBackgroundRTG: View {
    @AppStorage("selectedThemeRTG") private var selectedTheme = "default"
    var body: some View {
        ZStack {
            ColorThemeRTG.backgroundGradient
                .ignoresSafeArea()

            Circle()
                .fill(ColorThemeRTG.primaryOrange.opacity(0.06))
                .frame(width: adaptyW(300), height: adaptyW(300))
                .blur(radius: adaptyW(80))
                .offset(x: adaptyW(-100), y: adaptyH(-200))

            Circle()
                .fill(ColorThemeRTG.secondaryGold.opacity(0.04))
                .frame(width: adaptyW(250), height: adaptyW(250))
                .blur(radius: adaptyW(70))
                .offset(x: adaptyW(120), y: adaptyH(300))

            Circle()
                .fill(ColorThemeRTG.emeraldAccent.opacity(0.03))
                .frame(width: adaptyW(200), height: adaptyW(200))
                .blur(radius: adaptyW(60))
                .offset(x: adaptyW(80), y: adaptyH(-100))
        }
    }
}
