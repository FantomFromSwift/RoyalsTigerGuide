import SwiftUI

struct HabitatDetailViewRTG: View {
    let habitat: HabitatDataRTG
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            ColorThemeRTG.deepBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderViewRTG(title: habitat.name, showBack: true) { dismiss() }

                ScrollView {
                    VStack(spacing: adaptyH(20)) {
                        Image(habitat.imageName)
                            .resizable()
                            .frame(height: adaptyH(220))
                            .clipShape(RoundedRectangle(cornerRadius: adaptyW(20)))

                        GlowCardRTG(glowColor: ColorThemeRTG.emeraldAccent) {
                            VStack(spacing: adaptyH(12)) {
                                detailRow(icon: "thermometer.medium", label: "Climate", value: habitat.climate)
                                Divider().background(ColorThemeRTG.cardBorder)
                                detailRow(icon: "hare.fill", label: "Primary Prey", value: habitat.prey)
                                Divider().background(ColorThemeRTG.cardBorder)
                                detailRow(icon: "pawprint.fill", label: "Tigers", value: habitat.tigerPopulation)
                            }
                            .padding(adaptyW(16))
                        }

                        GlowCardRTG(glowColor: Self.dangerColor(habitat.dangerLevel)) {
                            VStack(spacing: adaptyH(10)) {
                                Text("Danger Level")
                                    .font(.system(size: adaptyW(14), weight: .bold))
                                    .foregroundStyle(.white)

                                ZStack {
                                    Circle()
                                        .stroke(Self.dangerColor(habitat.dangerLevel).opacity(0.2), lineWidth: adaptyW(8))
                                        .frame(width: adaptyW(80), height: adaptyW(80))

                                    Circle()
                                        .trim(from: 0, to: Double(habitat.dangerLevel) / 100.0)
                                        .stroke(Self.dangerColor(habitat.dangerLevel), style: StrokeStyle(lineWidth: adaptyW(8), lineCap: .round))
                                        .frame(width: adaptyW(80), height: adaptyW(80))
                                        .rotationEffect(.degrees(-90))

                                    Text("\(habitat.dangerLevel)")
                                        .font(.system(size: adaptyW(22), weight: .bold))
                                        .foregroundStyle(Self.dangerColor(habitat.dangerLevel))
                                }
                            }
                            .padding(adaptyW(16))
                        }

                        Text(habitat.description)
                            .font(.system(size: adaptyW(15)))
                            .foregroundStyle(Color.white.opacity(0.85))
                            .lineSpacing(adaptyH(6))
                    }
                    .padding(.horizontal, adaptyW(16))
                    .padding(.top, adaptyH(16))
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(100))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBackWithSwipe()
    }

    @ViewBuilder
    private func detailRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: adaptyW(10)) {
            Image(systemName: icon)
                .font(.system(size: adaptyW(14)))
                .foregroundStyle(ColorThemeRTG.emeraldAccent)
                .frame(width: adaptyW(20))

            Text(label)
                .font(.system(size: adaptyW(13)))
                .foregroundStyle(ColorThemeRTG.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: adaptyW(13), weight: .medium))
                .foregroundStyle(.white)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: adaptyW(180), alignment: .trailing)
        }
    }

    private static func dangerColor(_ level: Int) -> Color {
        if level > 85 { return ColorThemeRTG.dangerRed }
        if level > 70 { return ColorThemeRTG.primaryOrange }
        return ColorThemeRTG.secondaryGold
    }
}
