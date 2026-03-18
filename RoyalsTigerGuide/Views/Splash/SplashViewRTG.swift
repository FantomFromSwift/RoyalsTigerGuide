import SwiftUI

struct SplashViewRTG: View {
    @State private var logoScale: CGFloat = 0.3
    @State private var logoOpacity: Double = 0
    @State private var glowRadius: CGFloat = 0
    @State private var titleOffset: CGFloat = 30
    @State private var titleOpacity: Double = 0
    @State private var ringRotation: Double = 0
    @State private var isFinished = false

    var onFinish: () -> Void

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            Circle()
                .stroke(
                    AngularGradient(
                        colors: [
                            ColorThemeRTG.primaryOrange.opacity(0.5),
                            ColorThemeRTG.secondaryGold.opacity(0.3),
                            ColorThemeRTG.primaryOrange.opacity(0.1),
                            ColorThemeRTG.secondaryGold.opacity(0.5)
                        ],
                        center: .center
                    ),
                    lineWidth: adaptyW(3)
                )
                .frame(width: adaptyW(180), height: adaptyW(180))
                .rotationEffect(.degrees(ringRotation))

            VStack(spacing: adaptyH(20)) {
                ZStack {
                    Circle()
                        .fill(ColorThemeRTG.primaryOrange.opacity(0.15))
                        .frame(width: adaptyW(140), height: adaptyW(140))
                        .blur(radius: glowRadius)

                    Image("themeOne")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: adaptyW(120), height: adaptyW(120))
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [ColorThemeRTG.primaryOrange, ColorThemeRTG.secondaryGold],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: adaptyW(3)
                                )
                        )
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                VStack(spacing: adaptyH(6)) {
                    Text("RoyalsTiger")
                        .font(.system(size: adaptyW(32), weight: .heavy))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [ColorThemeRTG.secondaryGold, ColorThemeRTG.primaryOrange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("Guide")
                        .font(.system(size: adaptyW(18), weight: .medium))
                        .foregroundStyle(ColorThemeRTG.textSecondary)
                        .tracking(adaptyW(6))
                }
                .offset(y: titleOffset)
                .opacity(titleOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            withAnimation(.easeInOut(duration: 1.2).delay(0.4)) {
                glowRadius = adaptyW(30)
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
                titleOffset = 0
                titleOpacity = 1.0
            }
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                ringRotation = 360
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onFinish()
            }
        }
    }
}
