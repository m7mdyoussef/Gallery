
import Foundation

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
    private func saveUseData(data:UserDataModel){
        loadingsubject.onNext(true)
        UserPersistenceManager.shared.saveUserData(user: data) {[weak self] saveStatus in
            if saveStatus {
                // nav to lgin by userNmae
                print("joe, saved ")
                self?.loadingsubject.onNext(false)
                self?.doneSubject.onCompleted()

            }else{
               // show error
                print("joe, Error while saving data")
                self?.loadingsubject.onNext(false)
                self?.errorSubject.onNext("Error while saving data")

            }
        }
    }

    func checkRegisterationDataValidation(userName: String, password:String , confirmPass:String){
        if(userName.isEmpty || password.isEmpty || confirmPass.isEmpty){
            return
        }
        if !GalleryValidationUtil.isValid(userName: userName) {
            errorSubject.onNext("invalid userName")
            return
        }
        if !GalleryValidationUtil.isValid(password: password) {
            errorSubject.onNext("Password should be more than 8 charcters")
            return
        }else if(password != confirmPass){
            errorSubject.onNext("Confirmed Password doesn't match the password you entered!!")
            return
        }
        saveUseData(data: UserDataModel(mobileNumber: userName, password: password))
    }
    


}
