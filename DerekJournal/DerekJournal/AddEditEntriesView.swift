//
//  AddEditEntryView.swift
//  CoreDataJournal
//
//

import SwiftUI

struct AddEditEntryView: View {
    @Environment(\.dismiss) private var dismiss

    var journal: Journal
    var entry: Entry?

    @State private var title = ""
    @State private var bodyString = ""
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?

    private var saveIsDisabled: Bool {
        title.isEmpty || bodyString.isEmpty
    }


    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    TextField("Title", text: $title)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: .infinity, minHeight: 44)

                    imageButton()
                        .fixedSize()
                }

                TextEditor(text: $bodyString)
                    .textEditorStyle(.plain)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )

                Spacer()

                Button(action: save) {
                    Text("Save")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.blue)
                )
                .contentShape(Rectangle())
                .opacity(saveIsDisabled ? 0.5 : 1)
                .disabled(saveIsDisabled)
            }
            .padding()
            .navigationTitle(entry == nil ? "New Entry" : entry!.title)
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $selectedImage)
            }
        }
        .onAppear {
            if let entry {
                title = entry.title
                bodyString = entry.body
                if let imageData = entry.imageData {
                    selectedImage = UIImage(data: imageData)
                }
            }
        }
    }

    func imageButton() -> some View {
        Button {
            presentImagePicker()
        } label: {
            if let selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }
        }
    }

    func presentImagePicker() {
        isShowingImagePicker = true
    }

    func save() {
        if let entry {
            JournalController.shared.updateEntry(
                entry: entry,
                title: title,
                body: bodyString,
                image: selectedImage
            )
        } else {
            JournalController.shared.createNewEntry(
                in: journal,
                title: title,
                body: bodyString,
                image: selectedImage
            )
        }
        dismiss()
    }

}
