//
//  UIViewController+Extension.swift
//  Demo
//
//  Created by Julio Lemus on 14/02/21.
//
import UIKit

extension UIViewController { 
    func showAlert(alertText : String = "CATS PET", alertMessage : String ) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
