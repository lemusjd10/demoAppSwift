//
//  EndPoint.swift
//  Demo
//
//  Created by Julio Lemus on 14/02/21.
//

enum Endpoint {
    case allBreeds
    case breedsPaginate(page: String, limit: String = "4")
    case sendContact
    
    var path:String {
        switch self {
        case .allBreeds:
        return "breeds"
        case .breedsPaginate(page: let page, limit: let limit):
            return "breeds?limit=\(limit)&page=\(page)"
        case .sendContact:
            return "bamfit/node?_format=json"
        }
    }
}
