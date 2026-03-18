import SwiftUI
import SwiftData

struct ArticleDetailViewRTG: View {
    let article: ArticleModelRTG
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteItemRTG]
    @State private var showHeart = false

    private var isFavorited: Bool {
        favorites.contains { $0.itemId == article.id }
    }

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Article", showBack: true) {
                    dismiss()
                }

                ScrollView {
                    VStack(spacing: adaptyH(20)) {
                        ZStack(alignment: .topTrailing) {
                            Image(article.imageName)
                                .resizable()
                                .frame(height: adaptyH(240))
                                .clipShape(RoundedRectangle(cornerRadius: adaptyW(20)))
                                .overlay(
                                    RoundedRectangle(cornerRadius: adaptyW(20))
                                        .stroke(ColorThemeRTG.primaryOrange.opacity(0.3), lineWidth: 1)
                                )

                            Button(action: toggleFavorite) {
                                ZStack {
                                    Circle()
                                        .fill(Color.black.opacity(0.5))
                                        .frame(width: adaptyW(42), height: adaptyW(42))

                                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                                        .font(.system(size: adaptyW(20)))
                                        .foregroundStyle(isFavorited ? ColorThemeRTG.dangerRed : .white)
                                        .scaleEffect(showHeart ? 1.3 : 1.0)
                                }
                            }
                            .padding(adaptyW(14))
                        }

                        Text(article.title)
                            .font(.system(size: adaptyW(22), weight: .bold))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ForEach(Array(article.paragraphs.enumerated()), id: \.offset) { index, paragraph in
                            VStack(spacing: adaptyH(20)) {
                                HStack(alignment: .top, spacing: adaptyW(16)) {
                                    RoundedRectangle(cornerRadius: adaptyW(2))
                                        .fill(LinearGradient(
                                            colors: [ColorThemeRTG.primaryOrange, ColorThemeRTG.primaryOrange.opacity(0.3)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ))
                                        .frame(width: adaptyW(4))
                                        .padding(.vertical, adaptyH(4))

                                    Text(paragraph)
                                        .font(.system(size: adaptyW(16), weight: .regular))
                                        .foregroundStyle(Color.white.opacity(0.9))
                                        .lineSpacing(adaptyH(8))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(adaptyW(18))
                                .background(
                                    RoundedRectangle(cornerRadius: adaptyW(20))
                                        .fill(Color.white.opacity(0.05))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: adaptyW(20))
                                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                )

                                if index < article.paragraphs.count - 1 {
                                    LinearGradient(
                                        colors: [.clear, ColorThemeRTG.primaryOrange.opacity(0.5), .clear],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                    .frame(height: 1)
                                    .padding(.horizontal, adaptyW(30))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, adaptyW(16))
                    .padding(.top, adaptyH(12))
                }
                .scrollIndicators(.hidden)
                .padding(.bottom, adaptyH(100))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBackWithSwipe()
    }

    private func toggleFavorite() {
        if let existing = favorites.first(where: { $0.itemId == article.id }) {
            modelContext.delete(existing)
        } else {
            let fav = FavoriteItemRTG(itemId: article.id, itemType: "article", itemTitle: article.title, itemImage: article.imageName)
            modelContext.insert(fav)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                showHeart = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation { showHeart = false }
            }
        }
    }
}
