//
//  AddTransactionForm.swift
//  CoreDataSpendingTracker
//
//  Created by joe on 2023/10/17.
//

import SwiftUI

struct AddTransactionForm: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var amount = ""
    @State private var date = Date()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    NavigationLink(destination: {
                        Text("new category page")
                            .navigationTitle("New Title")
                    }, label: {
                        Text("Many to many")
                    })
                }, header: {
                    Text("Information")
                })
                
                Section(content: {
                    Button {
                        
                    } label: {
                        Text("Select Photo")
                    }

                }, header: {
                    Text("Photo / Receipt")
                })
            }
            .navigationTitle("Add Trasaction")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    saveButton
                }
            }
        }
    }
    
    private var saveButton: some View {
        Button {
            
        } label: {
            Text("Save")
        }

    }
    
    private var cancelButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Cancel")
        }

    }
}

struct AddTransactionForm_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionForm()
    }
}
