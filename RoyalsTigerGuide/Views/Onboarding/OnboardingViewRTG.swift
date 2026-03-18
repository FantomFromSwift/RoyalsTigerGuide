import SwiftUI
internal import StoreKit

struct OnboardingViewRTG: View {
    @State private var currentPage = 0
    var onFinish: () -> Void

    private let pages: [(image: String, title: String, subtitle: String)] = [
        ("onbOne", "Discover the Wild", "Explore the hidden world of tigers and big cats through interactive guides and rich content"),
        ("onbTwo", "Track and Learn", "Follow real tiger tracking techniques, analyze behaviors, and build your wildlife knowledge"),
        ("onbThree", "Test Your Skills", "Challenge yourself with quizzes, simulators, and hands-on conservation activities"),
        ("onbFour", "Join the Mission", "Become part of the global effort to protect and preserve wild tiger populations")
    ]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    onboardingPage(index: index)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private func onboardingPage(index: Int) -> some View {
        let page = pages[index]
        GeometryReader { geo in
            let safeBottom = max(geo.safeAreaInsets.bottom, adaptyH(16))
            let maxPanelHeight = geo.size.height * 0.3

            ZStack(alignment: .bottom) {
                Image(page.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .ignoresSafeArea()

                LinearGradient(
                    colors: [.clear, Color.black.opacity(0.3), Color.black.opacity(0.9)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .frame(width: geo.size.width, height: geo.size.height)
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

//                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: adaptyH(16)) {
                            HStack(spacing: adaptyW(8)) {
                                ForEach(0..<pages.count, id: \.self) { dotIndex in
                                    Capsule()
                                        .fill(dotIndex == currentPage ? ColorThemeRTG.primaryOrange : Color.white.opacity(0.3))
                                        .frame(
                                            width: dotIndex == currentPage ? adaptyW(28) : adaptyW(8),
                                            height: adaptyH(8)
                                        )
                                        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: currentPage)
                                }
                            }
                            .padding(.bottom, adaptyH(8))

                            Text(page.title)
                                .font(.system(size: adaptyW(28), weight: .bold))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)

                            Text(page.subtitle)
                                .font(.system(size: adaptyW(15), weight: .regular))
                                .foregroundStyle(Color.white.opacity(0.75))
                                .multilineTextAlignment(.center)
                                .lineSpacing(adaptyH(4))
                                .padding(.horizontal, adaptyW(20))
                                .fixedSize(horizontal: false, vertical: true)

                            AnimatedButtonRTG(title: index == pages.count - 1 ? "Get Started" : "Continue") {
                                if index == 2 {
                                    requestReview()
                                }
                                if index < pages.count - 1 {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentPage = index + 1
                                    }
                                } else {
                                    onFinish()
                                }
                            }
                            .padding(.horizontal, adaptyW(20))
                            .padding(.top, adaptyH(8))
                        }
                        .padding(.vertical, adaptyH(20))

                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: adaptyW(28))
                                .fill(Color.black.opacity(0.6))
                                .background(
                                    RoundedRectangle(cornerRadius: adaptyW(28))
                                        .fill(.ultraThinMaterial)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: adaptyW(28)))
                        )
                    .frame(maxHeight: maxPanelHeight)
                    .padding(.bottom, safeBottom + adaptyH(8))
                }
            }
        }
    }

    private func requestReview() {
        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}

#Preview {
    OnboardingViewRTG(onFinish: {})
}
