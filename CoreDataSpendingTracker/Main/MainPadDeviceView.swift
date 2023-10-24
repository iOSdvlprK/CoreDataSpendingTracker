//
//  MainPadDeviceView.swift
//  CoreDataSpendingTracker
//
//  Created by joe on 2023/10/23.
//

import SwiftUI

struct MainPadDeviceView: View {
    @State private var shouldShowAddCardForm = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .frame(width: 370)
                        }
                    }
                }
                
                TransactionGrid()
            }
            .navigationTitle("Money Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addCardButton
                }
            }
            .sheet(isPresented: $shouldShowAddCardForm) {
                AddCardForm()
            }
        }
    }
    
    private var addCardButton: some View {
        Button {
            shouldShowAddCardForm.toggle()
        } label: {
            Text("+ Card")
        }
    }
}

struct TransactionGrid: View {
    var body: some View {
        VStack {
            HStack {
                Text("Transactions")
                Spacer()
                Button {
                    
                } label: {
                    Text("+ Transaction")
                }
            }
            
            let columns = [
                GridItem(.fixed(100), spacing: 16, alignment: .leading),
                GridItem(.fixed(200), spacing: 16, alignment: .leading),
                GridItem(.adaptive(minimum: 300, maximum: 800), spacing: 16),
                GridItem(.flexible(minimum:100, maximum: 450), spacing: 16, alignment: .trailing)
            ]
            
            LazyVGrid(columns: columns) {
                HStack {
                    Text("date")
                    Image(systemName: "arrow.up.arrow.down")
                }
                Text("Photo / Receipt")
                HStack {
                    Text("Name")
                    Image(systemName: "arrow.up.arrow.down")
                    Spacer()
                }
//                .background(Color.red)
                HStack {
                    Text("Amount")
                    Image(systemName: "arrow.up.arrow.down")
//                    Spacer()
                }
//                .background(Color.blue)
            }
            .foregroundColor(Color(.darkGray))
        }
        .font(.system(size: 24, weight: .semibold))
        .padding()
    }
}

struct MainPadDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        MainPadDeviceView()
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation)"))
            .environment(\.horizontalSizeClass, .regular)
            .previewInterfaceOrientation(.portrait)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
