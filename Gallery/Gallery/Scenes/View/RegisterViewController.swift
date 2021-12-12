
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.Regestration
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
            phoneNumberTxtField.error = Constant.RequiredInput
        }
        if(passwordTxtField.text == ""){
            passwordTxtField.error = Constant.RequiredInput
        }
        if(confirmPassTxtField.text == ""){
            confirmPassTxtField.error = Constant.RequiredInput
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
            phoneNumberTxtField.error = Constant.RequiredInput
        }
        else if(!GalleryValidationUtil.isValid(userName: phoneNumberTxtField.text!)){
            phoneNumberTxtField.error = Constant.invalidUserName
        }
        else{
            phoneNumberTxtField.error = nil
        }
    }
    
    @IBAction func passwordEndEditing(_ sender: Any) {
        if(passwordTxtField.text == ""){
            passwordTxtField.error = Constant.RequiredInput
        }else if(!GalleryValidationUtil.isValid(password: passwordTxtField.text!)){
            passwordTxtField.error = Constant.inavlidPassword
        }else{
            passwordTxtField.error = nil
        }
    }
    @IBAction func confirmPassEndEditing(_ sender: Any) {
        if(confirmPassTxtField.text == ""){
            confirmPassTxtField.error = Constant.RequiredInput
        }else if(passwordTxtField.text! != confirmPassTxtField.text!){
            confirmPassTxtField.error = Constant.wrongConfirmPass
        }else{
            confirmPassTxtField.error = nil
        }
    }
    
}
