import SwiftUI

struct BehaviorLabViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Behavior Lab", showBack: true) { dismiss() }

                ScrollView {
                    VStack(spacing: adaptyH(20)) {
                        GlowCardRTG(glowColor: Color(red: 0.6, green: 0.4, blue: 1.0)) {
                            VStack(spacing: adaptyH(8)) {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: adaptyW(32)))
                                    .foregroundStyle(Color(red: 0.6, green: 0.4, blue: 1.0))

                                Text("Adjust environmental factors to predict how tiger behavior changes under different conditions.")
                                    .font(.system(size: adaptyW(13)))
                                    .foregroundStyle(ColorThemeRTG.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(adaptyW(16))
                        }

                        sliderControl(
                            title: "Temperature",
                            value: $viewModel.labTemperature,
                            range: -20...45,
                            unit: "C",
                            icon: "thermometer.medium",
                            color: temperatureColor
                        )

                        sliderControl(
                            title: "Prey Density",
                            value: $viewModel.labPreyDensity,
                            range: 0...100,
                            unit: "%",
                            icon: "hare.fill",
                            color: ColorThemeRTG.emeraldAccent
                        )

                        sliderControl(
                            title: "Territory Size",
                            value: $viewModel.labTerritorySize,
                            range: 20...500,
                            unit: "km2",
                            icon: "map.fill",
                            color: ColorThemeRTG.primaryOrange
                        )

                        sliderControl(
                            title: "Human Activity",
                            value: $viewModel.labHumanActivity,
                            range: 0...100,
                            unit: "%",
                            icon: "person.3.fill",
                            color: ColorThemeRTG.dangerRed
                        )

                        predictionSection
                    }
                    .padding(.horizontal, adaptyW(16))
                    .padding(.top, adaptyH(12))
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(100))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBackWithSwipe()
    }

    private var temperatureColor: Color {
        if viewModel.labTemperature < 0 { return Color(red: 0.3, green: 0.6, blue: 1.0) }
        if viewModel.labTemperature > 30 { return ColorThemeRTG.dangerRed }
        return ColorThemeRTG.emeraldAccent
    }

    @ViewBuilder
    private func sliderControl(title: String, value: Binding<Double>, range: ClosedRange<Double>, unit: String, icon: String, color: Color) -> some View {
        GlowCardRTG(glowColor: color) {
            VStack(spacing: adaptyH(12)) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: adaptyW(16)))
                        .foregroundStyle(color)

                    Text(title)
                        .font(.system(size: adaptyW(15), weight: .bold))
                        .foregroundStyle(.white)

                    Spacer()

                    Text("\(Int(value.wrappedValue))\(unit)")
                        .font(.system(size: adaptyW(16), weight: .heavy))
                        .foregroundStyle(color)
                }

                Slider(value: value, in: range)
                    .tint(color)
            }
            .padding(adaptyW(16))
        }
    }

    @ViewBuilder
    private var predictionSection: some View {
        let prediction = viewModel.behaviorPrediction

        VStack(alignment: .leading, spacing: adaptyH(14)) {
            HStack {
                Text("Behavior Prediction")
                    .font(.system(size: adaptyW(20), weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                stressIndicator(prediction.stressLevel)
            }

            predictionCard(icon: "figure.walk", title: "Activity Level", content: prediction.activityLevel, color: ColorThemeRTG.primaryOrange)

            predictionCard(icon: "scope", title: "Hunting Frequency", content: prediction.huntingFrequency, color: ColorThemeRTG.emeraldAccent)

            predictionCard(icon: "person.2.fill", title: "Social Behavior", content: prediction.socialBehavior, color: ColorThemeRTG.secondaryGold)

            predictionCard(icon: "map.fill", title: "Territory Patrol", content: prediction.territoryPatrol, color: Color(red: 0.6, green: 0.4, blue: 1.0))
        }
    }

    @ViewBuilder
    private func stressIndicator(_ level: Int) -> some View {
        HStack(spacing: adaptyW(6)) {
            Text("Stress")
                .font(.system(size: adaptyW(11)))
                .foregroundStyle(ColorThemeRTG.textSecondary)

            Text("\(level)%")
                .font(.system(size: adaptyW(13), weight: .bold))
                .foregroundStyle(level > 70 ? ColorThemeRTG.dangerRed : level > 40 ? ColorThemeRTG.secondaryGold : ColorThemeRTG.emeraldAccent)
        }
        .padding(.horizontal, adaptyW(10))
        .padding(.vertical, adaptyH(6))
        .background(
            Capsule()
                .fill(ColorThemeRTG.darkCard)
                .overlay(
                    Capsule().stroke(
                        level > 70 ? ColorThemeRTG.dangerRed.opacity(0.3) : ColorThemeRTG.cardBorder,
                        lineWidth: 1
                    )
                )
        )
    }

    @ViewBuilder
    private func predictionCard(icon: String, title: String, content: String, color: Color) -> some View {
        GlowCardRTG(glowColor: color) {
            VStack(alignment: .leading, spacing: adaptyH(8)) {
                HStack(spacing: adaptyW(8)) {
                    Image(systemName: icon)
                        .font(.system(size: adaptyW(16)))
                        .foregroundStyle(color)

                    Text(title)
                        .font(.system(size: adaptyW(14), weight: .bold))
                        .foregroundStyle(.white)
                }

                Text(content)
                    .font(.system(size: adaptyW(13)))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .lineSpacing(adaptyH(3))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(adaptyW(14))
        }
    }
}
