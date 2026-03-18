import SwiftUI
import SwiftData

struct TaskFinishViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.modelContext) private var modelContext
    @State private var showConfetti = false
    @State private var ringProgress: Double = 0

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Task Complete")

                ScrollView {
                    VStack(spacing: adaptyH(28)) {
                        Spacer().frame(height: adaptyH(20))

                        ZStack {
                            ProgressRingRTG(
                                progress: ringProgress,
                                lineWidth: adaptyW(8),
                                size: adaptyW(140),
                                color: ColorThemeRTG.emeraldAccent,
                                showsCenterLabel: false
                            )

                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: adaptyW(40)))
                                .foregroundStyle(ColorThemeRTG.emeraldAccent)
                                .scaleEffect(showConfetti ? 1.0 : 0.3)
                                .opacity(showConfetti ? 1.0 : 0.0)
                        }

                        VStack(spacing: adaptyH(8)) {
                            Text("Congratulations!")
                                .font(.system(size: adaptyW(28), weight: .heavy))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [ColorThemeRTG.secondaryGold, ColorThemeRTG.primaryOrange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                            if let task = viewModel.activeTask {
                                Text("You completed: \(task.title)")
                                    .font(.system(size: adaptyW(15)))
                                    .foregroundStyle(ColorThemeRTG.textSecondary)
                                    .multilineTextAlignment(.center)
                            }
                        }

                        if let task = viewModel.activeTask {
                            GlowCardRTG(glowColor: ColorThemeRTG.emeraldAccent) {
                                VStack(spacing: adaptyH(14)) {
                                    statRow(label: "Steps Completed", value: "\(task.steps.count)/\(task.steps.count)")
                                    Divider().background(ColorThemeRTG.cardBorder)
                                    statRow(label: "Time Spent", value: "~\(task.steps.count * 5) min")
                                    Divider().background(ColorThemeRTG.cardBorder)
                                    statRow(label: "Status", value: "Complete")
                                }
                                .padding(adaptyW(18))
                            }
                        }

                        AnimatedButtonRTG(title: "Back to Home", gradient: ColorThemeRTG.goldGradient) {
                            viewModel.returnToHomeRootAfterTask()
                        }
                    }
                    .padding(.horizontal, adaptyW(16))

                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(100))
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            saveCompletion()
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3)) {
                showConfetti = true
            }
            withAnimation(.easeInOut(duration: 1.2).delay(0.5)) {
                ringProgress = 1.0
            }
        }
    }

    @ViewBuilder
    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: adaptyW(14)))
                .foregroundStyle(ColorThemeRTG.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: adaptyW(14), weight: .bold))
                .foregroundStyle(ColorThemeRTG.emeraldAccent)
        }
    }

    private func saveCompletion() {
        guard let task = viewModel.activeTask else { return }
        let completion = TaskCompletionRTG(
            taskId: task.id,
            taskTitle: task.title,
            stepsCompleted: task.steps.count
        )
        modelContext.insert(completion)
    }
}
