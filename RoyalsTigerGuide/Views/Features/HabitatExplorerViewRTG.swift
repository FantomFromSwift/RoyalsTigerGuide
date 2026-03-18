import SwiftUI

struct HabitatExplorerViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.dismiss) private var dismiss

    private let habitats: [HabitatDataRTG] = [
        HabitatDataRTG(id: "h1", name: "Tropical Rainforest", climate: "Hot and humid, 25-30C year-round", prey: "Deer, wild boar, tapir, monkeys", tigerPopulation: "Sumatran Tigers (~450)", dangerLevel: 85, imageName: "themeThree", description: "Dense tropical rainforests with multiple canopy layers provide excellent cover for ambush hunting. High humidity and constant rainfall create a lush environment with abundant prey and water sources year-round."),
        HabitatDataRTG(id: "h2", name: "Boreal Taiga", climate: "Extreme cold, -40C to 20C", prey: "Elk, wild boar, deer, brown bears", tigerPopulation: "Siberian Tigers (~550)", dangerLevel: 92, imageName: "themeTwo", description: "Vast coniferous forests stretching across the Russian Far East with severe winters. Tigers here have adapted thick fur and larger body mass to survive temperatures that can plummet below minus 40 degrees."),
        HabitatDataRTG(id: "h3", name: "Deciduous Forest", climate: "Seasonal, 10-40C range", prey: "Spotted deer, sambar, gaur, nilgai", tigerPopulation: "Bengal Tigers (~2500)", dangerLevel: 70, imageName: "themeOne", description: "The classic tiger habitat featuring sal and teak forests with seasonal grasslands. India's national parks in this biome support the highest tiger densities on Earth."),
        HabitatDataRTG(id: "h4", name: "Mangrove Swamp", climate: "Tropical, tidal flooding", prey: "Deer, fish, crabs, wild boar", tigerPopulation: "Sundarbans Tigers (~100)", dangerLevel: 95, imageName: "themeFour", description: "The Sundarbans mangrove delta spanning India and Bangladesh represents one of the most challenging tiger habitats. Tigers here swim between islands and have adapted to hunting in brackish water channels."),
        HabitatDataRTG(id: "h5", name: "Mountain Forest", climate: "Cool, 5-25C, high altitude", prey: "Serow, barking deer, wild boar", tigerPopulation: "Indochinese Tigers (~300)", dangerLevel: 80, imageName: "themeFive", description: "Steep mountainous terrain at elevations above 2000 meters in Southeast Asia. Remote and difficult to access, these forests provide a natural refuge for some of the most secretive tiger populations."),
        HabitatDataRTG(id: "h6", name: "Grassland Savanna", climate: "Dry and warm, 20-45C", prey: "Blackbuck, chital, wild boar", tigerPopulation: "Bengal Tigers (small groups)", dangerLevel: 65, imageName: "themeSix", description: "Open grasslands and terai regions along the foothills of the Himalayas in Nepal and northern India. These habitats require tigers to rely more heavily on cover from tall elephant grass for hunting success.")
    ]

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Habitat Explorer", showBack: true) { dismiss() }

                ScrollView {
                    VStack(spacing: adaptyH(14)) {
                        Text("Tap a habitat to explore its unique characteristics and the tiger populations that call it home.")
                            .font(.system(size: adaptyW(14)))
                            .foregroundStyle(ColorThemeRTG.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, adaptyW(8))

                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: adaptyW(12)),
                            GridItem(.flexible(), spacing: adaptyW(12))
                        ], spacing: adaptyH(12)) {
                            ForEach(habitats) { habitat in
                                NavigationLink(destination: HabitatDetailViewRTG(habitat: habitat)) {
                                    habitatCard(habitat)
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
    private func habitatCard(_ habitat: HabitatDataRTG) -> some View {
        ZStack(alignment: .bottomLeading) {
            Image(habitat.imageName)
                .resizable()
                .frame(height: adaptyH(140))
                .clipShape(RoundedRectangle(cornerRadius: adaptyW(16)))
                .overlay(
                    RoundedRectangle(cornerRadius: adaptyW(16))
                        .fill(
                            LinearGradient(
                                colors: [.clear, Color.black.opacity(0.7)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )

            VStack(alignment: .leading, spacing: adaptyH(4)) {
                Text(habitat.name)
                    .font(.system(size: adaptyW(13), weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                HStack(spacing: adaptyW(4)) {
                    Circle()
                        .fill(dangerColor(habitat.dangerLevel))
                        .frame(width: adaptyW(6), height: adaptyW(6))

                    Text("Danger: \(habitat.dangerLevel)%")
                        .font(.system(size: adaptyW(10)))
                        .foregroundStyle(ColorThemeRTG.textSecondary)
                }
            }
            .padding(adaptyW(10))
        }
        .overlay(
            RoundedRectangle(cornerRadius: adaptyW(16))
                .stroke(ColorThemeRTG.cardBorder, lineWidth: 1)
        )
    }

    private func dangerColor(_ level: Int) -> Color {
        if level > 85 { return ColorThemeRTG.dangerRed }
        if level > 70 { return ColorThemeRTG.primaryOrange }
        return ColorThemeRTG.secondaryGold
    }
}

struct HabitatDataRTG: Identifiable, Hashable {
    let id: String
    let name: String
    let climate: String
    let prey: String
    let tigerPopulation: String
    let dangerLevel: Int
    let imageName: String
    let description: String
}
