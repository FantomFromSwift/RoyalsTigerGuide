import SwiftUI

struct SearchViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @State private var localSearch = ""

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Search")

                ScrollView {
                    VStack(spacing: adaptyH(16)) {
                        HStack(spacing: adaptyW(10)) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: adaptyW(16)))
                                .foregroundStyle(ColorThemeRTG.textSecondary)

                            TextField("", text: $localSearch, prompt: Text("Search articles, tasks, species...").foregroundStyle(ColorThemeRTG.textSecondary.opacity(0.5)))
                                .font(.system(size: adaptyW(15)))
                                .foregroundStyle(.white)
                                .autocorrectionDisabled()

                            if !localSearch.isEmpty {
                                Button(action: { localSearch = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: adaptyW(16)))
                                        .foregroundStyle(ColorThemeRTG.textSecondary)
                                }
                            }
                        }
                        .padding(adaptyW(14))
                        .background(
                            RoundedRectangle(cornerRadius: adaptyW(14))
                                .fill(ColorThemeRTG.darkCard)
                                .overlay(
                                    RoundedRectangle(cornerRadius: adaptyW(14))
                                        .stroke(ColorThemeRTG.cardBorder, lineWidth: 1)
                                )
                        )
                        .onChange(of: localSearch) { _, newValue in
                            viewModel.searchText = newValue
                        }

                        if !viewModel.filteredArticles.isEmpty {
                            sectionHeader(title: "Articles", count: viewModel.filteredArticles.count)

                            ForEach(viewModel.filteredArticles) { article in
                                NavigationLink(destination: ArticleDetailViewRTG(article: article, viewModel: viewModel)) {
                                    searchResultRow(
                                        title: article.title,
                                        subtitle: "Article",
                                        image: article.imageName,
                                        badge: "Read",
                                        badgeColor: ColorThemeRTG.primaryOrange
                                    )
                                }
                            }
                        }

                        if !viewModel.filteredTasks.isEmpty {
                            sectionHeader(title: "Field Tasks", count: viewModel.filteredTasks.count)

                            ForEach(viewModel.filteredTasks) { task in
                                NavigationLink(destination: TaskDetailViewRTG(task: task, viewModel: viewModel)) {
                                    searchResultRow(
                                        title: task.title,
                                        subtitle: task.subtitle,
                                        image: task.imageName,
                                        badge: "\(task.steps.count) Steps",
                                        badgeColor: ColorThemeRTG.emeraldAccent
                                    )
                                }
                            }
                        }

                        if !viewModel.filteredSpecies.isEmpty {
                            sectionHeader(title: "Tiger Species", count: viewModel.filteredSpecies.count)

                            ForEach(viewModel.filteredSpecies) { species in
                                NavigationLink(destination: TigerSpeciesDetailViewRTG(species: species)) {
                                    searchResultRow(
                                        title: species.name,
                                        subtitle: species.scientificName,
                                        image: species.imageName,
                                        badge: species.status,
                                        badgeColor: species.status.contains("Critically") ? ColorThemeRTG.dangerRed : ColorThemeRTG.secondaryGold
                                    )
                                }
                                .buttonStyle(.plain)
                            }
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
    private func sectionHeader(title: String, count: Int) -> some View {
        HStack {
            Text(title)
                .font(.system(size: adaptyW(18), weight: .bold))
                .foregroundStyle(.white)

            Spacer()

            Text("\(count)")
                .font(.system(size: adaptyW(13), weight: .semibold))
                .foregroundStyle(ColorThemeRTG.primaryOrange)
                .padding(.horizontal, adaptyW(10))
                .padding(.vertical, adaptyH(4))
                .background(
                    Capsule().fill(ColorThemeRTG.primaryOrange.opacity(0.15))
                )
        }
        .padding(.top, adaptyH(8))
    }

    @ViewBuilder
    private func searchResultRow(title: String, subtitle: String, image: String, badge: String, badgeColor: Color) -> some View {
        GlowCardRTG(glowColor: badgeColor.opacity(0.5)) {
            HStack(spacing: adaptyW(14)) {
                Image(image)
                    .resizable()
                    .frame(width: adaptyW(56), height: adaptyW(56))
                    .clipShape(RoundedRectangle(cornerRadius: adaptyW(12)))

                VStack(alignment: .leading, spacing: adaptyH(4)) {
                    Text(title)
                        .font(.system(size: adaptyW(14), weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text(subtitle)
                        .font(.system(size: adaptyW(12)))
                        .foregroundStyle(ColorThemeRTG.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                Spacer()

                Text(badge)
                    .font(.system(size: adaptyW(10), weight: .bold))
                    .foregroundStyle(badgeColor)
                    .minimumScaleFactor(0.8)
                    .padding(.horizontal, adaptyW(8))
                    .padding(.vertical, adaptyH(4))
                    .background(
                        Capsule().fill(badgeColor.opacity(0.15))
                    )
            }
            .padding(adaptyW(12))
        }
    }
}
