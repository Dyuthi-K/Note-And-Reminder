//
//  ContentView
//
//  Created by dyuthi ajit kuchu on 16/11/25.
//


import SwiftUI
import SwiftData

@Model
class TodoItem {
    var title: String
    var body: String
    var dueDate: Date?
    var isFlagged: Bool
    var isCompleted: Bool
    var createdAt: Date
    
    init(title: String = "", body: String = "", dueDate: Date? = nil, isFlagged: Bool = false, isCompleted: Bool = false, createdAt: Date = Date()) {
        self.title = title
        self.body = body
        self.dueDate = dueDate
        self.isFlagged = isFlagged
        self.isCompleted = isCompleted
        self.createdAt = createdAt
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            TodoListView()
                .tabItem {
                    Label("All Items", systemImage: "list.bullet")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

struct TodoListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TodoItem.createdAt, order: .reverse) private var allItems: [TodoItem]

    private var calendar: Calendar { Calendar.current }

    private var openItems: [TodoItem] {
        allItems.filter { !$0.isCompleted }
    }

    private var dueToday: [TodoItem] {
        openItems.filter {
            $0.dueDate != nil && calendar.isDateInToday($0.dueDate!)
        }
    }
    
    private var dueTomorrow: [TodoItem] {
        openItems.filter {
            $0.dueDate != nil && calendar.isDateInTomorrow($0.dueDate!)
        }
    }
    
    private var upcoming: [TodoItem] {
        openItems.filter {
            guard let dueDate = $0.dueDate else { return false }
            let isToday = calendar.isDateInToday(dueDate)
            let isTomorrow = calendar.isDateInTomorrow(dueDate)
            let isFuture = dueDate > Date()
            return isFuture && !isToday && !isTomorrow
        }
    }
    
    private var noDate: [TodoItem] {
        openItems.filter { $0.dueDate == nil }
    }
    
    private var completedItems: [TodoItem] {
        allItems.filter { $0.isCompleted }
    }

    var body: some View {
        NavigationStack {
            List {
                if !dueToday.isEmpty {
                    Section(header: Text("Due Today")) {
                        ForEach(dueToday) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemRowView(item: item)
                            }
                        }
                    }
                }
                
                if !dueTomorrow.isEmpty {
                    Section(header: Text("Due Tomorrow")) {
                        ForEach(dueTomorrow) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemRowView(item: item)
                            }
                        }
                    }
                }
                
                if !upcoming.isEmpty {
                    Section(header: Text("Upcoming")) {
                        ForEach(upcoming) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemRowView(item: item)
                            }
                        }
                    }
                }
                
                if !noDate.isEmpty {
                    Section(header: Text("No Date")) {
                        ForEach(noDate) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemRowView(item: item)
                            }
                        }
                    }
                }
                
                if !completedItems.isEmpty {
                    Section(header: Text("Completed")) {
                        ForEach(completedItems) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemRowView(item: item)
                            }
                        }
                    }
                }
            }
            .navigationTitle("All Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addItem) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
    
    func addItem() {
        let newItem = TodoItem(title: "New Item")
        modelContext.insert(newItem)
    }
}

struct SearchView: View {
    @State private var searchText = ""
    @Query var searchResults: [TodoItem]
    
    init() {
        _searchResults = Query(filter: #Predicate<TodoItem> { item in
            if searchText.isEmpty {
                return false
            } else {
                return item.title.localizedStandardContains(searchText)
            }
        }, sort: \TodoItem.title)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) { item in
                    NavigationLink(destination: ItemDetailView(item: item)) {
                        ItemRowView(item: item)
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search for a title...")
        }
    }
}

struct ItemRowView: View {
    @Bindable var item: TodoItem
    
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title3)
                .foregroundStyle(item.isCompleted ? .green : .gray)
                .onTapGesture {
                    item.isCompleted.toggle()
                }

            VStack(alignment: .leading) {
                Text(item.title.isEmpty ? "New Item" : item.title)
                    .font(.headline)
                
                if !item.body.isEmpty {
                    Text(item.body)
                        .font(.subheadline)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            if item.isFlagged {
                Image(systemName: "flag.fill")
                    .foregroundStyle(.orange)
            }
        }
    }
}

struct ItemDetailView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let item: TodoItem
    
    @State private var tempTitle: String
    @State private var tempBody: String
    @State private var tempDueDate: Date?
    @State private var tempIsFlagged: Bool
    @State private var tempIsCompleted: Bool
    
    init(item: TodoItem) {
        self.item = item
        
        _tempTitle = State(initialValue: item.title)
        _tempBody = State(initialValue: item.body)
        _tempDueDate = State(initialValue: item.dueDate)
        _tempIsFlagged = State(initialValue: item.isFlagged)
        _tempIsCompleted = State(initialValue: item.isCompleted)
    }
    
    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Title", text: $tempTitle)
                
                TextEditor(text: $tempBody)
                    .frame(height: 200)
            }
            
            Section(header: Text("Scheduling")) {
                Toggle(isOn: Binding(
                    get: { tempDueDate != nil },
                    set: {
                        if $0 { tempDueDate = Date() }
                        else { tempDueDate = nil }
                    }
                ).animation()) {
                    Text("Add Due Date")
                }
                
                if tempDueDate != nil {
                    DatePicker(
                        "Date",
                        selection: Binding(
                            get: { tempDueDate ?? Date() },
                            set: { tempDueDate = $0 }
                        ),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            }
            
            Section(header: Text("Properties")) {
                Toggle(isOn: $tempIsFlagged) {
                    Label("Flagged", systemImage: "flag.fill")
                }
                .tint(.orange)
                
                Toggle(isOn: $tempIsCompleted) {
                    Label("Completed", systemImage: "checkmark.circle.fill")
                }
                .tint(.green)
            }
            Section {
                Button("Delete Item", role: .destructive) {
                    deleteItem()
                }
                
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
        }
        .navigationTitle(tempTitle.isEmpty ? "New Item" : tempTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    saveChanges()
                }
            }
        }
    }
    
    func saveChanges() {
        item.title = tempTitle
        item.body = tempBody
        item.dueDate = tempDueDate
        item.isFlagged = tempIsFlagged
        item.isCompleted = tempIsCompleted
        
        dismiss()
    }
    
    func deleteItem() {
        modelContext.delete(item)
        dismiss()
    }

    #Preview {
        ContentView()
            .modelContainer(for: TodoItem.self, inMemory: true)
    }
}
