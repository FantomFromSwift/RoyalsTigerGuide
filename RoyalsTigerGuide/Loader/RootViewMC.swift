import SwiftUI

struct RootViewMC: View {
    @EnvironmentObject private var vm: LoaderViewModel
    @AppStorage("hasSeenOnboardingRTG") private var hasSeenOnboarding = false
    @State private var showSplash = true
    @State private var showOnboarding = false
    var body: some View {
        ZStack {
            switch vm.presented {
            case .splash:
                SplashViewRTG {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSplash = false
                        if !hasSeenOnboarding {
                            showOnboarding = true
                        }
                    }
                }
            case .main:
                MainTabViewRTG()
                
            case .changed:
                LoaderPageView(loaderViewModel: vm, url: vm.mailLink ?? vm.link)
                    .onAppear {
                        AppDelegate.orientationLock = [.portrait, .landscapeLeft, .landscapeRight]
                    }
            }
        }
    }
}
