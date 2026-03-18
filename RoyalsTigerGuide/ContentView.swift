import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboardingRTG") private var hasSeenOnboarding = false
    @State private var showSplash = true
    @State private var showOnboarding = false

    var body: some View {
        ZStack {
            if showSplash {
                SplashViewRTG {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSplash = false
                        if !hasSeenOnboarding {
                            showOnboarding = true
                        }
                    }
                }
                .transition(.opacity)
            } else if showOnboarding {
                OnboardingViewRTG {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        hasSeenOnboarding = true
                        showOnboarding = false
                    }
                }
                .transition(.opacity)
            } else {
                MainTabViewRTG()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showSplash)
        .animation(.easeInOut(duration: 0.4), value: showOnboarding)
    }
}
