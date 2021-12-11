

import Foundation
import RxCocoa
import RxSwift
import Alamofire

final class HomeViewModel {
    
    private let disposeBag = DisposeBag()
    private let networkManager = NetworkManager()
    
    let items = BehaviorRelay<[PhotoModel]>(value: [])
    
    let fetchMoreDatas = PublishSubject<Void>()
    let refreshControlAction = PublishSubject<Void>()
    let refreshControlCompelted = PublishSubject<Void>()
    let isLoadingSpinnerAvaliable = PublishSubject<Bool>()
    
    var showErrorObservable: Observable<String>
    private var showErrorSubject = PublishSubject<String>()
    
    private var pageCounter = 1
    private var maxValue = 100
    private var isPaginationRequestStillResume = false
    private var isRefreshRequstStillResume = false
    
    init() {
        showErrorObservable = showErrorSubject.asObservable()
       if Connectivity.isConnectedToInternet{
            bind()
       }else{
           fetchLocalPhotos()
       }
    }
    
    private func bind() {
        
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData(page: self.pageCounter,
                           isRefreshControl: false)
        }
        .disposed(by: disposeBag)
        
        refreshControlAction.subscribe { [weak self] _ in
            self?.refreshControlTriggered()
        }
        .disposed(by: disposeBag)
    }
    
    private func fetchData(page: Int, isRefreshControl: Bool) {
        if isPaginationRequestStillResume || isRefreshRequstStillResume { return }
        self.isRefreshRequstStillResume = isRefreshControl
        
        if pageCounter > maxValue  {
            isPaginationRequestStillResume = false
            return
        }
        
        isPaginationRequestStillResume = true
        isLoadingSpinnerAvaliable.onNext(true)
        
        if pageCounter == 1  || isRefreshControl {
            isLoadingSpinnerAvaliable.onNext(false)
        }
        //https://picsum.photos/v2/list
        networkManager.fetchData(url: "https://picsum.photos/v2/list", page: page) { [weak self] response in
            switch response {
            case .failure(let error):
                self?.showErrorSubject.onNext(error.reason)
            case .success(let response):
                self?.handleData(data: response)
               // self?.refreshControlCompelted.onNext(())
            }
            self?.isLoadingSpinnerAvaliable.onNext(false)
            self?.isPaginationRequestStillResume = false
            self?.isRefreshRequstStillResume = false
            self?.refreshControlCompelted.onNext(())
        }
    }
    
    private func handleData(data: [PhotoModel]) {
       
        var arr = data
        if data.count > 4{
            arr.insert(PhotoModel(id: "", author: "", width: 0, height: 0, download_url: "", url: ""), at: 5)
        }
        if data.count > 9{
            arr.insert(PhotoModel(id: "", author: "", width: 0, height: 0, download_url: "", url: ""), at: 11)
        }
       
        if pageCounter == 1 {
        
            items.accept(arr)
        } else {
            let oldDatas = items.value
            items.accept(oldDatas + arr)
        }
        items.value.forEach { photoModel in
            PhotoPersistenceManager.shared.savePhotoData(photo: photoModel) { _ in
            }
        }
        
        pageCounter += 1
        
    }
    
    private func refreshControlTriggered() {

        networkManager.cancelAllRequests()
        isPaginationRequestStillResume = false
        pageCounter = 1
        items.accept([])
        fetchData(page: pageCounter,
                  isRefreshControl: true)
    }
    
    private func fetchLocalPhotos(){
        items.accept(PhotoPersistenceManager.shared.getPhotos() ?? [])
        print("joe\(items.value.count)")
        showErrorSubject.onNext("Please connect to internet to load new items")
        

    }
    
}

struct Connectivity {
    private init() {}
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}
