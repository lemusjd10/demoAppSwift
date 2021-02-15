//
//  LoginViewController.swift
//  Demo
//
//  Created by Julio Lemus on 14/02/21.
//

import UIKit

class LoginViewController: UIViewController, LoadingViewPresentable {
    
    static let identifier = "LoginViewCOntroller"
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    var viewModel: LoginViewModel!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel(self)
    }
     
    @IBAction func didTapOnLogin(_ sender: Any) {
        showLoading()
        viewModel.login(user: userTextField.text, password: passwordTextfield.text)
    }
}

extension LoginViewController: LoginViewModelProtocol {
    func loginSucces() {
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "MaintabBar") as! UITabBarController
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        hideLoading()
    }
    
    func loginFail(_ message: String) {
        showAlert(alertMessage: message)
        hideLoading()
    }
}
