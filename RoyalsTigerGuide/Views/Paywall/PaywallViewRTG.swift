import SwiftUI
internal import StoreKit

struct PaywallViewRTG: View {
    let themeId: String
    let themeName: String
    @Environment(\.dismiss) private var dismiss
    @State private var iapManager = IAPManagerVE.shared
    @State private var animateGlow = false

    private var product: SKProduct? {
        return iapManager.products.first { $0.productIdentifier == themeId }
    }

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Unlock Theme", showBack: true) { dismiss() }

                ScrollView {
                    VStack(spacing: adaptyH(28)) {
                        ZStack {
                            Circle()
                                .fill(ColorThemeRTG.secondaryGold.opacity(0.08))
                                .frame(width: adaptyW(200), height: adaptyW(200))
                                .blur(radius: adaptyW(30))
                                .scaleEffect(animateGlow ? 1.1 : 1.0)

                            RoundedRectangle(cornerRadius: adaptyW(24))
                                .fill(themeId.contains("neon") ? ColorThemeRTG.neonGradient : ColorThemeRTG.sunriseGradient)
                                .frame(width: adaptyW(160), height: adaptyW(160))
                                .overlay(
                                    RoundedRectangle(cornerRadius: adaptyW(24))
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(color: ColorThemeRTG.secondaryGold.opacity(0.3), radius: adaptyW(20))

                            Image(systemName: "paintpalette.fill")
                                .font(.system(size: adaptyW(48)))
                                .foregroundStyle(.white.opacity(0.9))
                        }

                        VStack(spacing: adaptyH(8)) {
                            Text(themeName)
                                .font(.system(size: adaptyW(28), weight: .heavy))
                                .foregroundStyle(.white)

                            Text("Premium Theme")
                                .font(.system(size: adaptyW(15)))
                                .foregroundStyle(ColorThemeRTG.secondaryGold)
                                .tracking(adaptyW(2))
                        }

                        GlowCardRTG(glowColor: ColorThemeRTG.secondaryGold) {
                            VStack(spacing: adaptyH(14)) {
                                featureItem(icon: "paintbrush.fill", text: "Unique color palette for all screens")
                                featureItem(icon: "sparkles", text: "Custom glow and accent effects")
                                featureItem(icon: "wand.and.stars", text: "Enhanced visual experience")
                                featureItem(icon: "infinity", text: "Lifetime access, one-time purchase")
                            }
                            .padding(adaptyW(18))
                        }

                        VStack(spacing: adaptyH(14)) {
                            Text(product?.localizedPriceVE ?? "$1.99")
                                .font(.system(size: adaptyW(36), weight: .heavy))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [ColorThemeRTG.secondaryGold, ColorThemeRTG.primaryOrange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                            AnimatedButtonRTG(title: "Purchase Now", gradient: ColorThemeRTG.goldGradient) {
                                if let product = product {
                                    iapManager.purchase(product)
                                } else {
                                    print("⚠️ Paywall: no SKProduct for themeId=\(themeId)  — fetch finished? products=\(iapManager.products.map(\.productIdentifier))")
                                }
                            }

                            Button(action: { iapManager.restorePurchases() }) {
                                Text("Restore Purchases")
                                    .font(.system(size: adaptyW(14), weight: .medium))
                                    .foregroundStyle(ColorThemeRTG.textSecondary)
                            }
                        }

                        if iapManager.isLoading {
                            ProgressView()
                                .tint(ColorThemeRTG.primaryOrange)
                        }

                        if let error = iapManager.errorMessage {
                            Text(error)
                                .font(.system(size: adaptyW(13)))
                                .foregroundStyle(ColorThemeRTG.dangerRed)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, adaptyW(16))
                    .padding(.top, adaptyH(20))
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(100))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBackWithSwipe()
        .onAppear {
            iapManager.fetchProducts()
            withAnimation(.easeInOut(duration: 2.0).repeatForever()) {
                animateGlow = true
            }
        }
        .onChange(of: iapManager.purchasedProductIds) { _, newValue in
            
                dismiss()
            
        }
    }

    @ViewBuilder
    private func featureItem(icon: String, text: String) -> some View {
        HStack(spacing: adaptyW(12)) {
            Image(systemName: icon)
                .font(.system(size: adaptyW(16)))
                .foregroundStyle(ColorThemeRTG.secondaryGold)
                .frame(width: adaptyW(24))

            Text(text)
                .font(.system(size: adaptyW(14)))
                .foregroundStyle(Color.white.opacity(0.85))

            Spacer()
        }
    }
}
