//
//  String+Extension.swift
//  Demo
//
//  Created by Julio Lemus on 13/02/21.
//

import Foundation

extension String {
    func stringJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return NSString(data: data, encoding: String.Encoding.utf8.rawValue)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
