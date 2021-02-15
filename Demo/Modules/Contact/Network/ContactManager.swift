//
//  ContactManager.swift
//  Demo
//
//  Created by Julio Lemus on 14/02/21.
//

import Foundation
import Alamofire

protocol ContactManagerProtocol {
    func didRetriveSendeContact(_ message: String)
    func didFailRetriveSendContact(_ message: String)
}

class ContactManager {
    
    private let delegate: ContactManagerProtocol?
    init(_ view: ContactManagerProtocol) {
        self.delegate = view
    }
    
    func sendContact(name: String, date: String, email: String, subject: String ){
        
        let request = ContactBaseRequest(type: [TargetRequest(targetId: "contacto")], name: [GenericValue(value: name)], date: [GenericValue(value: date)], email: [GenericValue(value: email)], message: [GenericValue(value: subject)])
         
        let urlBase = "https://nube11.com/bamfit/node?_format=json"
        APIClient().postRequestHLJSON(parameter: request, url: urlBase, someClass: ContactResponse.self) { (response, error) in
            if error != nil {
                    self.delegate?.didFailRetriveSendContact(.errorFailSendContact)
            } else {
                if let result = response {
                    if let _  = result["field_correo_electronico"] as? [Any] {
                        self.delegate?.didRetriveSendeContact(.successRetriveContact)
                    }else{
                        self.delegate?.didFailRetriveSendContact(.errorFailSendContact)
                    }
                } else {
                    self.delegate?.didFailRetriveSendContact(.errorFailSendContact)
                }
            }
        }
    }
}
