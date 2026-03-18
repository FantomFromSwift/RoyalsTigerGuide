import SwiftUI

struct TigerEncyclopediaViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.dismiss) private var dismiss
    @State private var compareMode = false

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Tiger Encyclopedia", showBack: true) { dismiss() }

                ScrollView {
                    VStack(spacing: adaptyH(16)) {
                        HStack {
                            Text("\(viewModel.tigerSpecies.count) Species")
                                .font(.system(size: adaptyW(14)))
                                .foregroundStyle(ColorThemeRTG.textSecondary)

                            Spacer()

                            Button(action: { compareMode.toggle() }) {
                                HStack(spacing: adaptyW(6)) {
                                    Image(systemName: compareMode ? "square.split.2x1.fill" : "square.split.2x1")
                                        .font(.system(size: adaptyW(14)))

                                    Text(compareMode ? "Exit Compare" : "Compare")
                                        .font(.system(size: adaptyW(13), weight: .semibold))
                                }
                                .foregroundStyle(compareMode ? ColorThemeRTG.primaryOrange : ColorThemeRTG.textSecondary)
                            }
                        }

                        if compareMode && viewModel.selectedSpeciesForCompare.count == 2 {
                            comparisonView
                        }

                        ForEach(viewModel.tigerSpecies) { species in
                            if compareMode {
                                Button(action: { toggleCompareSelection(species) }) {
                                    speciesCard(species)
                                }
                                .buttonStyle(.plain)
                            } else {
                                NavigationLink(destination: TigerSpeciesDetailViewRTG(species: species)) {
                                    speciesCard(species)
                                }
                                .buttonStyle(.plain)
                            }
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
    private func speciesCard(_ species: TigerSpeciesModelRTG) -> some View {
        let isSelected = viewModel.selectedSpeciesForCompare.contains(species)
        GlowCardRTG(glowColor: isSelected ? ColorThemeRTG.emeraldAccent : ColorThemeRTG.primaryOrange) {
            HStack(spacing: adaptyW(14)) {
                Image(species.imageName)
                    .resizable()
                    .frame(width: adaptyW(72), height: adaptyW(72))
                    .clipShape(RoundedRectangle(cornerRadius: adaptyW(14)))

                VStack(alignment: .leading, spacing: adaptyH(4)) {
                    Text(species.name)
                        .font(.system(size: adaptyW(16), weight: .bold))
                        .foregroundStyle(.white)

                    Text(species.scientificName)
                        .font(.system(size: adaptyW(12), weight: .medium))
                        .foregroundStyle(ColorThemeRTG.secondaryGold)
                        .italic()

                    HStack(spacing: adaptyW(8)) {
                        statusBadge(species.status)

                        Text(species.population)
                            .font(.system(size: adaptyW(11)))
                            .foregroundStyle(ColorThemeRTG.textSecondary)
                    }
                }

                Spacer()

                if compareMode {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: adaptyW(22)))
                        .foregroundStyle(isSelected ? ColorThemeRTG.emeraldAccent : ColorThemeRTG.textSecondary)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: adaptyW(14)))
                        .foregroundStyle(ColorThemeRTG.textSecondary)
                }
            }
            .padding(adaptyW(14))
        }
    }

    @ViewBuilder
    private func statusBadge(_ status: String) -> some View {
        let color = status.contains("Critically") ? ColorThemeRTG.dangerRed : ColorThemeRTG.secondaryGold
        Text(status)
            .font(.system(size: adaptyW(9), weight: .bold))
            .foregroundStyle(color)
            .padding(.horizontal, adaptyW(6))
            .padding(.vertical, adaptyH(2))
            .background(Capsule().fill(color.opacity(0.15)))
    }

    @ViewBuilder
    private var comparisonView: some View {
        let s1 = viewModel.selectedSpeciesForCompare[0]
        let s2 = viewModel.selectedSpeciesForCompare[1]

        GlowCardRTG(glowColor: ColorThemeRTG.secondaryGold) {
            VStack(spacing: adaptyH(14)) {
                Text("Species Comparison")
                    .font(.system(size: adaptyW(16), weight: .bold))
                    .foregroundStyle(.white)

                HStack {
                    Text(s1.name)
                        .font(.system(size: adaptyW(13), weight: .bold))
                        .foregroundStyle(ColorThemeRTG.primaryOrange)
                        .frame(maxWidth: .infinity)

                    Text("VS")
                        .font(.system(size: adaptyW(11), weight: .heavy))
                        .foregroundStyle(ColorThemeRTG.textSecondary)

                    Text(s2.name)
                        .font(.system(size: adaptyW(13), weight: .bold))
                        .foregroundStyle(ColorThemeRTG.emeraldAccent)
                        .frame(maxWidth: .infinity)
                }

                compareBar(label: "Strength", v1: s1.traits.strength, v2: s2.traits.strength)
                compareBar(label: "Speed", v1: s1.traits.speed, v2: s2.traits.speed)
                compareBar(label: "Stealth", v1: s1.traits.stealth, v2: s2.traits.stealth)
                compareBar(label: "Swimming", v1: s1.traits.swimming, v2: s2.traits.swimming)
                compareBar(label: "Endurance", v1: s1.traits.endurance, v2: s2.traits.endurance)
            }
            .padding(adaptyW(18))
        }
    }

    @ViewBuilder
    private func compareBar(label: String, v1: Int, v2: Int) -> some View {
        VStack(spacing: adaptyH(4)) {
            HStack {
                Text("\(v1)")
                    .font(.system(size: adaptyW(12), weight: .bold))
                    .foregroundStyle(ColorThemeRTG.primaryOrange)

                Spacer()

                Text(label)
                    .font(.system(size: adaptyW(11)))
                    .foregroundStyle(ColorThemeRTG.textSecondary)

                Spacer()

                Text("\(v2)")
                    .font(.system(size: adaptyW(12), weight: .bold))
                    .foregroundStyle(ColorThemeRTG.emeraldAccent)
            }

            GeometryReader { geometry in
                HStack(spacing: adaptyW(4)) {
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: adaptyW(3))
                            .fill(ColorThemeRTG.primaryOrange)
                            .frame(width: geometry.size.width * 0.48 * Double(v1) / 100.0, height: adaptyH(6))
                    }
                    .frame(width: geometry.size.width * 0.48)

                    HStack {
                        RoundedRectangle(cornerRadius: adaptyW(3))
                            .fill(ColorThemeRTG.emeraldAccent)
                            .frame(width: geometry.size.width * 0.48 * Double(v2) / 100.0, height: adaptyH(6))
                        Spacer()
                    }
                    .frame(width: geometry.size.width * 0.48)
                }
            }
            .frame(height: adaptyH(6))
        }
    }

    private func toggleCompareSelection(_ species: TigerSpeciesModelRTG) {
        if let index = viewModel.selectedSpeciesForCompare.firstIndex(of: species) {
            viewModel.selectedSpeciesForCompare.remove(at: index)
        } else if viewModel.selectedSpeciesForCompare.count < 2 {
            viewModel.selectedSpeciesForCompare.append(species)
        }
    }
}
