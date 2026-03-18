import SwiftUI

enum TabItemRTG: Int, CaseIterable {
    case home = 0
    case journal = 1
    case search = 2
    case favorites = 3
    case settings = 4

    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .journal: return "book.fill"
        case .search: return "magnifyingglass"
        case .favorites: return "heart.fill"
        case .settings: return "gearshape.fill"
        }
    }

    var label: String {
        switch self {
        case .home: return "Home"
        case .journal: return "Journal"
        case .search: return "Search"
        case .favorites: return "Favorites"
        case .settings: return "Settings"
        }
    }
}

struct CustomTabBarRTG: View {
    @Binding var selectedTab: TabItemRTG
    @State private var animateTab: TabItemRTG? = nil
    @AppStorage("selectedThemeRTG") private var selectedTheme = "default"

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItemRTG.allCases, id: \.rawValue) { tab in
                tabButton(tab)
            }
        }
        .padding(.horizontal, adaptyW(8))
        .padding(.top, adaptyH(15))
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: adaptyW(16))
                    .fill(ColorThemeRTG.darkCard.opacity(0.95))

                RoundedRectangle(cornerRadius: adaptyW(16))
                    .stroke(ColorThemeRTG.cardBorder, lineWidth: 1)
            }
            .shadow(color: Color.black.opacity(0.4), radius: adaptyW(20), y: adaptyH(-5))
            .ignoresSafeArea(edges: .bottom)
        )
    }

    @ViewBuilder
    private func tabButton(_ tab: TabItemRTG) -> some View {
        let isSelected = selectedTab == tab
        Button(action: {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedTab = tab
                animateTab = tab
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                animateTab = nil
            }
        }) {
            VStack(spacing: adaptyH(4)) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(ColorThemeRTG.primaryOrange.opacity(0.15))
                            .frame(width: adaptyW(44), height: adaptyW(44))
                    }

                    Image(systemName: tab.iconName)
                        .font(.system(size: adaptyW(20), weight: isSelected ? .bold : .regular))
                        .foregroundStyle(isSelected ? ColorThemeRTG.primaryOrange : ColorThemeRTG.textSecondary)
                        .scaleEffect(animateTab == tab ? 1.2 : 1.0)
                }
                .frame(height: adaptyH(32))

                Text(tab.label)
                    .font(.system(size: adaptyW(10), weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? ColorThemeRTG.primaryOrange : ColorThemeRTG.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
