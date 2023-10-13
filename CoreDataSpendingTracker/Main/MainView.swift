//
//  MainView.swift
//  CoreDataSpendingTracker
//
//  Created by joe on 2023/10/12.
//

import SwiftUI

struct MainView: View {
    @State private var shouldPresentAddCardForm = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                TabView {
                    ForEach(0..<5) { num in
                        CreditCardView()
                            .padding(.bottom, 50)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 300)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                // hack
//                .onAppear {
//                    shouldPresentAddCardForm.toggle()
//                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil) {
//                        AddCardForm(shouldPresentAddCardForm: $shouldPresentAddCardForm)
                        AddCardForm()
                    }
            }
            .navigationTitle("Credit Cards")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addCardButton
                }
            }
        }
    }
    
    struct CreditCardView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 22) {
                Text("Apple Blue Visa Card")
                    .font(.system(size: 25, weight: .semibold))
                
                HStack {
                    Image("visa")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 44)
                        .clipped()
                    Spacer()
                    Text("Balance: $5,000")
                        .font(.system(size: 19, weight: .semibold))
                }
                
                Text("1234 1234 1234 1234")
                Text("Credit Limit: $50,000")
                HStack { Spacer() }
            }
            .foregroundColor(.white)
            .padding()
            .background(
                LinearGradient(colors: [
                    Color.blue.opacity(0.6),
                    Color.blue
                ], startPoint: .center, endPoint: .bottom)
            )
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
            .cornerRadius(8)
            .shadow(radius: 5)
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }
    
    var addCardButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("+ Card")
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(5)
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
