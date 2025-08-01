//
//  Extensions.swift
//  OmniCard
//
//  Created by Kevin Chen on 7/28/25.
//

enum StringError: Error {
    case nonNumericCharacterFound(Character)
}

extension String {
    /// Removes all whitespace from this `String` and throws if the string contains non-numeric
    /// characters. 
    func compactNumeric() throws -> String {
        // Remove all whitespace
        let cleaned: String = self.filter { !$0.isWhitespace }
        
        // Validate that all characters are digits
        for char in cleaned {
            guard char.isNumber else {
                throw StringError.nonNumericCharacterFound(char)
            }
        }
        
        return cleaned
    }
}
