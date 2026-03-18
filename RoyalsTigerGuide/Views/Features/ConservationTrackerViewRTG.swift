import SwiftUI

struct ConservationTrackerViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Conservation", showBack: true) { dismiss() }

                ScrollView {
                    VStack(spacing: adaptyH(16)) {
                        impactOverview

                        ForEach(conservationProjectsRTG) { project in
                            projectCard(project)
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
    private var impactOverview: some View {
        GlowCardRTG(glowColor: ColorThemeRTG.emeraldAccent) {
            VStack(spacing: adaptyH(14)) {
                HStack {
                    VStack(alignment: .leading, spacing: adaptyH(4)) {
                        Text("Total Impact Score")
                            .font(.system(size: adaptyW(13)))
                            .foregroundStyle(ColorThemeRTG.textSecondary)

                        Text("\(viewModel.totalConservationImpact)")
                            .font(.system(size: adaptyW(36), weight: .heavy))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [ColorThemeRTG.emeraldAccent, Color(red: 0.2, green: 0.8, blue: 0.6)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )

                        Text("contributions across all projects")
                            .font(.system(size: adaptyW(12)))
                            .foregroundStyle(ColorThemeRTG.textSecondary)
                    }

                    Spacer()

                    ProgressRingRTG(
                        progress: min(Double(viewModel.totalConservationImpact) / 50.0, 1.0),
                        lineWidth: adaptyW(6),
                        size: adaptyW(70),
                        color: ColorThemeRTG.emeraldAccent
                    )
                }

                HStack(spacing: adaptyW(8)) {
                    milestoneBadge(threshold: 10, label: "Beginner", icon: "leaf")
                    milestoneBadge(threshold: 25, label: "Supporter", icon: "star")
                    milestoneBadge(threshold: 50, label: "Champion", icon: "crown")
                    milestoneBadge(threshold: 100, label: "Legend", icon: "trophy")
                }
            }
            .padding(adaptyW(18))
        }
    }

    @ViewBuilder
    private func milestoneBadge(threshold: Int, label: String, icon: String) -> some View {
        let achieved = viewModel.totalConservationImpact >= threshold
        VStack(spacing: adaptyH(4)) {
            ZStack {
                Circle()
                    .fill(achieved ? ColorThemeRTG.secondaryGold.opacity(0.2) : ColorThemeRTG.darkCard)
                    .frame(width: adaptyW(36), height: adaptyW(36))

                Image(systemName: achieved ? "\(icon).fill" : icon)
                    .font(.system(size: adaptyW(14)))
                    .foregroundStyle(achieved ? ColorThemeRTG.secondaryGold : ColorThemeRTG.textSecondary.opacity(0.4))
            }

            Text(label)
                .font(.system(size: adaptyW(9)))
                .foregroundStyle(achieved ? ColorThemeRTG.secondaryGold : ColorThemeRTG.textSecondary.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func projectCard(_ project: ConservationProjectRTG) -> some View {
        let supports = viewModel.conservationSupportCount(project.id)
        let progress = min(Double(supports) / Double(project.goal), 1.0)

        GlowCardRTG(glowColor: ColorThemeRTG.emeraldAccent) {
            VStack(spacing: adaptyH(12)) {
                HStack(spacing: adaptyW(12)) {
                    Image(project.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: adaptyW(52), height: adaptyW(52))
                        .clipShape(RoundedRectangle(cornerRadius: adaptyW(12)))

                    VStack(alignment: .leading, spacing: adaptyH(4)) {
                        Text(project.name)
                            .font(.system(size: adaptyW(15), weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(1)

                        Text(project.region)
                            .font(.system(size: adaptyW(12)))
                            .foregroundStyle(ColorThemeRTG.secondaryGold)
                    }

                    Spacer()
                }

                Text(project.description)
                    .font(.system(size: adaptyW(13)))
                    .foregroundStyle(Color.white.opacity(0.75))
                    .lineSpacing(adaptyH(3))
                    .lineLimit(3)

                VStack(spacing: adaptyH(6)) {
                    HStack {
                        Text("\(supports) / \(project.goal)")
                            .font(.system(size: adaptyW(12), weight: .semibold))
                            .foregroundStyle(ColorThemeRTG.emeraldAccent)

                        Spacer()

                        Text("\(Int(progress * 100))%")
                            .font(.system(size: adaptyW(12), weight: .bold))
                            .foregroundStyle(ColorThemeRTG.textSecondary)
                    }

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: adaptyW(4))
                                .fill(ColorThemeRTG.emeraldAccent.opacity(0.15))

                            RoundedRectangle(cornerRadius: adaptyW(4))
                                .fill(ColorThemeRTG.emeraldAccent)
                                .frame(width: geometry.size.width * progress)
                                .animation(.spring(response: 0.5), value: progress)
                        }
                    }
                    .frame(height: adaptyH(8))
                }

                Button(action: { viewModel.supportConservation(project.id) }) {
                    HStack(spacing: adaptyW(8)) {
                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: adaptyW(14)))

                        Text("Support This Project")
                            .font(.system(size: adaptyW(14), weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, adaptyH(12))
                    .background(
                        RoundedRectangle(cornerRadius: adaptyW(12))
                            .fill(ColorThemeRTG.emeraldAccent.opacity(0.8))
                    )
                }
            }
            .padding(adaptyW(14))
        }
    }
}
