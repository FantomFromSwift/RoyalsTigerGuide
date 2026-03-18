import SwiftUI

struct HomeViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @State private var heroIndex = 0
    @State private var animateHero = false

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "RoyalsTiger Guide")

                ScrollView {
                    VStack(spacing: adaptyH(24)) {
                        heroSection

                        featureGridSection

                        articlesSection

                        tasksSection

                        exploreMoreSection
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
    private var heroSection: some View {
        let heroArticle = viewModel.articles.isEmpty ? nil : viewModel.articles[heroIndex % max(viewModel.articles.count, 1)]

        if let article = heroArticle {
            NavigationLink(value: article) {
                ZStack(alignment: .bottomLeading) {
                    Image(article.imageName)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .frame(height: adaptyH(220))
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: adaptyW(20)))
                        .overlay(
                            RoundedRectangle(cornerRadius: adaptyW(20))
                                .fill(
                                    LinearGradient(
                                        colors: [.clear, Color.black.opacity(0.7)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        )
                        

                    VStack(alignment: .leading, spacing: adaptyH(6)) {
                        Text("FEATURED")
                            .font(.system(size: adaptyW(11), weight: .bold))
                            .foregroundStyle(ColorThemeRTG.secondaryGold)
                            .tracking(adaptyW(2))

                        Text(article.title)
                            .font(.system(size: adaptyW(18), weight: .bold))
                            .foregroundStyle(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .minimumScaleFactor(0.8)
                    }
                    .padding(adaptyW(16))
                }
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: adaptyW(20))
                        .stroke(ColorThemeRTG.primaryOrange.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: ColorThemeRTG.primaryOrange.opacity(0.2), radius: adaptyW(16), y: adaptyH(8))
            }
            .navigationDestination(for: ArticleModelRTG.self) { article in
                ArticleDetailViewRTG(article: article, viewModel: viewModel)
            }
        }
    }

    @ViewBuilder
    private var featureGridSection: some View {
        VStack(alignment: .leading, spacing: adaptyH(12)) {
            Text("Explore")
                .font(.system(size: adaptyW(20), weight: .bold))
                .foregroundStyle(.white)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: adaptyW(12)),
                GridItem(.flexible(), spacing: adaptyW(12))
            ], spacing: adaptyH(12)) {
                NavigationLink(destination: TigerEncyclopediaViewRTG(viewModel: viewModel)) {
                    featureCard(icon: "iconOne", title: "Encyclopedia", subtitle: "Tiger Species", color: ColorThemeRTG.primaryOrange)
                }
                NavigationLink(destination: PredatorSimulatorViewRTG(viewModel: viewModel)) {
                    featureCard(icon: "iconTwo", title: "Hunt Simulator", subtitle: "Predator AI", color: ColorThemeRTG.emeraldAccent)
                }
                NavigationLink(destination: TigerQuizViewRTG(viewModel: viewModel)) {
                    featureCard(icon: "iconThree", title: "Tiger Quiz", subtitle: "Test Knowledge", color: ColorThemeRTG.secondaryGold)
                }
                NavigationLink(destination: BehaviorLabViewRTG(viewModel: viewModel)) {
                    featureCard(icon: "iconFour", title: "Behavior Lab", subtitle: "Predict Patterns", color: Color(red: 0.6, green: 0.4, blue: 1.0))
                }
            }
        }
    }

    @ViewBuilder
    private func featureCard(icon: String, title: String, subtitle: String, color: Color) -> some View {
        GlowCardRTG(glowColor: color) {
            VStack(alignment: .leading, spacing: adaptyH(8)) {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: adaptyW(44), height: adaptyW(44))
                    .clipShape(RoundedRectangle(cornerRadius: adaptyW(12)))

                Text(title)
                    .font(.system(size: adaptyW(14), weight: .bold))
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(.system(size: adaptyW(11)))
                    .foregroundStyle(ColorThemeRTG.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(adaptyW(14))
        }
    }

    @ViewBuilder
    private var articlesSection: some View {
        VStack(alignment: .leading, spacing: adaptyH(12)) {
            HStack {
                Text("Articles")
                    .font(.system(size: adaptyW(20), weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                NavigationLink(destination: ArticlesListViewRTG(viewModel: viewModel)) {
                    Text("See All")
                        .font(.system(size: adaptyW(14), weight: .semibold))
                        .foregroundStyle(ColorThemeRTG.primaryOrange)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: adaptyW(14)) {
                    ForEach(viewModel.articles.prefix(5)) { article in
                        NavigationLink(value: article) {
                            articleCard(article)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private func articleCard(_ article: ArticleModelRTG) -> some View {
        VStack(alignment: .leading, spacing: adaptyH(8)) {
            Image(article.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: adaptyW(160), height: adaptyH(100))
                .clipShape(RoundedRectangle(cornerRadius: adaptyW(12)))

            Text(article.title)
                .font(.system(size: adaptyW(13), weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: adaptyW(160), alignment: .leading)
        }
        .padding(adaptyW(10))
        .background(
            RoundedRectangle(cornerRadius: adaptyW(14))
                .fill(ColorThemeRTG.darkCard.opacity(0.85))
        )
        .overlay(
            RoundedRectangle(cornerRadius: adaptyW(14))
                .stroke(ColorThemeRTG.cardBorder, lineWidth: 1)
        )
    }

    @ViewBuilder
    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: adaptyH(12)) {
            HStack {
                Text("Field Tasks")
                    .font(.system(size: adaptyW(20), weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                NavigationLink(destination: TasksListViewRTG(viewModel: viewModel)) {
                    Text("See All")
                        .font(.system(size: adaptyW(14), weight: .semibold))
                        .foregroundStyle(ColorThemeRTG.primaryOrange)
                }
            }

            ForEach(viewModel.tasks.prefix(3)) { task in
                NavigationLink(destination: TaskDetailViewRTG(task: task, viewModel: viewModel)) {
                    taskRow(task)
                }
            }
        }
    }

    @ViewBuilder
    private func taskRow(_ task: TaskModelRTG) -> some View {
        GlowCardRTG(glowColor: ColorThemeRTG.primaryOrange) {
            HStack(spacing: adaptyW(14)) {
                Image(task.iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: adaptyW(52), height: adaptyW(52))
                    .clipShape(RoundedRectangle(cornerRadius: adaptyW(14)))

                VStack(alignment: .leading, spacing: adaptyH(4)) {
                    Text(task.title)
                        .font(.system(size: adaptyW(15), weight: .bold))
                        .foregroundStyle(.white)

                    Text(task.subtitle)
                        .font(.system(size: adaptyW(12)))
                        .foregroundStyle(ColorThemeRTG.textSecondary)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: adaptyW(14), weight: .semibold))
                    .foregroundStyle(ColorThemeRTG.primaryOrange)
            }
            .padding(adaptyW(14))
        }
    }

    @ViewBuilder
    private var exploreMoreSection: some View {
        VStack(alignment: .leading, spacing: adaptyH(12)) {
            Text("More Adventures")
                .font(.system(size: adaptyW(20), weight: .bold))
                .foregroundStyle(.white)

            HStack(spacing: adaptyW(12)) {
                NavigationLink(destination: HabitatExplorerViewRTG(viewModel: viewModel)) {
                    exploreCard(title: "Habitats", subtitle: "Explore Regions", icon: "iconFive", color: ColorThemeRTG.emeraldAccent)
                }

                NavigationLink(destination: ConservationTrackerViewRTG(viewModel: viewModel)) {
                    exploreCard(title: "Conservation", subtitle: "Track Progress", icon: "iconSix", color: ColorThemeRTG.secondaryGold)
                }
            }
        }
    }

    @ViewBuilder
    private func exploreCard(title: String, subtitle: String, icon: String, color: Color) -> some View {
        GlowCardRTG(glowColor: color) {
            VStack(spacing: adaptyH(10)) {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: adaptyW(48), height: adaptyW(48))
                    .clipShape(Circle())

                Text(title)
                    .font(.system(size: adaptyW(14), weight: .bold))
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(.system(size: adaptyW(11)))
                    .foregroundStyle(ColorThemeRTG.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, adaptyH(16))
            .padding(.horizontal, adaptyW(12))
        }
    }
}


private enum HomeViewRTGPreviewData {
    static let articleThemes = ["themeOne", "themeTwo", "themeThree", "themeFour", "themeFive", "themeSix"]

    static func viewModel() -> ViewModelRTG {
        let vm = ViewModelRTG()
        vm.articles = (0..<6).map { i in
            ArticleModelRTG(
                id: "preview-article-\(i)",
                title: "Preview Article \(i + 1) — long title to stress horizontal strip layout",
                imageName: articleThemes[i % articleThemes.count],
                iconName: "iconOne",
                paragraphs: ["Preview body."]
            )
        }
        vm.tasks = (1...3).map { i in
            TaskModelRTG(
                id: "preview-task-\(i)",
                title: "Field Task \(i) with long title",
                subtitle: "Subtitle for canvas layout check",
                imageName: "themeOne",
                iconName: "iconTwo",
                steps: [TaskStepModelRTG(stepNumber: 1, title: "Step", description: "Desc")]
            )
        }
        return vm
    }
}

#Preview("Home — NavigationStack") {
    NavigationStack {
        HomeViewRTG(viewModel: HomeViewRTGPreviewData.viewModel())
    }
}

#Preview("Home — 393pt + red screen edge") {
    NavigationStack {
        HomeViewRTG(viewModel: HomeViewRTGPreviewData.viewModel())
    }
    .frame(width: 393, height: 852)
    .background(Color.black)
    .overlay {
        Rectangle()
            .strokeBorder(Color.red, lineWidth: 3)
    }
    .clipped()
}

#Preview("Home — vs Search width (side strip)") {
    HStack(spacing: 0) {
        Rectangle()
            .fill(Color.yellow.opacity(0.35))
            .frame(width: 20)

        NavigationStack {
            HomeViewRTG(viewModel: HomeViewRTGPreviewData.viewModel())
        }
        .frame(width: 353)

        Rectangle()
            .fill(Color.yellow.opacity(0.35))
            .frame(width: 20)
    }
    .frame(width: 393, height: 700)
    .background(Color.gray.opacity(0.3))
    .overlay {
        Rectangle()
            .strokeBorder(Color.red, lineWidth: 2)
    }
}
