//
//  GalleryLoginViewModel.swift
//  Gallery
//
//  Created by TWI on 10/12/2021.
//

import Foundation
import RxSwift

protocol GalleryLoginViewModelProtocol{
    var errorObservable:Observable<(String)>{get}
    var loadingObservable: Observable<Bool> {get}
    var signedInObservable: Observable<Bool> {get}
    func checkLoginDataValidation(userName: String, password: String)
    func fetchUserData(userName: String, password: String)
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
            errorSubject.onNext("invalid userName")
            return
        }
        if !GalleryValidationUtil.isValid(password: password) {
            errorSubject.onNext("Password should be more than 8 charcters")
            return
        }
        fetchUserData(userName: userName, password: password)
    }
    
    func fetchUserData(userName: String, password: String) {
        loadingSubject.onNext(true)
        UserPersistenceManager.shared.getUserData(userName: userName) {[weak self] usersData in
            if let usersData = usersData {
                print("joe data:\(usersData)")
                for userData in usersData{
                    if userData.mobileNumber == userName && userData.password == password{
                        print("joe data true")
                        self?.loadingSubject.onNext(false)
                        self?.signedInSubject.onNext(true)
                        return
                    }
                }
            }
            print("joe data false")
            self?.loadingSubject.onNext(false)
            self?.errorSubject.onNext(("Please Register First"))
            self?.signedInSubject.onNext(false)
            
        }
    }
    
}
