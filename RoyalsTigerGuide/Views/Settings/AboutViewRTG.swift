import SwiftUI

struct AboutViewRTG: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "About", showBack: true) { dismiss() }

                ScrollView {
                    VStack(spacing: adaptyH(24)) {
                        ZStack {
                            Circle()
                                .fill(ColorThemeRTG.primaryOrange.opacity(0.1))
                                .frame(width: adaptyW(120), height: adaptyW(120))
                                .blur(radius: adaptyW(20))

                            Image("themeOne")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: adaptyW(90), height: adaptyW(90))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(ColorThemeRTG.primaryOrange.opacity(0.4), lineWidth: adaptyW(2))
                                )
                        }

                        VStack(spacing: adaptyH(6)) {
                            Text("RoyalsTiger Guide")
                                .font(.system(size: adaptyW(24), weight: .bold))
                                .foregroundStyle(.white)

                            Text("Version 1.0.0")
                                .font(.system(size: adaptyW(14)))
                                .foregroundStyle(ColorThemeRTG.textSecondary)
                        }

                        GlowCardRTG(glowColor: ColorThemeRTG.primaryOrange) {
                            VStack(alignment: .leading, spacing: adaptyH(12)) {
                                Text("About This App")
                                    .font(.system(size: adaptyW(18), weight: .bold))
                                    .foregroundStyle(.white)

                                Text("RoyalsTiger Guide is your ultimate companion for exploring the fascinating world of wild tigers and big cats. Dive into interactive features, detailed articles, field tasks, quizzes, and advanced simulation tools designed to deepen your understanding of these magnificent predators and the critical efforts to protect them.")
                                    .font(.system(size: adaptyW(14)))
                                    .foregroundStyle(Color.white.opacity(0.8))
                                    .lineSpacing(adaptyH(5))
                            }
                            .padding(adaptyW(18))
                        }

                        GlowCardRTG(glowColor: ColorThemeRTG.emeraldAccent) {
                            VStack(alignment: .leading, spacing: adaptyH(14)) {
                                Text("Features")
                                    .font(.system(size: adaptyW(18), weight: .bold))
                                    .foregroundStyle(.white)

                                featureRow(icon: "book.fill", text: "10 in-depth tiger articles")
                                featureRow(icon: "list.clipboard.fill", text: "8 interactive field tasks with 6 steps each")
                                featureRow(icon: "brain.head.profile", text: "Tiger quiz with 15 questions")
                                featureRow(icon: "pawprint.fill", text: "Tiger species encyclopedia")
                                featureRow(icon: "scope", text: "Predator hunt simulator")
                                featureRow(icon: "slider.horizontal.3", text: "Behavior prediction lab")
                                featureRow(icon: "globe.americas.fill", text: "Habitat explorer")
                                featureRow(icon: "leaf.fill", text: "Conservation project tracker")
                            }
                            .padding(adaptyW(18))
                        }

                        GlowCardRTG(glowColor: ColorThemeRTG.secondaryGold) {
                            VStack(spacing: adaptyH(10)) {
                                Text("Wildlife Protection Matters")
                                    .font(.system(size: adaptyW(16), weight: .bold))
                                    .foregroundStyle(ColorThemeRTG.secondaryGold)

                                Text("Every interaction with this app helps raise awareness about tiger conservation. Together we can make a difference for these incredible animals.")
                                    .font(.system(size: adaptyW(13)))
                                    .foregroundStyle(Color.white.opacity(0.75))
                                    .multilineTextAlignment(.center)
                                    .lineSpacing(adaptyH(4))
                            }
                            .padding(adaptyW(18))
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

    @ViewBuilder
    private func featureRow(icon: String, text: String) -> some View {
        HStack(spacing: adaptyW(10)) {
            Image(systemName: icon)
                .font(.system(size: adaptyW(14)))
                .foregroundStyle(ColorThemeRTG.emeraldAccent)
                .frame(width: adaptyW(24))

            Text(text)
                .font(.system(size: adaptyW(14)))
                .foregroundStyle(Color.white.opacity(0.8))
        }
    }
}
