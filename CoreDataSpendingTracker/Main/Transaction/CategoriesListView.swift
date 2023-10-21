//
//  CategoriesListView.swift
//  CoreDataSpendingTracker
//
//  Created by joe on 2023/10/21.
//

import SwiftUI

struct CategoriesListView: View {
    @State private var name = ""
    @State private var color = Color.red
    
    //    @State var selectedCategories = Set<TransactionCategory>()
    @Binding var selectedCategories: Set<TransactionCategory>
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCategory.timestamp, ascending: false)],
        animation: .default)
    private var categories: FetchedResults<TransactionCategory>
    
    var body: some View {
        Form {
            Section(content: {
                ForEach(categories) { category in
                    Button(action: {
                        if selectedCategories.contains(category) {
                            selectedCategories.remove(category)
                        } else {
                            selectedCategories.insert(category)
                        }
                    }, label: {
                        HStack(spacing: 12) {
                            if let data = category.colorData, let uiColor = UIColor.color(data: data) {
                                let color = Color(uiColor)
                                Spacer()
                                    .frame(width: 30, height: 10)
                                    .background(color)
                            }
                            Text(category.name ?? "")
                                .foregroundColor(Color(.label))
                            Spacer()
                            
                            if selectedCategories.contains(category) {
                                Image(systemName: "checkmark")
                            }
                        }
                    })
                }
                .onDelete { indexSet in
                    indexSet.forEach { i in
                        viewContext.delete(categories[i])
                    }
                    try? viewContext.save()
                }
            }, header: {
                Text("Select a category")
            })
            
            Section(content: {
                TextField("Name", text: $name)
                ColorPicker("Color", selection: $color)
                
                Button(action: { handleCreate() }) {
                    HStack {
                        Spacer()
                        Text("Create")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(5)
                }
                .buttonStyle(PlainButtonStyle())
            }, header: {
                Text("Create a category")
            })
        }
    }
    
    private func handleCreate() {
        let context = PersistenceController.shared.container.viewContext
        
        let category = TransactionCategory(context: context)
        category.name = self.name
        category.colorData = UIColor(color).encode()
        category.timestamp = Date()
        
        // this will hide your error
        try? context.save()
        self.name = ""  // clear the textfield
    }
}

struct CategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesListView(selectedCategories: .constant(Set<TransactionCategory>()))
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
