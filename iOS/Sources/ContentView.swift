import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAddSheet = false
    @State private var showSettings = false
    @State private var showPaywall = false
    @State private var editingEntry: LogEntry?

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                if store.entries.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "leaf")
                            .font(.system(size: 40))
                            .foregroundStyle(Theme.accent)
                        Text("No entries yet")
                            .font(Theme.headlineFont)
                            .foregroundStyle(Theme.textPrimary)
                    }
                } else {
                    List {
                        ForEach(store.entries) { entry in
                            Button(action: { editingEntry = entry }) {
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(entry.location)
                                            .font(Theme.headlineFont)
                                            .foregroundStyle(Theme.textPrimary)
                                        Spacer()
                                        Text(entry.date, style: .date)
                                            .font(Theme.captionFont)
                                            .foregroundStyle(Theme.textSecondary)
                                    }
                                    Text(entry.intensity)
                                        .font(Theme.bodyFont)
                                        .foregroundStyle(Theme.accent)
                                    if !entry.notes.isEmpty {
                                        Text(entry.notes)
                                            .font(Theme.captionFont)
                                            .foregroundStyle(Theme.textSecondary)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .accessibilityIdentifier("entryRow_\(entry.id.uuidString)")
                        }
                        .onDelete { offsets in
                            store.delete(at: offsets)
                        }
                        .listRowBackground(Theme.cardBackground)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Firefly Season")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if store.canAddMore {
                            showAddSheet = true
                        } else {
                            showPaywall = true
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showAddSheet) {
                EntryEditorView(entry: nil)
                    .environmentObject(store)
            }
            .sheet(item: $editingEntry) { entry in
                EntryEditorView(entry: entry)
                    .environmentObject(store)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(store)
                    .environmentObject(purchases)
            }
            .sheet(isPresented: $showPaywall) {
                PaywallView().environmentObject(purchases)
            }
        }
    }
}

struct EntryEditorView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?

    let entry: LogEntry?
    @State private var location: String
    @State private var intensity: String
    @State private var notes: String

    enum Field { case f0, f1, f2 }

    init(entry: LogEntry?) {
        self.entry = entry
        _location = State(initialValue: entry?.location ?? "")
        _intensity = State(initialValue: entry?.intensity ?? "")
        _notes = State(initialValue: entry?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Location") {
                    TextField("Location", text: $location)
                        .focused($focusedField, equals: .f0)
                        .accessibilityIdentifier("fieldLocation")
                }
                Section("Intensity") {
                    TextField("Intensity", text: $intensity)
                        .focused($focusedField, equals: .f1)
                        .accessibilityIdentifier("fieldIntensity")
                }
                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .focused($focusedField, equals: .f2)
                        .accessibilityIdentifier("fieldNotes")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                focusedField = nil
            }
            .navigationTitle(entry == nil ? "New Entry" : "Edit Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("editorCancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var updated = entry ?? LogEntry(location: "", intensity: "", notes: "")
                        updated.location = location
                        updated.intensity = intensity
                        updated.notes = notes
                        if entry == nil {
                            store.add(updated)
                        } else {
                            store.update(updated)
                        }
                        dismiss()
                    }
                    .accessibilityIdentifier("editorSaveButton")
                    .disabled(location.isEmpty)
                }
            }
        }
    }
}
