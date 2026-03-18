import SwiftUI

struct SettingsViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @AppStorage("usernameRTG") private var username = "Explorer"
    @AppStorage("selectedThemeRTG") private var selectedTheme = "default"
    @State private var iapManager = IAPManagerVE.shared

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Settings")

                ScrollView {
                    VStack(spacing: adaptyH(16)) {
                        profileSection

                        themesSection

                        linksSection

                        purchasesSection
                    }
                    .padding(.horizontal, adaptyW(16))
                    .padding(.top, adaptyH(12))

                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(120))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    @ViewBuilder
    private var profileSection: some View {
        GlowCardRTG(glowColor: ColorThemeRTG.primaryOrange) {
            HStack(spacing: adaptyW(14)) {
                ZStack {
                    Circle()
                        .fill(ColorThemeRTG.primaryOrange.opacity(0.2))
                        .frame(width: adaptyW(56), height: adaptyW(56))

                    Image(systemName: "person.fill")
                        .font(.system(size: adaptyW(24)))
                        .foregroundStyle(ColorThemeRTG.primaryOrange)
                }

                VStack(alignment: .leading, spacing: adaptyH(4)) {
                    TextField("", text: $username, prompt: Text("Your Name").foregroundStyle(ColorThemeRTG.textSecondary.opacity(0.5)))
                        .font(.system(size: adaptyW(18), weight: .bold))
                        .foregroundStyle(.white)

                    Text("Wildlife Explorer")
                        .font(.system(size: adaptyW(13)))
                        .foregroundStyle(ColorThemeRTG.textSecondary)
                }

                Spacer()
            }
            .padding(adaptyW(16))
        }
    }

    @ViewBuilder
    private var themesSection: some View {
        VStack(alignment: .leading, spacing: adaptyH(10)) {
            Text("Themes")
                .font(.system(size: adaptyW(18), weight: .bold))
                .foregroundStyle(.white)

            themeRow(name: "Default Tiger", themeId: "default", gradient: ColorThemeRTG.primaryGradient, isLocked: false)

            themeRow(name: "Neon Jungle", themeId: "royalsTigerThemeOne", gradient: ColorThemeRTG.neonGradient, isLocked: !iapManager.isPurchased("royalsTigerThemeOne"))

            themeRow(name: "Sunrise Safari", themeId: "royalsTigerThemeTwo", gradient: ColorThemeRTG.sunriseGradient, isLocked: !iapManager.isPurchased("royalsTigerThemeTwo"))
        }
    }

    @ViewBuilder
    private func themeRow(name: String, themeId: String, gradient: LinearGradient, isLocked: Bool) -> some View {
        if isLocked {
            NavigationLink(destination: PaywallViewRTG(themeId: themeId, themeName: name)) {
                themeContent(name: name, themeId: themeId, gradient: gradient, isLocked: true)
            }
        } else {
            Button(action: { selectedTheme = themeId }) {
                themeContent(name: name, themeId: themeId, gradient: gradient, isLocked: false)
            }
        }
    }

    @ViewBuilder
    private func themeContent(name: String, themeId: String, gradient: LinearGradient, isLocked: Bool) -> some View {
        HStack(spacing: adaptyW(14)) {
            RoundedRectangle(cornerRadius: adaptyW(10))
                .fill(gradient)
                .frame(width: adaptyW(48), height: adaptyW(48))
                .overlay {
                    if isLocked {
                        ZStack {
                            Color.black.opacity(0.4)
                                .clipShape(RoundedRectangle(cornerRadius: adaptyW(10)))

                            Image(systemName: "lock.fill")
                                .font(.system(size: adaptyW(16)))
                                .foregroundStyle(.white)
                        }
                    }
                }

            VStack(alignment: .leading, spacing: adaptyH(4)) {
                HStack(spacing: adaptyW(6)) {
                    Text(name)
                        .font(.system(size: adaptyW(15), weight: .semibold))
                        .foregroundStyle(.white)

                    if isLocked {
                        Text("PRO")
                            .font(.system(size: adaptyW(9), weight: .heavy))
                            .foregroundStyle(ColorThemeRTG.secondaryGold)
                            .padding(.horizontal, adaptyW(6))
                            .padding(.vertical, adaptyH(2))
                            .background(
                                Capsule().fill(ColorThemeRTG.secondaryGold.opacity(0.2))
                            )
                    }
                }

                if isLocked {
                    Text("$1.99")
                        .font(.system(size: adaptyW(12)))
                        .foregroundStyle(ColorThemeRTG.textSecondary)
                } else if selectedTheme == themeId {
                    Text("Active")
                        .font(.system(size: adaptyW(12)))
                        .foregroundStyle(ColorThemeRTG.emeraldAccent)
                }
            }

            Spacer()

            if selectedTheme == themeId && !isLocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: adaptyW(22)))
                    .foregroundStyle(ColorThemeRTG.emeraldAccent)
            } else if isLocked {
                Image(systemName: "chevron.right")
                    .font(.system(size: adaptyW(14)))
                    .foregroundStyle(ColorThemeRTG.textSecondary)
            }
        }
        .padding(adaptyW(14))
        .background(
            RoundedRectangle(cornerRadius: adaptyW(14))
                .fill(ColorThemeRTG.darkCard.opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: adaptyW(14))
                        .stroke(
                            selectedTheme == themeId && !isLocked ? ColorThemeRTG.emeraldAccent.opacity(0.4) : ColorThemeRTG.cardBorder,
                            lineWidth: 1
                        )
                )
        )
    }

    @ViewBuilder
    private var linksSection: some View {
        VStack(spacing: adaptyH(2)) {
            NavigationLink(destination: StatsViewRTG(viewModel: viewModel)) {
                settingsRow(icon: "chart.bar.fill", title: "Statistics", color: ColorThemeRTG.emeraldAccent)
            }

            NavigationLink(destination: AboutViewRTG()) {
                settingsRow(icon: "info.circle.fill", title: "About", color: ColorThemeRTG.primaryOrange)
            }
        }
    }

    @ViewBuilder
    private var purchasesSection: some View {
        VStack(spacing: adaptyH(2)) {
            Button(action: { iapManager.restorePurchases() }) {
                settingsRow(icon: "arrow.clockwise", title: "Restore Purchases", color: ColorThemeRTG.secondaryGold)
            }
        }
    }

    @ViewBuilder
    private func settingsRow(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: adaptyW(14)) {
            ZStack {
                RoundedRectangle(cornerRadius: adaptyW(8))
                    .fill(color.opacity(0.15))
                    .frame(width: adaptyW(36), height: adaptyW(36))

                Image(systemName: icon)
                    .font(.system(size: adaptyW(16)))
                    .foregroundStyle(color)
            }

            Text(title)
                .font(.system(size: adaptyW(15), weight: .medium))
                .foregroundStyle(.white)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: adaptyW(13)))
                .foregroundStyle(ColorThemeRTG.textSecondary)
        }
        .padding(adaptyW(14))
        .background(
            RoundedRectangle(cornerRadius: adaptyW(14))
                .fill(ColorThemeRTG.darkCard.opacity(0.85))
        )
    }
}
