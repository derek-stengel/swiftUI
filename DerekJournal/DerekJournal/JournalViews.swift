

import SwiftUI

struct JournalsView: View {

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Entry.createdAt, ascending: false)],
        animation: .default)
    private var journals: FetchedResults<Journal>

    @State private var isShowingNewJournal = false

    var body: some View {
        NavigationStack {
            VStack {
                List(journals) { journal in
                    NavigationLink(destination: EntriesView(journal: journal)) {
                        journalView(journal)
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Journals")
            .toolbar {
                ToolbarItem {
                    Button(action: showNewJournalView) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingNewJournal) {
            AddEditJournalView()
        }
    }

    func journalView(_ journal: Journal) -> some View {
        HStack {
            if let hex = journal.colorHex, let color = Color(hex: hex) {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(color)
                    .frame(width: 40, height: 40)
            }
            VStack(alignment: .leading) {
                Text(journal.title)
                    .bold()

                Text("Entries: \(journal.entriesArray.count)")
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
    }

    func showNewJournalView() {
        isShowingNewJournal = true
    }

}

//#Preview {
//    JournalsView()
//}
