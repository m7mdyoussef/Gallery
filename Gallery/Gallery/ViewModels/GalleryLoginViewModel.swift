
import Foundation
import RxSwift

protocol GalleryLoginViewModelProtocol{
    var errorObservable:Observable<(String)>{get}
    var loadingObservable: Observable<Bool> {get}
    var signedInObservable: Observable<Bool> {get}
    func checkLoginDataValidation(userName: String, password: String)
}

class GalleryLoginViewModel: GalleryLoginViewModelProtocol{
    private var errorSubject = PublishSubject<(String)>()
    private var loadingSubject = PublishSubject<Bool>()
    private var signedInSubject = PublishSubject<Bool>()
    
    var errorObservable: Observable<(String)>
    var loadingObservable: Observable<Bool>
    var signedInObservable: Observable<Bool>
    
    init() {
        errorObservable = errorSubject.asObservable()
        loadingObservable = loadingSubject.asObservable()
        signedInObservable = signedInSubject.asObservable()
    }
    
    func checkLoginDataValidation(userName: String, password: String) {
        if(userName.isEmpty || password.isEmpty){
            return
        }
        if !GalleryValidationUtil.isValid(userName: userName) {
            errorSubject.onNext(Constant.invalidUserName)
            return
        }
        if !GalleryValidationUtil.isValid(password: password) {
            errorSubject.onNext(Constant.inavlidPassword)
            return
        }
        fetchUserData(userName: userName, password: password)
    }
    
    private func fetchUserData(userName: String, password: String) {
        loadingSubject.onNext(true)
        UserPersistenceManager.shared.getUserData(userName: userName) {[weak self] usersData in
            if let usersData = usersData {
                for userData in usersData{
                    if userData.mobileNumber == userName {
                        if userData.password == password {
                            self?.loadingSubject.onNext(false)
                            self?.signedInSubject.onNext(true)
                        }else {
                            self?.loadingSubject.onNext(false)
                            self?.errorSubject.onNext((Constant.worngPassword))
                            self?.signedInSubject.onNext(false)
                        }
                        return
                    }
                }
            }
            self?.loadingSubject.onNext(false)
            self?.errorSubject.onNext((Constant.registerFirst))
            self?.signedInSubject.onNext(false)
            
        }
    }
    
}
