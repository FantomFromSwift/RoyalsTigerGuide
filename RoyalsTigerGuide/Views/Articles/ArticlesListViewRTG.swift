import SwiftUI
import SwiftData

struct ArticlesListViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Articles", showBack: true) {
                    dismiss()
                }

                ScrollView {
                    LazyVStack(spacing: adaptyH(14)) {
                        ForEach(viewModel.articles) { article in
                            NavigationLink(destination: ArticleDetailViewRTG(article: article, viewModel: viewModel)) {
                                articleRow(article)
                            }
                        }
                    }
                    .padding(.horizontal, adaptyW(16))
                    .padding(.top, adaptyH(16))
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(100))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBackWithSwipe()
    }

    @ViewBuilder
    private func articleRow(_ article: ArticleModelRTG) -> some View {
        GlowCardRTG(glowColor: ColorThemeRTG.primaryOrange) {
            HStack(spacing: adaptyW(14)) {
                Image(article.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: adaptyW(80), height: adaptyH(80))
                    .clipShape(RoundedRectangle(cornerRadius: adaptyW(14)))

                VStack(alignment: .leading, spacing: adaptyH(6)) {
                    Text(article.title)
                        .font(.system(size: adaptyW(14), weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(article.paragraphs.first?.prefix(80).appending("...") ?? "")
                        .font(.system(size: adaptyW(12)))
                        .foregroundStyle(ColorThemeRTG.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: adaptyW(14)))
                    .foregroundStyle(ColorThemeRTG.textSecondary)
            }
            .padding(adaptyW(12))
        }
    }
}
