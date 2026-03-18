import SwiftUI
import SwiftData

struct JournalViewRTG: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntryRTG.dateCreated, order: .reverse) private var entries: [JournalEntryRTG]
    @State private var showAddSheet = false
    @State private var newTitle = ""
    @State private var newContent = ""
    @State private var newMood = "Excited"
    @State private var newSpecies = "Bengal Tiger"

    private let moods = ["Excited", "Curious", "Amazed", "Thoughtful", "Inspired"]
    private let species = ["Bengal Tiger", "Siberian Tiger", "Sumatran Tiger", "Indochinese Tiger", "Malayan Tiger", "South China Tiger"]

    var body: some View {
        ZStack {
            GradientBackgroundRTG()

            VStack(spacing: 0) {
                HeaderViewRTG(title: "Journal")

                ScrollView {
                    VStack(spacing: adaptyH(14)) {
                        Button(action: { showAddSheet = true }) {
                            GlowCardRTG(glowColor: ColorThemeRTG.emeraldAccent) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: adaptyW(24)))
                                        .foregroundStyle(ColorThemeRTG.emeraldAccent)

                                    Text("New Entry")
                                        .font(.system(size: adaptyW(16), weight: .bold))
                                        .foregroundStyle(.white)

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .font(.system(size: adaptyW(14)))
                                        .foregroundStyle(ColorThemeRTG.textSecondary)
                                }
                                .padding(adaptyW(16))
                            }
                        }

                        if entries.isEmpty {
                            VStack(spacing: adaptyH(12)) {
                                Image(systemName: "book.closed.fill")
                                    .font(.system(size: adaptyW(48)))
                                    .foregroundStyle(ColorThemeRTG.textSecondary.opacity(0.5))

                                Text("No journal entries yet")
                                    .font(.system(size: adaptyW(16), weight: .medium))
                                    .foregroundStyle(ColorThemeRTG.textSecondary)

                                Text("Start documenting your tiger exploration journey")
                                    .font(.system(size: adaptyW(13)))
                                    .foregroundStyle(ColorThemeRTG.textSecondary.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, adaptyH(60))
                        }

                        ForEach(entries) { entry in
                            journalCard(entry)
                        }
                    }
                    .padding(.horizontal, adaptyW(16))
                    .padding(.top, adaptyH(16))
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(120))
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showAddSheet) {
            addEntrySheet
        }
    }

    @ViewBuilder
    private func journalCard(_ entry: JournalEntryRTG) -> some View {
        GlowCardRTG(glowColor: ColorThemeRTG.primaryOrange) {
            VStack(alignment: .leading, spacing: adaptyH(10)) {
                HStack {
                    VStack(alignment: .leading, spacing: adaptyH(4)) {
                        Text(entry.title)
                            .font(.system(size: adaptyW(16), weight: .bold))
                            .foregroundStyle(.white)

                        Text(entry.dateCreated, format: .dateTime.month().day().year())
                            .font(.system(size: adaptyW(12)))
                            .foregroundStyle(ColorThemeRTG.textSecondary)
                    }

                    Spacer()

                    Button(action: { modelContext.delete(entry) }) {
                        Image(systemName: "trash")
                            .font(.system(size: adaptyW(14)))
                            .foregroundStyle(ColorThemeRTG.dangerRed.opacity(0.7))
                    }
                }

                HStack(spacing: adaptyW(8)) {
                    Label(entry.mood, systemImage: "face.smiling")
                        .font(.system(size: adaptyW(11)))
                        .foregroundStyle(ColorThemeRTG.secondaryGold)
                        .padding(.horizontal, adaptyW(8))
                        .padding(.vertical, adaptyH(4))
                        .background(
                            Capsule().fill(ColorThemeRTG.secondaryGold.opacity(0.15))
                        )

                    Label(entry.tigerSpecies, systemImage: "pawprint.fill")
                        .font(.system(size: adaptyW(11)))
                        .foregroundStyle(ColorThemeRTG.emeraldAccent)
                        .padding(.horizontal, adaptyW(8))
                        .padding(.vertical, adaptyH(4))
                        .background(
                            Capsule().fill(ColorThemeRTG.emeraldAccent.opacity(0.15))
                        )
                }

                Text(entry.content)
                    .font(.system(size: adaptyW(14)))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .lineSpacing(adaptyH(4))
                    .lineLimit(4)
            }
            .padding(adaptyW(16))
        }
    }

    @ViewBuilder
    private var addEntrySheet: some View {
        ZStack {
            ColorThemeRTG.deepBackground.ignoresSafeArea()

            VStack(spacing: adaptyH(20)) {
                HStack {
                    Button(action: { showAddSheet = false }) {
                        Text("Cancel")
                            .font(.system(size: adaptyW(16)))
                            .foregroundStyle(ColorThemeRTG.textSecondary)
                    }

                    Spacer()

                    Text("New Entry")
                        .font(.system(size: adaptyW(18), weight: .bold))
                        .foregroundStyle(.white)

                    Spacer()

                    Button(action: saveEntry) {
                        Text("Save")
                            .font(.system(size: adaptyW(16), weight: .bold))
                            .foregroundStyle(ColorThemeRTG.primaryOrange)
                    }
                }
                .padding(.horizontal, adaptyW(16))
                .padding(.top, adaptyH(20))

                ScrollView {
                    VStack(spacing: adaptyH(16)) {
                        VStack(alignment: .leading, spacing: adaptyH(6)) {
                            Text("Title")
                                .font(.system(size: adaptyW(13), weight: .semibold))
                                .foregroundStyle(ColorThemeRTG.textSecondary)

                            TextField("", text: $newTitle, prompt: Text("Entry title").foregroundStyle(ColorThemeRTG.textSecondary.opacity(0.5)))
                                .font(.system(size: adaptyW(16)))
                                .foregroundStyle(.white)
                                .padding(adaptyW(14))
                                .background(
                                    RoundedRectangle(cornerRadius: adaptyW(12))
                                        .fill(ColorThemeRTG.darkCard)
                                )
                        }

                        VStack(alignment: .leading, spacing: adaptyH(6)) {
                            Text("Content")
                                .font(.system(size: adaptyW(13), weight: .semibold))
                                .foregroundStyle(ColorThemeRTG.textSecondary)

                            TextField("", text: $newContent, prompt: Text("Write your observations...").foregroundStyle(ColorThemeRTG.textSecondary.opacity(0.5)), axis: .vertical)
                                .font(.system(size: adaptyW(15)))
                                .foregroundStyle(.white)
                                .lineLimit(5...10)
                                .padding(adaptyW(14))
                                .background(
                                    RoundedRectangle(cornerRadius: adaptyW(12))
                                        .fill(ColorThemeRTG.darkCard)
                                )
                        }

                        VStack(alignment: .leading, spacing: adaptyH(6)) {
                            Text("Mood")
                                .font(.system(size: adaptyW(13), weight: .semibold))
                                .foregroundStyle(ColorThemeRTG.textSecondary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: adaptyW(8)) {
                                    ForEach(moods, id: \.self) { mood in
                                        Button(action: { newMood = mood }) {
                                            Text(mood)
                                                .font(.system(size: adaptyW(13), weight: newMood == mood ? .bold : .regular))
                                                .foregroundStyle(newMood == mood ? .white : ColorThemeRTG.textSecondary)
                                                .padding(.horizontal, adaptyW(14))
                                                .padding(.vertical, adaptyH(8))
                                                .background(
                                                    Capsule()
                                                        .fill(newMood == mood ? ColorThemeRTG.primaryOrange : ColorThemeRTG.darkCard)
                                                )
                                        }
                                    }
                                }
                            }
                        }

                        VStack(alignment: .leading, spacing: adaptyH(6)) {
                            Text("Related Species")
                                .font(.system(size: adaptyW(13), weight: .semibold))
                                .foregroundStyle(ColorThemeRTG.textSecondary)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: adaptyW(8)) {
                                    ForEach(species, id: \.self) { sp in
                                        Button(action: { newSpecies = sp }) {
                                            Text(sp)
                                                .font(.system(size: adaptyW(12), weight: newSpecies == sp ? .bold : .regular))
                                                .foregroundStyle(newSpecies == sp ? .white : ColorThemeRTG.textSecondary)
                                                .padding(.horizontal, adaptyW(12))
                                                .padding(.vertical, adaptyH(8))
                                                .background(
                                                    Capsule()
                                                        .fill(newSpecies == sp ? ColorThemeRTG.emeraldAccent : ColorThemeRTG.darkCard)
                                                )
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, adaptyW(16))
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, adaptyH(40))
            }
        }
    }

    private func saveEntry() {
        guard !newTitle.isEmpty, !newContent.isEmpty else { return }
        let entry = JournalEntryRTG(
            title: newTitle,
            content: newContent,
            mood: newMood,
            tigerSpecies: newSpecies
        )
        modelContext.insert(entry)
        newTitle = ""
        newContent = ""
        newMood = "Excited"
        newSpecies = "Bengal Tiger"
        showAddSheet = false
    }
}
