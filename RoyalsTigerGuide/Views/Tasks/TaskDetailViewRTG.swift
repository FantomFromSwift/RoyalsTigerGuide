import SwiftUI
import SwiftData

struct TaskDetailViewRTG: View {
    let task: TaskModelRTG
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteItemRTG]
    @State private var navigateToStep = false

    private var isFavorited: Bool {
        favorites.contains { $0.itemId == task.id }
    }

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Task Details", showBack: true) {
                    dismiss()
                }

                ScrollView {
                    VStack(spacing: adaptyH(20)) {
                        ZStack(alignment: .topTrailing) {
                            Image(task.imageName)
                                .resizable()
                                .frame(height: adaptyH(220))
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
                                }
                            }
                            .padding(adaptyW(14))
                        }

                        VStack(alignment: .leading, spacing: adaptyH(8)) {
                            Text(task.title)
                                .font(.system(size: adaptyW(24), weight: .bold))
                                .foregroundStyle(.white)

                            Text(task.subtitle)
                                .font(.system(size: adaptyW(15)))
                                .foregroundStyle(ColorThemeRTG.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        GlowCardRTG(glowColor: ColorThemeRTG.emeraldAccent) {
                            HStack(spacing: adaptyW(20)) {
                                statBubble(value: "\(task.steps.count)", label: "Steps")
                                statBubble(value: "~\(task.steps.count * 5)m", label: "Duration")
                                statBubble(value: "Field", label: "Type")
                            }
                            .padding(adaptyW(16))
                        }

                        VStack(alignment: .leading, spacing: adaptyH(12)) {
                            Text("Steps Overview")
                                .font(.system(size: adaptyW(18), weight: .bold))
                                .foregroundStyle(.white)

                            ForEach(task.steps) { step in
                                stepPreviewRow(step)
                            }
                        }

                        AnimatedButtonRTG(title: "Start Task") {
                            viewModel.startTask(task)
                            navigateToStep = true
                        }
                        .padding(.top, adaptyH(8))
                    }
                    .padding(.horizontal, adaptyW(16))
                    .padding(.top, adaptyH(12))
                }
                .scrollIndicators(.hidden)
                .padding(.bottom, adaptyH(120))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBackWithSwipe()
        .navigationDestination(isPresented: $navigateToStep) {
            TaskStepViewRTG(viewModel: viewModel)
        }
    }

    @ViewBuilder
    private func statBubble(value: String, label: String) -> some View {
        VStack(spacing: adaptyH(4)) {
            Text(value)
                .font(.system(size: adaptyW(18), weight: .bold))
                .foregroundStyle(ColorThemeRTG.emeraldAccent)

            Text(label)
                .font(.system(size: adaptyW(11)))
                .foregroundStyle(ColorThemeRTG.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func stepPreviewRow(_ step: TaskStepModelRTG) -> some View {
        HStack(spacing: adaptyW(12)) {
            ZStack {
                Circle()
                    .fill(ColorThemeRTG.primaryOrange.opacity(0.15))
                    .frame(width: adaptyW(36), height: adaptyW(36))

                Text("\(step.stepNumber)")
                    .font(.system(size: adaptyW(14), weight: .bold))
                    .foregroundStyle(ColorThemeRTG.primaryOrange)
            }

            VStack(alignment: .leading, spacing: adaptyH(2)) {
                Text(step.title)
                    .font(.system(size: adaptyW(14), weight: .semibold))
                    .foregroundStyle(.white)

                Text(step.description.prefix(60).appending("..."))
                    .font(.system(size: adaptyW(12)))
                    .foregroundStyle(ColorThemeRTG.textSecondary)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(adaptyW(12))
        .background(
            RoundedRectangle(cornerRadius: adaptyW(12))
                .fill(ColorThemeRTG.darkCard.opacity(0.5))
        )
    }

    private func toggleFavorite() {
        if let existing = favorites.first(where: { $0.itemId == task.id }) {
            modelContext.delete(existing)
        } else {
            let fav = FavoriteItemRTG(itemId: task.id, itemType: "task", itemTitle: task.title, itemImage: task.imageName)
            modelContext.insert(fav)
        }
    }
}
