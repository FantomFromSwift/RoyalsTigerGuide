import SwiftUI
import SwiftData

struct StatsViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.dismiss) private var dismiss
    @Query private var taskCompletions: [TaskCompletionRTG]
    @Query private var quizResults: [QuizResultRTG]
    @Query private var favorites: [FavoriteItemRTG]
    @Query private var journalEntries: [JournalEntryRTG]

    private var averageQuizScore: Double {
        guard !quizResults.isEmpty else { return 0 }
        let totalScore = quizResults.reduce(0) { $0 + $1.score }
        let totalQuestions = quizResults.reduce(0) { $0 + $1.totalQuestions }
        guard totalQuestions > 0 else { return 0 }
        return Double(totalScore) / Double(totalQuestions)
    }

    private var totalTaskSteps: Int {
        taskCompletions.reduce(0) { $0 + $1.stepsCompleted }
    }

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Statistics", showBack: true) { dismiss() }

                ScrollView {
                    VStack(spacing: adaptyH(20)) {
                        overviewSection

                        quizSection

                        activitySection

                        conservationSection
                    }
                    .padding(.horizontal, adaptyW(16))
                    .padding(.top, adaptyH(12))

                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(100))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBackWithSwipe()
    }

    @ViewBuilder
    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: adaptyH(12)) {
            Text("Overview")
                .font(.system(size: adaptyW(20), weight: .bold))
                .foregroundStyle(.white)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: adaptyW(12)),
                GridItem(.flexible(), spacing: adaptyW(12))
            ], spacing: adaptyH(12)) {
                statCard(value: "\(taskCompletions.count)", label: "Tasks Done", icon: "checkmark.circle.fill", color: ColorThemeRTG.emeraldAccent)
                statCard(value: "\(quizResults.count)", label: "Quizzes Taken", icon: "brain.head.profile", color: ColorThemeRTG.secondaryGold)
                statCard(value: "\(favorites.count)", label: "Favorites", icon: "heart.fill", color: ColorThemeRTG.dangerRed)
                statCard(value: "\(journalEntries.count)", label: "Journal Entries", icon: "book.fill", color: ColorThemeRTG.primaryOrange)
            }
        }
    }

    @ViewBuilder
    private func statCard(value: String, label: String, icon: String, color: Color) -> some View {
        GlowCardRTG(glowColor: color) {
            VStack(spacing: adaptyH(8)) {
                Image(systemName: icon)
                    .font(.system(size: adaptyW(24)))
                    .foregroundStyle(color)

                Text(value)
                    .font(.system(size: adaptyW(28), weight: .heavy))
                    .foregroundStyle(.white)

                Text(label)
                    .font(.system(size: adaptyW(11)))
                    .foregroundStyle(ColorThemeRTG.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, adaptyH(16))
        }
    }

    @ViewBuilder
    private var quizSection: some View {
        VStack(alignment: .leading, spacing: adaptyH(12)) {
            Text("Quiz Performance")
                .font(.system(size: adaptyW(20), weight: .bold))
                .foregroundStyle(.white)

            GlowCardRTG(glowColor: ColorThemeRTG.secondaryGold) {
                VStack(spacing: adaptyH(16)) {
                    HStack {
                        ProgressRingRTG(
                            progress: averageQuizScore,
                            lineWidth: adaptyW(6),
                            size: adaptyW(80),
                            color: ColorThemeRTG.secondaryGold
                        )

                        Spacer()

                        VStack(alignment: .trailing, spacing: adaptyH(8)) {
                            VStack(alignment: .trailing, spacing: adaptyH(2)) {
                                Text("Average Score")
                                    .font(.system(size: adaptyW(12)))
                                    .foregroundStyle(ColorThemeRTG.textSecondary)

                                Text("\(Int(averageQuizScore * 100))%")
                                    .font(.system(size: adaptyW(24), weight: .bold))
                                    .foregroundStyle(ColorThemeRTG.secondaryGold)
                            }

                            VStack(alignment: .trailing, spacing: adaptyH(2)) {
                                Text("Total Steps")
                                    .font(.system(size: adaptyW(12)))
                                    .foregroundStyle(ColorThemeRTG.textSecondary)

                                Text("\(totalTaskSteps)")
                                    .font(.system(size: adaptyW(20), weight: .bold))
                                    .foregroundStyle(ColorThemeRTG.emeraldAccent)
                            }
                        }
                    }

                    if !quizResults.isEmpty {
                        VStack(spacing: adaptyH(6)) {
                            ForEach(quizResults.suffix(5)) { result in
                                HStack {
                                    Text(result.dateCompleted, format: .dateTime.month().day())
                                        .font(.system(size: adaptyW(12)))
                                        .foregroundStyle(ColorThemeRTG.textSecondary)

                                    Spacer()

                                    Text("\(result.score)/\(result.totalQuestions)")
                                        .font(.system(size: adaptyW(13), weight: .semibold))
                                        .foregroundStyle(.white)

                                    barIndicator(ratio: Double(result.score) / Double(max(result.totalQuestions, 1)))
                                }
                            }
                        }
                    }
                }
                .padding(adaptyW(18))
            }
        }
    }

    @ViewBuilder
    private func barIndicator(ratio: Double) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: adaptyW(3))
                    .fill(ColorThemeRTG.darkCard)

                RoundedRectangle(cornerRadius: adaptyW(3))
                    .fill(ratio > 0.7 ? ColorThemeRTG.emeraldAccent : ratio > 0.4 ? ColorThemeRTG.secondaryGold : ColorThemeRTG.dangerRed)
                    .frame(width: geometry.size.width * min(ratio, 1.0))
            }
        }
        .frame(width: adaptyW(60), height: adaptyH(6))
    }

    @ViewBuilder
    private var activitySection: some View {
        VStack(alignment: .leading, spacing: adaptyH(12)) {
            Text("Recent Activity")
                .font(.system(size: adaptyW(20), weight: .bold))
                .foregroundStyle(.white)

            if taskCompletions.isEmpty && quizResults.isEmpty {
                GlowCardRTG(glowColor: ColorThemeRTG.textSecondary) {
                    Text("Complete tasks and quizzes to see your activity here")
                        .font(.system(size: adaptyW(14)))
                        .foregroundStyle(ColorThemeRTG.textSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(adaptyW(20))
                }
            } else {
                ForEach(taskCompletions.suffix(3)) { completion in
                    HStack(spacing: adaptyW(12)) {
                        ZStack {
                            Circle()
                                .fill(ColorThemeRTG.emeraldAccent.opacity(0.15))
                                .frame(width: adaptyW(36), height: adaptyW(36))

                            Image(systemName: "checkmark")
                                .font(.system(size: adaptyW(14), weight: .bold))
                                .foregroundStyle(ColorThemeRTG.emeraldAccent)
                        }

                        VStack(alignment: .leading, spacing: adaptyH(2)) {
                            Text(completion.taskTitle)
                                .font(.system(size: adaptyW(14), weight: .semibold))
                                .foregroundStyle(.white)
                                .lineLimit(1)

                            Text(completion.dateCompleted, format: .dateTime.month().day().hour().minute())
                                .font(.system(size: adaptyW(11)))
                                .foregroundStyle(ColorThemeRTG.textSecondary)
                        }

                        Spacer()
                    }
                    .padding(adaptyW(12))
                    .background(
                        RoundedRectangle(cornerRadius: adaptyW(12))
                            .fill(ColorThemeRTG.darkCard.opacity(0.7))
                    )
                }
            }
        }
    }

    @ViewBuilder
    private var conservationSection: some View {
        VStack(alignment: .leading, spacing: adaptyH(12)) {
            Text("Conservation Impact")
                .font(.system(size: adaptyW(20), weight: .bold))
                .foregroundStyle(.white)

            GlowCardRTG(glowColor: ColorThemeRTG.emeraldAccent) {
                VStack(spacing: adaptyH(12)) {
                    HStack {
                        Text("Total Supports")
                            .font(.system(size: adaptyW(14)))
                            .foregroundStyle(ColorThemeRTG.textSecondary)

                        Spacer()

                        Text("\(viewModel.totalConservationImpact)")
                            .font(.system(size: adaptyW(24), weight: .bold))
                            .foregroundStyle(ColorThemeRTG.emeraldAccent)
                    }

                    ProgressRingRTG(
                        progress: min(Double(viewModel.totalConservationImpact) / 100.0, 1.0),
                        lineWidth: adaptyW(8),
                        size: adaptyW(100),
                        color: ColorThemeRTG.emeraldAccent
                    )
                }
                .padding(adaptyW(18))
            }
        }
    }
}
