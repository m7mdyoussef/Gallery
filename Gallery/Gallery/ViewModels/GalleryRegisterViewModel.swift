
import Foundation
import RxSwift
import TKFormTextField

protocol GalleryRegisterViewModelProtocol{
    var errorObservable:Observable<(String)>{get}
    var loadingObservable: Observable<Bool> {get}
    var doneObservable: Observable<Bool>{get}
    func checkRegisterationDataValidation(userName: String, password:String , confirmPass:String)
}

class GalleryRegisterViewModel:GalleryRegisterViewModelProtocol{
    private var errorSubject = PublishSubject<(String)>()
    private var loadingsubject = PublishSubject<Bool>()
    private var doneSubject = PublishSubject<Bool>()
    private var userData:UserDataModel!
    
    var errorObservable: Observable<(String)>
    var loadingObservable: Observable<Bool>
    var doneObservable: Observable<Bool>
    
    init() {
        errorObservable = errorSubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        doneObservable = doneSubject.asObservable()
    }
    
    private func saveUserData(data:UserDataModel){
        loadingsubject.onNext(true)
        UserPersistenceManager.shared.saveUserData(user: data) {[weak self] saveStatus in
            if saveStatus {
                // nav to lgin by userNmae
                self?.loadingsubject.onNext(false)
                self?.doneSubject.onCompleted()
                
            }else{
                // show error
                self?.loadingsubject.onNext(false)
                self?.errorSubject.onNext(Constant.saveUserDataError)
            }
        }
    }
    
    func checkRegisterationDataValidation(userName: String, password:String , confirmPass:String){
        if(userName.isEmpty || password.isEmpty || confirmPass.isEmpty){
            return
        }
        if !GalleryValidationUtil.isValid(userName: userName) {
            errorSubject.onNext(Constant.invalidUserName)
            return
        }
        if !GalleryValidationUtil.isValid(password: password) {
            errorSubject.onNext(Constant.inavlidPassword)
            return
        }else if(password != confirmPass){
            errorSubject.onNext(Constant.wrongConfirmPass)
            return
        }
        checkUserExistance(userName: userName, password: password)
    }
    
    private func checkUserExistance(userName: String, password: String){
        UserPersistenceManager.shared.getUserData(userName: userName) {[weak self] usersData in
            if let usersData = usersData {
                for userData in usersData{
                    if userData.mobileNumber == userName {
                        self?.errorSubject.onNext(Constant.userExist)
                        return
                    }
                }
            }
            self?.saveUserData(data: UserDataModel(mobileNumber: userName, password: password))
        }
    }
    
}
