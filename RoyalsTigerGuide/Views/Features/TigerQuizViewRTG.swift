import SwiftUI
import SwiftData

struct TigerQuizViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var animateOption = false

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Tiger Quiz", showBack: true) { dismiss() }

                if viewModel.quizFinished {
                    quizResultView
                } else if !viewModel.quizQuestions.isEmpty {
                    questionView
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBackWithSwipe()
        .onAppear {
            viewModel.resetQuiz()
        }
    }

    @ViewBuilder
    private var questionView: some View {
        let question = viewModel.quizQuestions[viewModel.currentQuizIndex]

        ScrollView {
            VStack(spacing: adaptyH(20)) {
                HStack {
                    Text("Question \(viewModel.currentQuizIndex + 1)/\(viewModel.quizQuestions.count)")
                        .font(.system(size: adaptyW(14), weight: .semibold))
                        .foregroundStyle(ColorThemeRTG.primaryOrange)

                    Spacer()

                    HStack(spacing: adaptyW(4)) {
                        Image(systemName: "star.fill")
                            .font(.system(size: adaptyW(14)))
                            .foregroundStyle(ColorThemeRTG.secondaryGold)

                        Text("\(viewModel.quizScore)")
                            .font(.system(size: adaptyW(16), weight: .bold))
                            .foregroundStyle(.white)
                    }
                }

                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: adaptyW(4))
                            .fill(ColorThemeRTG.darkCard)

                        RoundedRectangle(cornerRadius: adaptyW(4))
                            .fill(ColorThemeRTG.primaryGradient)
                            .frame(width: geometry.size.width * Double(viewModel.currentQuizIndex + 1) / Double(viewModel.quizQuestions.count))
                            .animation(.spring(response: 0.5), value: viewModel.currentQuizIndex)
                    }
                }
                .frame(height: adaptyH(6))

                GlowCardRTG(glowColor: ColorThemeRTG.secondaryGold) {
                    Text(question.question)
                        .font(.system(size: adaptyW(18), weight: .bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(adaptyH(4))
                        .padding(adaptyW(20))
                }

                VStack(spacing: adaptyH(10)) {
                    ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                        Button(action: { viewModel.answerQuiz(index) }) {
                            optionButton(option, index: index, question: question)
                        }
                        .disabled(viewModel.quizAnswered)
                    }
                }

                if viewModel.quizAnswered {
                    GlowCardRTG(glowColor: viewModel.quizSelectedIndex == question.correctIndex ? ColorThemeRTG.emeraldAccent : ColorThemeRTG.dangerRed) {
                        VStack(spacing: adaptyH(8)) {
                            HStack(spacing: adaptyW(8)) {
                                Image(systemName: viewModel.quizSelectedIndex == question.correctIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .font(.system(size: adaptyW(20)))
                                    .foregroundStyle(viewModel.quizSelectedIndex == question.correctIndex ? ColorThemeRTG.emeraldAccent : ColorThemeRTG.dangerRed)

                                Text(viewModel.quizSelectedIndex == question.correctIndex ? "Correct!" : "Incorrect")
                                    .font(.system(size: adaptyW(16), weight: .bold))
                                    .foregroundStyle(.white)
                            }

                            Text(question.explanation)
                                .font(.system(size: adaptyW(13)))
                                .foregroundStyle(Color.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .lineSpacing(adaptyH(3))
                        }
                        .padding(adaptyW(16))
                    }

                    AnimatedButtonRTG(
                        title: viewModel.currentQuizIndex < viewModel.quizQuestions.count - 1 ? "Next Question" : "See Results"
                    ) {
                        viewModel.nextQuizQuestion()
                    }
                }
            }
            .padding(.horizontal, adaptyW(16))
            .padding(.top, adaptyH(12))
        }
        .scrollIndicators(.hidden)
        .contentMargins(.bottom, adaptyH(100))
    }

    @ViewBuilder
    private func optionButton(_ option: String, index: Int, question: QuizQuestionModelRTG) -> some View {
        let isSelected = viewModel.quizSelectedIndex == index
        let isCorrect = index == question.correctIndex
        let showFeedback = viewModel.quizAnswered

        HStack(spacing: adaptyW(12)) {
            ZStack {
                Circle()
                    .fill(backgroundColor(isSelected: isSelected, isCorrect: isCorrect, showFeedback: showFeedback))
                    .frame(width: adaptyW(32), height: adaptyW(32))

                Text("\(Character(UnicodeScalar(65 + index)!))")
                    .font(.system(size: adaptyW(14), weight: .bold))
                    .foregroundStyle(.white)
            }

            Text(option)
                .font(.system(size: adaptyW(15), weight: .medium))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)

            Spacer()

            if showFeedback {
                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: adaptyW(20)))
                        .foregroundStyle(ColorThemeRTG.emeraldAccent)
                } else if isSelected {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: adaptyW(20)))
                        .foregroundStyle(ColorThemeRTG.dangerRed)
                }
            }
        }
        .padding(adaptyW(14))
        .background(
            RoundedRectangle(cornerRadius: adaptyW(14))
                .fill(cardBackground(isSelected: isSelected, isCorrect: isCorrect, showFeedback: showFeedback))
                .overlay(
                    RoundedRectangle(cornerRadius: adaptyW(14))
                        .stroke(borderColor(isSelected: isSelected, isCorrect: isCorrect, showFeedback: showFeedback), lineWidth: 1)
                )
        )
    }

    private func backgroundColor(isSelected: Bool, isCorrect: Bool, showFeedback: Bool) -> Color {
        if showFeedback && isCorrect { return ColorThemeRTG.emeraldAccent }
        if showFeedback && isSelected { return ColorThemeRTG.dangerRed }
        return ColorThemeRTG.primaryOrange.opacity(0.3)
    }

    private func cardBackground(isSelected: Bool, isCorrect: Bool, showFeedback: Bool) -> Color {
        if showFeedback && isCorrect { return ColorThemeRTG.emeraldAccent.opacity(0.1) }
        if showFeedback && isSelected { return ColorThemeRTG.dangerRed.opacity(0.1) }
        return ColorThemeRTG.darkCard.opacity(0.85)
    }

    private func borderColor(isSelected: Bool, isCorrect: Bool, showFeedback: Bool) -> Color {
        if showFeedback && isCorrect { return ColorThemeRTG.emeraldAccent.opacity(0.5) }
        if showFeedback && isSelected { return ColorThemeRTG.dangerRed.opacity(0.5) }
        return ColorThemeRTG.cardBorder
    }

    @ViewBuilder
    private var quizResultView: some View {
        ScrollView {
            VStack(spacing: adaptyH(24)) {
                Spacer().frame(height: adaptyH(20))

                ProgressRingRTG(
                    progress: Double(viewModel.quizScore) / Double(max(viewModel.quizQuestions.count, 1)),
                    lineWidth: adaptyW(10),
                    size: adaptyW(160),
                    color: viewModel.quizScore > viewModel.quizQuestions.count / 2 ? ColorThemeRTG.emeraldAccent : ColorThemeRTG.secondaryGold
                )

                VStack(spacing: adaptyH(8)) {
                    Text(resultTitle)
                        .font(.system(size: adaptyW(26), weight: .heavy))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [ColorThemeRTG.secondaryGold, ColorThemeRTG.primaryOrange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("You scored \(viewModel.quizScore) out of \(viewModel.quizQuestions.count)")
                        .font(.system(size: adaptyW(16)))
                        .foregroundStyle(ColorThemeRTG.textSecondary)
                }

                GlowCardRTG(glowColor: ColorThemeRTG.emeraldAccent) {
                    VStack(spacing: adaptyH(10)) {
                        resultRow(label: "Correct Answers", value: "\(viewModel.quizScore)")
                        Divider().background(ColorThemeRTG.cardBorder)
                        resultRow(label: "Incorrect", value: "\(viewModel.quizQuestions.count - viewModel.quizScore)")
                        Divider().background(ColorThemeRTG.cardBorder)
                        resultRow(label: "Accuracy", value: "\(Int(Double(viewModel.quizScore) / Double(max(viewModel.quizQuestions.count, 1)) * 100))%")
                    }
                    .padding(adaptyW(18))
                }

                AnimatedButtonRTG(title: "Try Again") {
                    viewModel.resetQuiz()
                }

                AnimatedButtonRTG(title: "Back to Home", gradient: ColorThemeRTG.goldGradient) {
                    saveResult()
                    dismiss()
                }
            }
            .padding(.horizontal, adaptyW(16))
        }
        .scrollIndicators(.hidden)
        .contentMargins(.bottom, adaptyH(100))
        .onAppear { saveResult() }
    }

    private var resultTitle: String {
        let ratio = Double(viewModel.quizScore) / Double(max(viewModel.quizQuestions.count, 1))
        if ratio >= 0.9 { return "Tiger Expert!" }
        if ratio >= 0.7 { return "Great Job!" }
        if ratio >= 0.5 { return "Good Effort!" }
        return "Keep Learning!"
    }

    @ViewBuilder
    private func resultRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: adaptyW(14)))
                .foregroundStyle(ColorThemeRTG.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: adaptyW(14), weight: .bold))
                .foregroundStyle(.white)
        }
    }

    private func saveResult() {
        let result = QuizResultRTG(
            score: viewModel.quizScore,
            totalQuestions: viewModel.quizQuestions.count
        )
        modelContext.insert(result)
    }
}
