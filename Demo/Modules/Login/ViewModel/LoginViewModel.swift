//
//  LoginViewModel.swift
//  Demo
//
//  Created by Julio Lemus on 14/02/21.
//
 
import Firebase

protocol LoginViewModelProtocol {
    func loginSucces()
    func loginFail(_ message: String)
}

class LoginViewModel {
    
    private var delegate: LoginViewModelProtocol?
    
    init(_ delegate: LoginViewModelProtocol){
        self.delegate = delegate
    }
    
    func login (user: String?, password: String?) {
        
        guard let email = user, let pass = password else {
            delegate?.loginFail(.messageErrorLogin)
            return
        }
        
        if !email.isValidEmail() {
            self.delegate?.loginFail(.invalidEmail)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
          guard let self = self else { return }
            if error != nil {
                self.delegate?.loginFail(error?.localizedDescription ?? String.messageErrorFailogin)
                return
            }
            
            if let _ = authResult {
                self.delegate?.loginSucces()
            }else {
                self.delegate?.loginFail(.messageErrorFailogin)
            }
        }
    }
}
