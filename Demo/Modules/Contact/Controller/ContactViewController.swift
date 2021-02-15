//
//  ContactViewController.swift
//  Demo
//
//  Created by Julio Lemus on 14/02/21.
//

import UIKit

class ContactViewController: UIViewController, LoadingViewPresentable {

    lazy var viewModel = ContactViewModel(view: self)
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapOnSubmit(_ sender: UIButton) {
        showLoading()
        viewModel.sendContact(name: self.nameTextField.text, date: dateTextField.text, email: emailTextField.text, subject: subjectTextField.text)
    }
}

extension ContactViewController: ContactViewModelProtocol {
    func didRetriveSendeContact(_ message: String) {
        nameTextField.text = nil
        dateTextField.text = nil
        emailTextField.text = nil
        subjectTextField.text = nil
        
        showAlert(alertMessage: message)
        hideLoading()
    }
    
    func didFailRetriveSendContact(_ message: String) {
        showAlert(alertMessage: message)
        hideLoading()
    }
}
