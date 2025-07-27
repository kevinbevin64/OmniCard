//
//  Card.swift
//  OmniCard
//
//  Created by Kevin Chen on 7/27/25.
//

import Foundation
import SwiftData

@Model
class Card: Identifiable, Equatable {
    // The card number of the bank card (e.g. 1111 2222 3333 4444)
    var name: String
    var number: String
    var expirationMonth: String
    var expirationYear: String
    var securityCode: String
    var dateAdded: Date // Used for sorting SwiftData objects 
    
    init?(
        name: String,
        number: String,
        expirationMonth: String,
        expirationYear: String,
        securityCode: String,
        dateAdded: Date = Date()
    ) {
        do {
            self.name = name
            self.number = try Card.validatedCardNumber(number)
            self.expirationMonth = try Card.validatedExpirationMonth(expirationMonth)
            self.expirationYear = try Card.validatedExpirationYear(expirationYear)
            self.securityCode = try Card.validatedSecurityCode(securityCode)
            self.dateAdded = dateAdded
        } catch {
            return nil
        }
    }
    
    // Removes any whitespace from the string and verifies that the number contains exactly 16 digits
    static func validatedCardNumber(_ number: String) throws -> String {
        // Remove whitespaces
        let filteredNumber = number.filter { !$0.isWhitespace }
        
        // Check that all characters are digits
        try enforceAllAreDigits(in: filteredNumber)
        
        // Verify that there are 16 digits
        try enforceLength(of: filteredNumber, equals: 16)
        
        return filteredNumber
    }
    
    static func validatedExpirationMonth(_ expirationMonth: String) throws -> String {
        // Check that all are digits
        try enforceAllAreDigits(in: expirationMonth)
        
        // Check the length
        try enforceLength(of: expirationMonth, isAtMost: 2)
        
        return expirationMonth
    }
    
    static func validatedExpirationYear(_ expirationYear: String) throws -> String {
        // Check that all are digits
        try enforceAllAreDigits(in: expirationYear)
        
        // Check the length
        try enforceLength(of: expirationYear, isAtMost: 4)
        
        return expirationYear
    }
    
    // Verifies that the length is 3 and that all characters are digits
    static func validatedSecurityCode(_ code: String) throws -> String {
        try enforceAllAreDigits(in: code) // Check that all are digits
        try enforceLength(of: code, equals: 3)
        return code
    }
    
    // Throws invalidCharacterError
    static func enforceAllAreDigits(in str: String) throws {
        for char in str {
            if !char.isNumber {
                throw CardError.invalidCharacterError
            }
        }
    }
    
    // Throws invalidLengthError
    static func enforceLength(of str: String, equals length: Int) throws {
        if str.count != length {
            throw CardError.invalidLengthError
        }
    }
    
    // Throws invalidLengthError
    static func enforceLength(of str: String, isAtMost length: Int) throws {
        if str.count > length {
            throw CardError.invalidLengthError
        }
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
}

enum CardError: Error {
    case invalidCharacterError
    case invalidLengthError
}
