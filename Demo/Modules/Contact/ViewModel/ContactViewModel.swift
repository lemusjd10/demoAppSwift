//
//  ContactViewModel.swift
//  Demo
//
//  Created by Julio Lemus on 14/02/21.
//

import Foundation

protocol  ContactViewModelProtocol {
    func didRetriveSendeContact(_ message: String)
    func didFailRetriveSendContact(_ message: String)
}

class ContactViewModel {
    
    private lazy var apiManager: ContactManager = {
        let api = ContactManager(self)
        return api
    }()
    
    private let delegate: ContactViewModelProtocol?
    init(view: ContactViewModelProtocol? = nil) {
        self.delegate = view
    }
    
    func sendContact(name: String?, date: String?, email: String?, subject: String? ){
        guard let names = date, !names.isEmpty, let dates = date, !dates.isEmpty,
              let emails = email, !emails.isEmpty, let message = subject, !message.isEmpty else {
            delegate?.didFailRetriveSendContact(.errorFieldsContact)
            return
        }
        
        apiManager.sendContact(name: names, date: dates, email: emails, subject: message)
    }
}

extension ContactViewModel: ContactManagerProtocol {
    func didRetriveSendeContact(_ message: String) {
        DispatchQueue.main.async {
            self.delegate?.didRetriveSendeContact(message)
        }
    }
    
    func didFailRetriveSendContact(_ message: String) {
        DispatchQueue.main.async {
            self.delegate?.didFailRetriveSendContact(message)            
        }
    }
}
