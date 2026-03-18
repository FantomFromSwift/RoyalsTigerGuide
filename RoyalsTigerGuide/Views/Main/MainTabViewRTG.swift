import SwiftUI

struct MainTabViewRTG: View {
    @State var selectedTab: TabItemRTG = .home
    @State var viewModel = ViewModelRTG()
    @AppStorage("selectedThemeRTG") private var selectedTheme = "default"

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    NavigationStack {
                        HomeViewRTG(viewModel: viewModel)
                    }
                    .id(viewModel.navigationRootRevision)
                case .journal:
                    NavigationStack {
                        JournalViewRTG()
                    }
                    .id(viewModel.navigationRootRevision)
                case .search:
                    NavigationStack {
                        SearchViewRTG(viewModel: viewModel)
                    }
                    .id(viewModel.navigationRootRevision)
                case .favorites:
                    NavigationStack {
                        FavoritesViewRTG(viewModel: viewModel)
                    }
                    .id(viewModel.navigationRootRevision)
                case .settings:
                    NavigationStack {
                        SettingsViewRTG(viewModel: viewModel)
                    }
                    .id(viewModel.navigationRootRevision)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBarRTG(selectedTab: $selectedTab)
        }
        .onChange(of: viewModel.navigationRootRevision) { _, _ in
            guard viewModel.shouldSelectHomeTabAfterNavReset else { return }
            viewModel.consumeHomeTabSelectionAfterNavReset()
            withAnimation(.easeInOut(duration: 0.35)) {
                selectedTab = .home
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}
