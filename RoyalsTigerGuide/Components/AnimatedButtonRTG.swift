import SwiftUI

struct AnimatedButtonRTG: View {
    let title: String
    var gradient: LinearGradient = ColorThemeRTG.primaryGradient
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                action()
            }
        }) {
            Text(title)
                .font(.system(size: adaptyW(16), weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: adaptyH(52))
                .background(gradient)
                .clipShape(RoundedRectangle(cornerRadius: adaptyW(14)))
                .shadow(color: ColorThemeRTG.primaryOrange.opacity(0.4), radius: adaptyW(8), y: adaptyH(4))
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
    }
}
