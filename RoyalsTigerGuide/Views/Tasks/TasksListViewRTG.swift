import SwiftUI

struct TasksListViewRTG: View {
    @Bindable var viewModel: ViewModelRTG
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Field Tasks", showBack: true) {
                    dismiss()
                }

                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: adaptyW(12)),
                        GridItem(.flexible(), spacing: adaptyW(12))
                    ], spacing: adaptyH(14)) {
                        ForEach(viewModel.tasks) { task in
                            NavigationLink(destination: TaskDetailViewRTG(task: task, viewModel: viewModel)) {
                                taskGridItem(task)
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
    private func taskGridItem(_ task: TaskModelRTG) -> some View {
        GlowCardRTG(glowColor: ColorThemeRTG.primaryOrange) {
            VStack(spacing: adaptyH(10)) {
                Image(task.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: adaptyH(100))
                    .clipShape(RoundedRectangle(cornerRadius: adaptyW(12)))

                VStack(spacing: adaptyH(4)) {
                    Text(task.title)
                        .font(.system(size: adaptyW(13), weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)

                    Text("\(task.steps.count) Steps")
                        .font(.system(size: adaptyW(11)))
                        .foregroundStyle(ColorThemeRTG.textSecondary)
                }
            }
            .padding(adaptyW(10))
        }
    }
}
