
import Foundation
import RxSwift
import RxRelay

class DataRepo: HomeViewModelProtocol{
    private var disposeBag:DisposeBag
    private var networkManager: NetworkManager
    private var localPhotosDB: PhotoPersistenceManager
    
    var items: BehaviorRelay<[PhotoModel]>
    private var dataSubject = PublishSubject<[PhotoModel]>()
    var fetchMoreDatas: PublishSubject<Void>
    var refreshControlAction: PublishSubject<Void>
    var refreshControlCompelted: PublishSubject<Void>
    var isLoadingSpinnerAvaliable: PublishSubject<Bool>
    private var loadingsubject = PublishSubject<Bool>()
    private var showErrorSubject = PublishSubject<String>()
    
    var showErrorObservable: Observable<String>
    var loadingObservable: Observable<Bool>
    var dataObservable:Observable<[PhotoModel]>
    
    private var pageCounter = 1
    private let dataLimitation = 5
    private var isPaginationRequestStillResume = false
    private var isRefreshRequstStillResume = false
    
    init() {
        disposeBag = DisposeBag()
        networkManager = NetworkManager.sharedInstance
        localPhotosDB = PhotoPersistenceManager.shared
        showErrorObservable = showErrorSubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        dataObservable = dataSubject.asObservable()
        items = BehaviorRelay<[PhotoModel]>(value: [])
        
        fetchMoreDatas = PublishSubject<Void>()
        refreshControlAction = PublishSubject<Void>()
        refreshControlCompelted = PublishSubject<Void>()
        isLoadingSpinnerAvaliable = PublishSubject<Bool>()
        
        bind()
    }
    
    private func bind() {
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchData(page: self.pageCounter,isRefreshControl: false)
        }.disposed(by: disposeBag)
        
        refreshControlAction.subscribe { [weak self] _ in
            self?.refreshControlTriggered()
        }.disposed(by: disposeBag)
    }
    
    private func fetchData(page: Int, isRefreshControl: Bool) {

        self.loadingsubject.onNext(true)
        if isPaginationRequestStillResume || isRefreshRequstStillResume { return }
        self.isRefreshRequstStillResume = isRefreshControl
        
        isPaginationRequestStillResume = true
        isLoadingSpinnerAvaliable.onNext(true)
        
        if pageCounter == 1  || isRefreshControl {
            isLoadingSpinnerAvaliable.onNext(false)
        }
        networkManager.fetchData(page: pageCounter, limit: dataLimitation) { [weak self] (response) in
            guard let self = self else{return}
            switch response {
            case .success(let response):
                // fetch from remote
                self.loadingsubject.onNext(false)
                self.handleData(data: response)
                
            case .failure(let error):
                // fetch from local
                self.localPhotosDB.getPhotos { (photos) in
                    if let photos = photos {
                        self.items.accept(photos)
                        self.dataSubject.onNext(photos)
                        self.showErrorSubject.onNext(error.reason)
                        return
                    }else{
                        self.loadingsubject.onNext(false)
                        self.showErrorSubject.onNext(error.reason)
                    }
                }
            }
            self.isLoadingSpinnerAvaliable.onNext(false)
            self.isPaginationRequestStillResume = false
            self.isRefreshRequstStillResume = false
            self.refreshControlCompelted.onNext(())
        }
    }
    
    private func handleData(data: [PhotoModel]?) {
        localPhotosDB.deleteAllPhotos()
        var newDataArr = data
        newDataArr?.append(PhotoModel(id: "", author: "", width: 0, height: 0, download_url: "noImage", url: ""))
        if pageCounter != 1 {
            let oldDatas = items.value
            newDataArr = oldDatas + (newDataArr ?? [])
        }
        
        localPhotosDB.savePhotoData(photos: newDataArr ?? []) { [weak self] (res) in
            guard let self = self else{return}
            switch res{
            case .success(let status):
                if(status){
                    self.items.accept(newDataArr ?? [])
                    self.dataSubject.onNext(newDataArr ?? [])
                }
            case .failure(let error):
                print("joe , error saving DB")
                self.showErrorSubject.onNext(error.localizedDescription)
            }
        }
        pageCounter += 1
    }
    
    private func refreshControlTriggered() {
        networkManager.cancelAllRequests()
      //  isPaginationRequestStillResume = false
        pageCounter = 1
        items.accept([])
        dataSubject.onNext([])
        fetchData(page: pageCounter,isRefreshControl: true)
    }
}
