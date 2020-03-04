//
//  SignUpViewController.swift
//  Fotos13
//
//  Created by Gary on 5/18/19.
//  Copyright © 2019 Gary Hanson. All rights reserved.
//

import UIKit

final class CreateAccountViewController: UIViewController, UITextFieldDelegate, Storyboarded {
    weak var coordinator: AuthCoordinator?
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var userName = ""
    private var password = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.userNameTextField.overrideUserInterfaceStyle = .light
        self.passwordTextField.overrideUserInterfaceStyle = .light
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.subviews.forEach { $0.alpha = 0.0 }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1, animations: {
            for view in self.view.subviews {
                view.alpha = 1.0
            }
        }, completion: { _ in
            self.userNameTextField.becomeFirstResponder()
        })
    }
    
    
    @IBAction func userNameChanged(_ sender: Any) {
        if let textField = sender as? UITextField {
            self.userName = textField.text!
            self.validateEntries()
        }
    }
    
    @IBAction func passwordChanged(_ sender: Any) {
        if let textField = sender as? UITextField {
            self.password = textField.text!
            self.validateEntries()
        }
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        self.createAccountButton.isEnabled = false
        self.coordinator?.didTapCreateAccount(userName: self.userName, password: self.password, on: self)
    }
    
    private func validateEntries() {
        let validEntries = self.userNameIsValid() && self.passwordIsValid()
        self.createAccountButton.isEnabled = validEntries
    }
    
    private func userNameIsValid() -> Bool {
        return self.userName.count > 4
    }
    
    private func passwordIsValid() -> Bool {
        return self.password.count > 4
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            if self.createAccountButton.isEnabled {
                textField.resignFirstResponder()
                self.createAccountTapped(self)
            }
        }
        
        return true
    }
    
    
    func show(error: Error) {
        // if couldn't create with specified user name the coordinator would call back here to display the error
    }
}
