//
//  ContentView.swift
//  OmniCard
//
//  Created by Kevin Chen on 7/27/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Card.dateAdded, order: .forward) var cards: [Card]
    
    @State private var showingAddCardSheet: Bool = false
    @State var selectedCard: Card?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(cards) { card in
                    cardListItem(card)
                        .animation(.easeInOut(duration: 0.15), value: selectedCard)
                        .contentShape(Rectangle()) // Expands clickable area
                        .onTapGesture { onTap(of: card) }
                }
                .onDelete(perform: deleteCards)
            }
            .navigationTitle("Cards")
            .toolbar {
                newCardButton
            }
            .sheet(isPresented: $showingAddCardSheet) {
                AddCardView()
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
    func cardListItem(_ card: Card) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Card name
            Text(card.name)
                .font(.title3)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
            
            HStack(alignment: .bottom, spacing: 12) {
                // Card number
                Text(cardNumberFor(card))
                    .font(.callout)
                    .fontWeight(.regular)
                    .fontDesign(.monospaced)
                
                Spacer()
                
                // Expiration date
                Text(expirationDateFor(card))
                    .font(.caption)
                    .fontWeight(.thin)
                    .fontDesign(.monospaced)
                
                // Security code
                Text(securityCodeFor(card))
                    .font(.caption)
                    .fontWeight(.thin)
                    .fontDesign(.monospaced)
            }
        }
        .listRowInsets(
            EdgeInsets(
                top: 10,
                leading: 16,
                bottom: 10,
                trailing: 16
            )
        )
    }
    
    // Show all the card's numbers if it is selected; otherwise, show the last 4.
    func cardNumberFor(_ card: Card) -> String {
        if let selectedCard, card == selectedCard {
            var _number: String = ""
            for i in 0..<card.number.count {
                let index = card.number.index(card.number.startIndex, offsetBy: i)
                _number.append(card.number[index])
                if i != 0 && i % 4 == 3 {
                    _number.append(" ")
                }
            }
            return _number
        } else {
            return String(repeating: "**** ", count: 3) + "\(card.number.suffix(4))"
        }
    }
    
    func expirationDateFor(_ card: Card) -> String {
        if let selectedCard, card == selectedCard {
            return card.expirationMonth + "/" + card.expirationYear
        } else {
            return "MM/YY"
        }
    }
    
    func securityCodeFor(_ card: Card) -> String {
        if let selectedCard, card == selectedCard {
            return card.securityCode
        } else {
            return "CVV"
        }
    }
    
    func onTap(of card: Card) {
        if let selectedCard {
            if card == selectedCard {
                self.selectedCard = nil
            } else {
                self.selectedCard = card
            }
        } else {
            self.selectedCard = card
        }
    }
    
    var newCardButton: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button("Add card", systemImage: "plus") {
                showingAddCardSheet = true
            }
        }
    }
    
    func deleteCards(at offsets: IndexSet) {
        selectedCard = nil
        let cardsToDelete = offsets.map { cards[$0] }
        for card in cardsToDelete {
            context.delete(card)
        }
    }
}

#Preview {
    ContentView()
}
