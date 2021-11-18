//
//  StringExtension.swift
//  Playlist
//
//  Created by Viktoriya on 29.10.2021.
//


import Foundation

extension String {
    
    enum ValidTypes {
        
        case name
        case email
        case password
    }
    
    enum Regex: String {
        case name = "[a-zA-Z]{2,}"
        case email = "[a-zA-Z0-9._-]{2,}+@[a-z]+\\.[a-z]{2,}"
        case password = "(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{6,}"
    }
    
    func isValid(validType: ValidTypes) -> Bool {
        
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch validType {
        case .name: regex = Regex.name.rawValue
        case .email: regex = Regex.email.rawValue
        case .password: regex = Regex.password.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}
