//
//  StatusCodeResponse.swift
//  Demo
//
//  Created by Julio Lemus on 12/02/21.
//

import Foundation

enum ErrorHandler: Error {
    case requestFailed
    case jsonConversionFail
    case invalidData
    case responseUnsuccessfull
    case jsonParsinFail
    
    var localizedDescription: String {
        switch self {
        case .requestFailed:
            return "Request Fail"
        case .jsonConversionFail:
            return "Json Conversion Fail"
        case .invalidData:
            return "Invalid Data"
        case .responseUnsuccessfull:
            return "Response Unsuccessfull"
        case .jsonParsinFail:
            return "Json Parsin Failed"
        }
    }
}
