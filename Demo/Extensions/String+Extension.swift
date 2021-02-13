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
}
