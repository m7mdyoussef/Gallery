//
//  RegisterViewController.swift
//  Gallery
//
//  Created by TWI on 10/12/2021.
//

import UIKit
import TKFormTextField
import RxCocoa
import RxSwift

class RegisterViewController: UIViewController {

    @IBOutlet private weak var phoneNumberTxtField: TKFormTextField!
    @IBOutlet private weak var passwordTxtField: TKFormTextField!
    @IBOutlet private weak var confirmPassTxtField: TKFormTextField!
    
    private var registerationViewModel:GalleryRegisterViewModel!
    private var disposeBag:DisposeBag!
    private var activityInd:UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Regestration"
        hideKeyboardWhenTappedAround()

        disposeBag = DisposeBag()
        activityInd = UIActivityIndicatorView(style: .large)
        
        registerationViewModel = GalleryRegisterViewModel()
        
        registerationViewModel.errorObservable.subscribe(onNext: { msg in
            self.showAlert(message: msg)
            }).disposed(by: disposeBag)
        
        registerationViewModel.loadingObservable.subscribe(onNext: {[weak self] (state) in
            switch state{
            case true:
                self?.showLoading()
            case false:
                self?.hideLoading()
            }
            }).disposed(by: disposeBag)
        
        registerationViewModel.doneObservable.subscribe(onCompleted: {
            GalleryUser.sharedUser.userName = self.phoneNumberTxtField.text!
            self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)

    }
    

    @IBAction func saveRegisterationInfo(_ sender: Any) {
        if(phoneNumberTxtField.text == ""){
            phoneNumberTxtField.error = "Required input"
        }
       if(passwordTxtField.text == ""){
           passwordTxtField.error = "Required input"
        }
        if(confirmPassTxtField.text == ""){
            confirmPassTxtField.error = "Required input"
        }
        registerationViewModel.checkRegisterationDataValidation(userName: phoneNumberTxtField.text!, password: passwordTxtField.text!, confirmPass: confirmPassTxtField.text!)
    }
    
    
    func showLoading() {
        activityInd!.center = self.view.center
        self.view.addSubview(activityInd!)
        activityInd!.startAnimating()
    }
    
    func hideLoading() {
        activityInd!.stopAnimating()
    }
    
    
    @IBAction func userNameEndEditing(_ sender: Any) {
        if(phoneNumberTxtField.text == ""){
            phoneNumberTxtField.error = "Required input"
        }
        else if(!GalleryValidationUtil.isValid(userName: phoneNumberTxtField.text!)){
            phoneNumberTxtField.error = "inavlid user name"
        }
        else{
            phoneNumberTxtField.error = nil
        }
    }
    
    @IBAction func passwordEndEditing(_ sender: Any) {
        if(passwordTxtField.text == ""){
            passwordTxtField.error = "Required input"
        }
        else if(!GalleryValidationUtil.isValid(password: passwordTxtField.text!)){
            passwordTxtField.error = "inavlid user name"
        }
        else{
            passwordTxtField.error = nil
        }
    }
    @IBAction func confirmPassEndEditing(_ sender: Any) {
        if(confirmPassTxtField.text == ""){
            confirmPassTxtField.error = "Required input"
        }
        else if(passwordTxtField.text! != confirmPassTxtField.text!){
            confirmPassTxtField.error = "Confirm Password doesn't match the password."
        }
        else{
            confirmPassTxtField.error = nil
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
