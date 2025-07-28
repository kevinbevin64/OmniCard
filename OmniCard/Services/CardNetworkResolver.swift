//
//  CardNetworkResolver.swift
//  OmniCard
//
//  Created by Kevin Chen on 7/28/25.
//

struct CardNetworkResolver {
    /// Determines the payment network of a given card number.
    ///
    /// - Parameters:
    ///   - cardNumber: The card number as a `String`. This value must not contain any whitespace
    ///                 or non-numeric characters.
    /// - Returns: A `PaymentNetwork` value if the card number matches a known network;
    ///            otherwise, `nil`.
    static func paymentNetwork(from cardNumber: String) -> PaymentNetwork {
        // Check for American Express
        if cardNumber.hasPrefix("34") || cardNumber.hasPrefix("37") && cardNumber.count == 15 {
            return .amex
        }
        
        // Check for Visa
        if cardNumber.hasPrefix("4") && [13, 16, 19].contains(cardNumber.count) {
            return .visa
        }
        
        // Check for Mastercard
        if cardNumber.count == 16 {
            if let prefix2 = Int(cardNumber.prefix(2)), (51...55).contains(prefix2) {
                return .mastercard
            }
            
            if let prefix4 = Int(cardNumber.prefix(4)), (2221...2720).contains(prefix4) {
                return .mastercard
            }
        }
        
        // Check for Discover
        if (16...19).contains(cardNumber.count) {
            if cardNumber.hasPrefix("6011") || cardNumber.hasPrefix("65") {
                return .discover
            }
            
            if let prefix3 = Int(cardNumber.prefix(3)), (644...649).contains(prefix3) {
                return .discover
            }
            
            if let prefix6 = Int(cardNumber.prefix(6)), (622126...622925).contains(prefix6) {
                return .discover
            }
        }
        
        return .unknown
    }
}

enum PaymentNetwork: String {
    case visa
    case mastercard
    case amex
    case discover
    
    case unknown
}
