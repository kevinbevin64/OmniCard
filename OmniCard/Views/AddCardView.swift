//
//  AddCardView.swift
//  OmniCard
//
//  Created by Kevin Chen on 7/27/25.
//

import Foundation
import SwiftUI

struct AddCardView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @State var showingInvalidInputAlert: Bool = false
    
    @State var name: String = ""
    @State var number: String = ""
    @State var expirationMonth: String = ""
    @State var expirationYear: String = ""
    @State var securityCode: String = ""
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
            TextField("Card Number", text: $number)
            
            HStack {
                TextField("Month", text: $expirationMonth)
                Text("/")
                TextField("Year", text: $expirationYear)
            }
            
            TextField("Security Code", text: $securityCode)
            
            Divider()
            
            Button("Done", systemImage: "checkmark") {
                if let newCard = Card(
                    name: name,
                    number: number,
                    expirationMonth: expirationMonth,
                    expirationYear: expirationYear,
                    securityCode: securityCode
                ) {
                    context.insert(newCard)
                    dismiss()
                } else {
                    showingInvalidInputAlert = true
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .alert("Invalid input", isPresented: $showingInvalidInputAlert) {
            Button("Ok", role: .cancel) {
                showingInvalidInputAlert = false
            }
        }
    }
}
