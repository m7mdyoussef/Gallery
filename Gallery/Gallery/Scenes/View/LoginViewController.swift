//
//  LoginViewController.swift
//  Gallery
//
//  Created by TWI on 10/12/2021.
//

import UIKit
import TKFormTextField
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet private weak var userNameTxtField: TKFormTextField!
    @IBOutlet private weak var passwordTxtField: TKFormTextField!
    
    private var activityInd:UIActivityIndicatorView!
    private var disposeBag:DisposeBag!
    private var loginViewModel:GalleryLoginViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserNameChanged), name: NSNotification.Name(rawValue: GalleryCachingConstants.userNameChanged), object: nil)
    }
    
    @objc func handleUserNameChanged() {
        print("joe useDef: \(GalleryUser.sharedUser.userName)")
        userNameTxtField.text = GalleryUser.sharedUser.userName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        hideKeyboardWhenTappedAround()
        self.title = "Login"
        initializeUI()
        loginViewModel = GalleryLoginViewModel()
        disposeBag = DisposeBag()
        activityInd = UIActivityIndicatorView(style: .large)
        
        loginViewModel.errorObservable.subscribe(onNext: { msg in
            self.showAlert(message: msg)
        }).disposed(by: disposeBag)
        
        loginViewModel.loadingObservable.subscribe(onNext: {[weak self] (state) in
            switch state{
            case true:
                self?.showLoading()
            case false:
                self?.hideLoading()
            }
        }).disposed(by: disposeBag)
        
        loginViewModel.signedInObservable.subscribe(onNext: {[weak self] (state) in
            switch state{
            case true:
                self?.showHome()
            case false:
                return
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func initializeUI() {
        // userNameTxtField.text = GalleryUser.sharedUser.userName
       // if GalleryUser.sharedUser.isLoggedIn == false{
            userNameTxtField.text = ""
            passwordTxtField.text = ""
       // }
    }
    
    func showHome() {
        GalleryUser.sharedUser.isLoggedIn = true
        initializeUI()
        let VC = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func showLoading() {
        activityInd!.center = self.view.center
        self.view.addSubview(activityInd!)
        activityInd!.startAnimating()
    }
    
    func hideLoading() {
        activityInd!.stopAnimating()
    }
    
    @IBAction func loginTap(_ sender: UIButton) {
        if userNameTxtField.text == ""{
            userNameTxtField.error = "Required input"
        }
        if passwordTxtField.text == ""{
            passwordTxtField.error = "Required input"
        }
        loginViewModel.checkLoginDataValidation(userName: userNameTxtField.text!, password: passwordTxtField.text!)
    }
    
    @IBAction func register(_ sender: Any) {
        initializeUI()
        let VC = self.storyboard?.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }

    @IBAction func userNameEndEditing(_ sender: Any) {
        
        if(userNameTxtField.text == ""){
            userNameTxtField.error = "Required input"
        }else if(!GalleryValidationUtil.isValid(userName: userNameTxtField.text!)){
            userNameTxtField.error = "inavlid user name"
        }else{
            userNameTxtField.error = nil
        }
    }
    
    @IBAction func passwordEndEditing(_ sender: Any) {
        if(passwordTxtField.text == ""){
            passwordTxtField.error = "Required input"
        }else if(!GalleryValidationUtil.isValid(password: passwordTxtField.text!)){
            passwordTxtField.error = "password must be more than 8 characters"
        }else{
            passwordTxtField.error = nil
        }
    }
}
