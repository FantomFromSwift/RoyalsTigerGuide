import SwiftUI
import SwiftData

struct FavoritesViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteItemRTG.dateAdded, order: .reverse) private var favorites: [FavoriteItemRTG]
    @Query private var taskCompletions: [TaskCompletionRTG]
    @Query private var quizResults: [QuizResultRTG]

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Favorites")

                ScrollView {
                    VStack(spacing: adaptyH(16)) {
                        statsOverview

                        if favorites.isEmpty {
                            emptyState
                        } else {
                            favoritesSection(type: "article", label: "Saved Articles")
                            favoritesSection(type: "task", label: "Saved Tasks")
                            favoritesSection(type: "species", label: "Saved Species")
                        }
                    }
                    .padding(.horizontal, adaptyW(16))
                    .padding(.top, adaptyH(12))
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(120))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }

    @ViewBuilder
    private var statsOverview: some View {
        GlowCardRTG(glowColor: ColorThemeRTG.secondaryGold) {
            HStack(spacing: 0) {
                quickStat(value: "\(favorites.count)", label: "Saved", color: ColorThemeRTG.primaryOrange)

                Rectangle()
                    .fill(ColorThemeRTG.cardBorder)
                    .frame(width: 1, height: adaptyH(40))

                quickStat(value: "\(taskCompletions.count)", label: "Tasks Done", color: ColorThemeRTG.emeraldAccent)

                Rectangle()
                    .fill(ColorThemeRTG.cardBorder)
                    .frame(width: 1, height: adaptyH(40))

                quickStat(value: "\(quizResults.count)", label: "Quizzes", color: ColorThemeRTG.secondaryGold)
            }
            .padding(.vertical, adaptyH(16))
        }
    }

    @ViewBuilder
    private func quickStat(value: String, label: String, color: Color) -> some View {
        VStack(spacing: adaptyH(4)) {
            Text(value)
                .font(.system(size: adaptyW(22), weight: .bold))
                .foregroundStyle(color)

            Text(label)
                .font(.system(size: adaptyW(11)))
                .foregroundStyle(ColorThemeRTG.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var emptyState: some View {
        VStack(spacing: adaptyH(12)) {
            Image(systemName: "heart.slash")
                .font(.system(size: adaptyW(48)))
                .foregroundStyle(ColorThemeRTG.textSecondary.opacity(0.5))

            Text("No favorites yet")
                .font(.system(size: adaptyW(18), weight: .medium))
                .foregroundStyle(ColorThemeRTG.textSecondary)

            Text("Tap the heart icon on articles and tasks to save them here")
                .font(.system(size: adaptyW(13)))
                .foregroundStyle(ColorThemeRTG.textSecondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(.top, adaptyH(60))
    }

    @ViewBuilder
    private func favoritesSection(type: String, label: String) -> some View {
        let filtered = favorites.filter { $0.itemType == type }
        if !filtered.isEmpty {
            VStack(alignment: .leading, spacing: adaptyH(10)) {
                Text(label)
                    .font(.system(size: adaptyW(18), weight: .bold))
                    .foregroundStyle(.white)

                ForEach(filtered) { fav in
                    favRow(fav)
                }
            }
        }
    }

    @ViewBuilder
    private func favRow(_ fav: FavoriteItemRTG) -> some View {
        if fav.itemType == "article", let article = viewModel.article(byId: fav.itemId) {
            articleFavoriteRow(fav: fav, article: article)
        } else {
            staticFavoriteRow(fav)
        }
    }

    @ViewBuilder
    private func articleFavoriteRow(fav: FavoriteItemRTG, article: ArticleModelRTG) -> some View {
        GlowCardRTG(glowColor: ColorThemeRTG.primaryOrange) {
            HStack(spacing: adaptyW(14)) {
                NavigationLink {
                    ArticleDetailViewRTG(article: article, viewModel: viewModel)
                } label: {
                    HStack(spacing: adaptyW(14)) {
                        Image(fav.itemImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: adaptyW(52), height: adaptyW(52))
                            .clipShape(RoundedRectangle(cornerRadius: adaptyW(12)))

                        VStack(alignment: .leading, spacing: adaptyH(4)) {
                            Text(fav.itemTitle)
                                .font(.system(size: adaptyW(14), weight: .bold))
                                .foregroundStyle(.white)
                                .lineLimit(1)

                            Text(fav.dateAdded, format: .dateTime.month().day())
                                .font(.system(size: adaptyW(11)))
                                .foregroundStyle(ColorThemeRTG.textSecondary)
                        }

                        Spacer(minLength: 0)

                        Image(systemName: "chevron.right")
                            .font(.system(size: adaptyW(12), weight: .semibold))
                            .foregroundStyle(ColorThemeRTG.textSecondary.opacity(0.6))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                Button(action: { modelContext.delete(fav) }) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: adaptyW(18)))
                        .foregroundStyle(ColorThemeRTG.dangerRed)
                }
                .buttonStyle(.borderless)
            }
            .padding(adaptyW(12))
        }
    }

    @ViewBuilder
    private func staticFavoriteRow(_ fav: FavoriteItemRTG) -> some View {
        GlowCardRTG(glowColor: ColorThemeRTG.primaryOrange) {
            HStack(spacing: adaptyW(14)) {
                Image(fav.itemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: adaptyW(52), height: adaptyW(52))
                    .clipShape(RoundedRectangle(cornerRadius: adaptyW(12)))

                VStack(alignment: .leading, spacing: adaptyH(4)) {
                    Text(fav.itemTitle)
                        .font(.system(size: adaptyW(14), weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    Text(fav.dateAdded, format: .dateTime.month().day())
                        .font(.system(size: adaptyW(11)))
                        .foregroundStyle(ColorThemeRTG.textSecondary)
                }

                Spacer()

                Button(action: { modelContext.delete(fav) }) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: adaptyW(18)))
                        .foregroundStyle(ColorThemeRTG.dangerRed)
                }
            }
            .padding(adaptyW(12))
        }
    }
}
