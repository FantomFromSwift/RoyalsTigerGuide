import SwiftUI

struct GlowCardRTG<Content: View>: View {
    let glowColor: Color
    @ViewBuilder let content: Content

    var body: some View {
        content
            .background(
                RoundedRectangle(cornerRadius: adaptyW(16))
                    .fill(ColorThemeRTG.darkCard.opacity(0.85))
            )
            .overlay(
                RoundedRectangle(cornerRadius: adaptyW(16))
                    .stroke(glowColor.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: glowColor.opacity(0.15), radius: adaptyW(12), x: 0, y: adaptyH(4))
    }
}
