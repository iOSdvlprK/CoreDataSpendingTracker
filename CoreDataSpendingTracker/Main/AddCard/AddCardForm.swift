//
//  AddCardForm.swift
//  CoreDataSpendingTracker
//
//  Created by joe on 2023/10/13.
//

import SwiftUI

struct AddCardForm: View {
//    @Binding var shouldPresentAddCardForm: Bool
//    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Text("Add card form")
                
                TextField("Name", text: $name)
            }
            .navigationTitle("Add Credit Card")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
//                        shouldPresentAddCardForm.toggle()
//                        presentationMode.wrappedValue.dismiss()
                        dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
            }
        }
    }
}

struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
        AddCardForm()
//        MainView()
    }
}
