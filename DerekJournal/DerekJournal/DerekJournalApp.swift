
import SwiftUI

@main
struct DerekJournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            JournalsView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")

                }
        }
    }
}
