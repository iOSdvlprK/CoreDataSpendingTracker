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
    
    @State private var selectedCard: Card?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .frame(width: 370)
                                .onTapGesture {
                                    withAnimation {
                                        self.selectedCard = card
                                    }
                                }
                                .scaleEffect(self.selectedCard == card ? 1.1 : 1)
                        }
                    }
                    .frame(height: 270)
                    .onAppear {
                        self.selectedCard = cards.first
                    }
                    .padding(.leading)
                }
                
                if let card = self.selectedCard {
                    TransactionsGrid(card: card)
                }
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
                .padding(.vertical, 6).padding(.horizontal, 10)
                .foregroundColor(Color(.systemBackground))
                .font(.system(size: 20, weight: .semibold))
                .background(Color(.label))
                .cornerRadius(5)
        }
    }
}

struct TransactionsGrid: View {
    let card: Card
    
    init(card: Card) {
        self.card = card
        
        fetchRequest = FetchRequest<CardTransaction>(entity: CardTransaction.entity(), sortDescriptors: [
            NSSortDescriptor(key: "timestamp", ascending: false)
        ], predicate: NSPredicate(format: "card == %@", self.card))
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var fetchRequest: FetchRequest<CardTransaction>
    
    @State private var shouldShowAddTransactionForm = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Transactions")
                Spacer()
                Button {
                    shouldShowAddTransactionForm.toggle()
                } label: {
                    Text("+ Transaction")
                        .padding(.vertical, 6).padding(.horizontal, 10)
                        .foregroundColor(Color(.systemBackground))
                        .font(.system(size: 20, weight: .semibold))
                        .background(Color(.label))
                        .cornerRadius(5)
                }
            }
            .sheet(isPresented: $shouldShowAddTransactionForm) {
                AddTransactionForm(card: card)
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
            
            LazyVStack(spacing: 0) {
                ForEach(fetchRequest.wrappedValue) { transaction in
                    VStack(spacing: 0) {
                        Divider()
                        if let index = fetchRequest.wrappedValue.firstIndex(of: transaction) {
                            LazyVGrid(columns: columns) {
                                Group {
                                    if let date = transaction.timestamp {
                                        Text(dateFormatter.string(from: date))
                                    }
                                    if let data = transaction.photoData, let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                            .cornerRadius(8)
                                    } else {
                                        Text("No photo available")
                                    }
                                    HStack {
                                        Text(transaction.name ?? "")
                                        Spacer()
                                    }
                                    Text(String(format: "%.2f", transaction.amount))
                                }
                                .multilineTextAlignment(.leading)
                            }
                            .padding(.vertical)
                            .background(index % 2 == 0 ? Color(.systemBackground) : Color(.init(white: 0, alpha: 0.03)))
                        }
                    }
                }
            }
        }
        .font(.system(size: 22, weight: .semibold))
        .padding()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
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
