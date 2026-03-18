import SwiftUI

struct TaskStepViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToFinish = false
    @State private var animateStep = false

    private var currentStep: TaskStepModelRTG? {
        guard let task = viewModel.activeTask else { return nil }
        guard viewModel.currentTaskStepIndex < task.steps.count else { return nil }
        return task.steps[viewModel.currentTaskStepIndex]
    }

    private var totalSteps: Int {
        viewModel.activeTask?.steps.count ?? 6
    }

    private var progress: Double {
        Double(viewModel.currentTaskStepIndex + 1) / Double(totalSteps)
    }

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Step \(viewModel.currentTaskStepIndex + 1) of \(totalSteps)", showBack: true) {
                    dismiss()
                }

                ScrollView {
                    if let step = currentStep {
                        VStack(spacing: adaptyH(24)) {
                            progressBar

                            VStack(spacing: adaptyH(16)) {
                                ZStack {
                                    Circle()
                                        .fill(ColorThemeRTG.primaryOrange.opacity(0.15))
                                        .frame(width: adaptyW(80), height: adaptyW(80))

                                    Circle()
                                        .stroke(ColorThemeRTG.primaryOrange.opacity(0.3), lineWidth: adaptyW(2))
                                        .frame(width: adaptyW(80), height: adaptyW(80))

                                    Text("\(step.stepNumber)")
                                        .font(.system(size: adaptyW(32), weight: .heavy))
                                        .foregroundStyle(ColorThemeRTG.primaryOrange)
                                }
                                .scaleEffect(animateStep ? 1.0 : 0.5)
                                .opacity(animateStep ? 1.0 : 0.0)

                                Text(step.title)
                                    .font(.system(size: adaptyW(22), weight: .bold))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .offset(y: animateStep ? 0 : adaptyH(20))
                                    .opacity(animateStep ? 1.0 : 0.0)
                            }

                            GlowCardRTG(glowColor: ColorThemeRTG.primaryOrange) {
                                Text(step.description)
                                    .font(.system(size: adaptyW(15)))
                                    .foregroundStyle(Color.white.opacity(0.85))
                                    .lineSpacing(adaptyH(6))
                                    .padding(adaptyW(18))
                            }
                            .opacity(animateStep ? 1.0 : 0.0)

                            if let task = viewModel.activeTask {
                                Image(task.imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: adaptyH(180))
                                    .clipShape(RoundedRectangle(cornerRadius: adaptyW(16)))
                                    .opacity(0.8)
                            }

                            if viewModel.currentTaskStepIndex < totalSteps - 1 {
                                AnimatedButtonRTG(title: "Next Step") {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        animateStep = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        viewModel.nextTaskStep()
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                            animateStep = true
                                        }
                                    }
                                }
                            } else {
                                AnimatedButtonRTG(title: "Complete Task", gradient: ColorThemeRTG.goldGradient) {
                                    navigateToFinish = true
                                }
                            }
                        }
                        .padding(.horizontal, adaptyW(16))
                        .padding(.top, adaptyH(12))

                    }
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(100))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBackWithSwipe()
        .navigationDestination(isPresented: $navigateToFinish) {
            TaskFinishViewRTG(viewModel: viewModel)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                animateStep = true
            }
        }
    }

    @ViewBuilder
    private var progressBar: some View {
        VStack(spacing: adaptyH(8)) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: adaptyW(4))
                        .fill(ColorThemeRTG.darkCard)
                        .frame(height: adaptyH(8))

                    RoundedRectangle(cornerRadius: adaptyW(4))
                        .fill(ColorThemeRTG.primaryGradient)
                        .frame(width: geometry.size.width * progress, height: adaptyH(8))
                        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: progress)
                }
            }
            .frame(height: adaptyH(8))

            HStack {
                ForEach(1...totalSteps, id: \.self) { stepNum in
                    Circle()
                        .fill(stepNum <= viewModel.currentTaskStepIndex + 1 ? ColorThemeRTG.primaryOrange : ColorThemeRTG.darkCard)
                        .frame(width: adaptyW(10), height: adaptyW(10))
                        .overlay(
                            Circle()
                                .stroke(ColorThemeRTG.primaryOrange.opacity(0.3), lineWidth: 1)
                        )

                    if stepNum < totalSteps {
                        Spacer()
                    }
                }
            }
        }
    }
}
