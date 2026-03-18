import SwiftUI
import SwiftData

struct TigerSpeciesDetailViewRTG: View {
    let species: TigerSpeciesModelRTG
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteItemRTG]

    var body: some View {
        ZStack {
            ColorThemeRTG.deepBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderViewRTG(title: species.name, showBack: true) { dismiss() }

                ScrollView {
                    VStack(spacing: adaptyH(20)) {
                        Image(species.imageName)
                            .resizable()
                            
                            .frame(height: adaptyH(250))
                            .clipShape(RoundedRectangle(cornerRadius: adaptyW(20)))

                        VStack(alignment: .leading, spacing: adaptyH(8)) {
                            Text(species.scientificName)
                                .font(.system(size: adaptyW(15)))
                                .foregroundStyle(ColorThemeRTG.secondaryGold)
                                .italic()

                            HStack(spacing: adaptyW(10)) {
                                statusBadge(species.status)

                                Label(species.population, systemImage: "number")
                                    .font(.system(size: adaptyW(12)))
                                    .foregroundStyle(ColorThemeRTG.textSecondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        GlowCardRTG(glowColor: ColorThemeRTG.primaryOrange) {
                            VStack(alignment: .leading, spacing: adaptyH(10)) {
                                infoRow(label: "Habitat", value: species.habitat)
                                Divider().background(ColorThemeRTG.cardBorder)
                                infoRow(label: "Region", value: species.region)
                            }
                            .padding(adaptyW(16))
                        }

                        GlowCardRTG(glowColor: ColorThemeRTG.emeraldAccent) {
                            VStack(spacing: adaptyH(12)) {
                                Text("Traits")
                                    .font(.system(size: adaptyW(16), weight: .bold))
                                    .foregroundStyle(.white)

                                traitBar(label: "Strength", value: species.traits.strength, color: ColorThemeRTG.dangerRed)
                                traitBar(label: "Speed", value: species.traits.speed, color: ColorThemeRTG.primaryOrange)
                                traitBar(label: "Stealth", value: species.traits.stealth, color: ColorThemeRTG.emeraldAccent)
                                traitBar(label: "Swimming", value: species.traits.swimming, color: Color(red: 0.2, green: 0.6, blue: 1.0))
                                traitBar(label: "Endurance", value: species.traits.endurance, color: ColorThemeRTG.secondaryGold)
                            }
                            .padding(adaptyW(16))
                        }

                        Text(species.description)
                            .font(.system(size: adaptyW(15)))
                            .foregroundStyle(Color.white.opacity(0.85))
                            .lineSpacing(adaptyH(6))

                        Button(action: { toggleFavoriteSpecies() }) {
                            HStack {
                                Image(systemName: isSpeciesFavorited ? "heart.fill" : "heart")
                                Text(isSpeciesFavorited ? "Remove from Favorites" : "Add to Favorites")
                            }
                            .font(.system(size: adaptyW(15), weight: .semibold))
                            .foregroundStyle(isSpeciesFavorited ? ColorThemeRTG.dangerRed : ColorThemeRTG.primaryOrange)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, adaptyH(14))
                            .background(
                                RoundedRectangle(cornerRadius: adaptyW(14))
                                    .fill(ColorThemeRTG.darkCard)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: adaptyW(14))
                                            .stroke(isSpeciesFavorited ? ColorThemeRTG.dangerRed.opacity(0.3) : ColorThemeRTG.primaryOrange.opacity(0.3), lineWidth: 1)
                                    )
                            )
                        }
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

    private var isSpeciesFavorited: Bool {
        favorites.contains { $0.itemId == species.id }
    }

    private func toggleFavoriteSpecies() {
        if let existing = favorites.first(where: { $0.itemId == species.id }) {
            modelContext.delete(existing)
        } else {
            let fav = FavoriteItemRTG(itemId: species.id, itemType: "species", itemTitle: species.name, itemImage: species.imageName)
            modelContext.insert(fav)
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
    private func traitBar(label: String, value: Int, color: Color) -> some View {
        HStack(spacing: adaptyW(10)) {
            Text(label)
                .font(.system(size: adaptyW(13)))
                .foregroundStyle(ColorThemeRTG.textSecondary)
                .frame(width: adaptyW(80), alignment: .leading)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: adaptyW(4))
                        .fill(color.opacity(0.15))

                    RoundedRectangle(cornerRadius: adaptyW(4))
                        .fill(color)
                        .frame(width: geometry.size.width * Double(value) / 100.0)
                }
            }
            .frame(height: adaptyH(10))

            Text("\(value)")
                .font(.system(size: adaptyW(13), weight: .bold))
                .foregroundStyle(color)
                .frame(width: adaptyW(30))
        }
    }

    @ViewBuilder
    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: adaptyW(13)))
                .foregroundStyle(ColorThemeRTG.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: adaptyW(13), weight: .medium))
                .foregroundStyle(.white)
                .multilineTextAlignment(.trailing)
        }
    }
}
