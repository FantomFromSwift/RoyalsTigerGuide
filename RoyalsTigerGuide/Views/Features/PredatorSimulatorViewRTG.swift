import SwiftUI

struct PredatorSimulatorViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.dismiss) private var dismiss
    @State private var showResult = false

    private let preyOptions = ["Deer", "Wild Boar", "Gaur", "Young Elephant", "Fish"]
    private let terrainOptions = ["Dense Forest", "Open Grassland", "Snowy Terrain", "Mangrove Swamp", "Rocky Mountain"]
    private let timeOptions = ["Dawn", "Day", "Dusk", "Night"]

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Hunt Simulator", showBack: true) { dismiss() }

                ScrollView {
                    VStack(spacing: adaptyH(20)) {
                        GlowCardRTG(glowColor: ColorThemeRTG.emeraldAccent) {
                            VStack(spacing: adaptyH(8)) {
                                Image(systemName: "scope")
                                    .font(.system(size: adaptyW(32)))
                                    .foregroundStyle(ColorThemeRTG.emeraldAccent)

                                Text("Configure your hunt scenario and see the predicted outcome based on tiger traits, terrain, and prey difficulty.")
                                    .font(.system(size: adaptyW(13)))
                                    .foregroundStyle(ColorThemeRTG.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(adaptyW(16))
                        }

                        selectorSection(title: "Select Tiger Species", content: {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: adaptyW(10)) {
                                    ForEach(viewModel.tigerSpecies) { species in
                                        Button(action: { viewModel.simulatorSelectedSpecies = species }) {
                                            let isSelected = viewModel.simulatorSelectedSpecies?.id == species.id
                                            VStack(spacing: adaptyH(6)) {
                                                Image(species.imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: adaptyW(56), height: adaptyW(56))
                                                    .clipShape(Circle())
                                                    .overlay(
                                                        Circle()
                                                            .stroke(isSelected ? ColorThemeRTG.primaryOrange : Color.clear, lineWidth: adaptyW(2))
                                                    )

                                                Text(species.name.components(separatedBy: " ").first ?? "")
                                                    .font(.system(size: adaptyW(11), weight: isSelected ? .bold : .regular))
                                                    .foregroundStyle(isSelected ? ColorThemeRTG.primaryOrange : ColorThemeRTG.textSecondary)
                                            }
                                        }
                                    }
                                }
                            }
                        })

                        chipSelector(title: "Select Prey", options: preyOptions, selected: $viewModel.simulatorPrey)

                        chipSelector(title: "Select Terrain", options: terrainOptions, selected: $viewModel.simulatorTerrain)

                        chipSelector(title: "Time of Day", options: timeOptions, selected: $viewModel.simulatorTimeOfDay)

                        AnimatedButtonRTG(title: viewModel.simulatorAnimating ? "Simulating..." : "Run Simulation") {
                            guard viewModel.simulatorSelectedSpecies != nil else { return }
                            viewModel.runSimulation()
                            showResult = true
                        }

                        if showResult, let result = viewModel.simulatorResult {
                            resultView(result)
                        }
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

    @ViewBuilder
    private func selectorSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: adaptyH(10)) {
            Text(title)
                .font(.system(size: adaptyW(16), weight: .bold))
                .foregroundStyle(.white)

            content()
        }
    }

    @ViewBuilder
    private func chipSelector(title: String, options: [String], selected: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: adaptyH(10)) {
            Text(title)
                .font(.system(size: adaptyW(16), weight: .bold))
                .foregroundStyle(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: adaptyW(8)) {
                    ForEach(options, id: \.self) { option in
                        Button(action: { selected.wrappedValue = option }) {
                            let isActive = selected.wrappedValue == option
                            Text(option)
                                .font(.system(size: adaptyW(13), weight: isActive ? .bold : .regular))
                                .foregroundStyle(isActive ? .white : ColorThemeRTG.textSecondary)
                                .padding(.horizontal, adaptyW(16))
                                .padding(.vertical, adaptyH(10))
                                .background(
                                    Capsule()
                                        .fill(isActive ? ColorThemeRTG.primaryOrange : ColorThemeRTG.darkCard)
                                        .overlay(
                                            Capsule()
                                                .stroke(isActive ? ColorThemeRTG.primaryOrange.opacity(0.5) : ColorThemeRTG.cardBorder, lineWidth: 1)
                                        )
                                )
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func resultView(_ result: SimulatorResultRTG) -> some View {
        GlowCardRTG(glowColor: result.successChance > 60 ? ColorThemeRTG.emeraldAccent : ColorThemeRTG.dangerRed) {
            VStack(spacing: adaptyH(16)) {
                Text("Simulation Result")
                    .font(.system(size: adaptyW(18), weight: .bold))
                    .foregroundStyle(.white)

                ProgressRingRTG(
                    progress: Double(result.successChance) / 100.0,
                    lineWidth: adaptyW(8),
                    size: adaptyW(120),
                    color: result.successChance > 60 ? ColorThemeRTG.emeraldAccent : result.successChance > 35 ? ColorThemeRTG.secondaryGold : ColorThemeRTG.dangerRed
                )

                Text("Success Chance: \(result.successChance)%")
                    .font(.system(size: adaptyW(16), weight: .bold))
                    .foregroundStyle(result.successChance > 60 ? ColorThemeRTG.emeraldAccent : ColorThemeRTG.secondaryGold)

                HStack(spacing: adaptyW(16)) {
                    miniStat(label: "Stealth", value: result.stealthRating, color: ColorThemeRTG.emeraldAccent)
                    miniStat(label: "Speed", value: result.speedRating, color: ColorThemeRTG.primaryOrange)
                    miniStat(label: "Strength", value: result.strengthRating, color: ColorThemeRTG.dangerRed)
                }

                HStack {
                    Text("Energy Cost")
                        .font(.system(size: adaptyW(13)))
                        .foregroundStyle(ColorThemeRTG.textSecondary)

                    Spacer()

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: adaptyW(4))
                                .fill(ColorThemeRTG.darkCard)

                            RoundedRectangle(cornerRadius: adaptyW(4))
                                .fill(ColorThemeRTG.dangerRed)
                                .frame(width: geometry.size.width * Double(result.energyCost) / 100.0)
                        }
                    }
                    .frame(width: adaptyW(120), height: adaptyH(8))

                    Text("\(result.energyCost)%")
                        .font(.system(size: adaptyW(12), weight: .bold))
                        .foregroundStyle(ColorThemeRTG.dangerRed)
                }

                Text(result.verdict)
                    .font(.system(size: adaptyW(13)))
                    .foregroundStyle(ColorThemeRTG.textSecondary)
                    .multilineTextAlignment(.center)
                    .italic()
            }
            .padding(adaptyW(18))
        }
    }

    @ViewBuilder
    private func miniStat(label: String, value: Int, color: Color) -> some View {
        VStack(spacing: adaptyH(4)) {
            Text("\(value)")
                .font(.system(size: adaptyW(18), weight: .bold))
                .foregroundStyle(color)

            Text(label)
                .font(.system(size: adaptyW(10)))
                .foregroundStyle(ColorThemeRTG.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
}
