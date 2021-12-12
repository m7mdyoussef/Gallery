import Foundation
import RxSwift
import RxRelay

final class HomeViewModel {
    
    private var disposeBag:DisposeBag
    var items: BehaviorRelay<[PhotoModel]>
    var fetchMoreDatas: PublishSubject<Void>
    var refreshControlAction: PublishSubject<Void>
    var refreshControlCompelted: PublishSubject<Void>
    var isLoadingSpinnerAvaliable: PublishSubject<Bool>
    var showErrorObservable: Observable<String>
    var loadingObservable: Observable<Bool>
    private var loadingsubject = PublishSubject<Bool>()
    private var showErrorSubject = PublishSubject<String>()
    
    private var repo: DataRepo

    init() {
        repo = DataRepo()
        showErrorObservable = showErrorSubject.asObservable()
        loadingObservable = loadingsubject.asObservable()
        items = BehaviorRelay<[PhotoModel]>(value: [])
        fetchMoreDatas = PublishSubject<Void>()
        refreshControlAction = PublishSubject<Void>()
        refreshControlCompelted = PublishSubject<Void>()
        isLoadingSpinnerAvaliable = PublishSubject<Bool>()
        disposeBag = DisposeBag()

        bind()
    }
    
    private func bind() {
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.repo.fetchMoreDatas.onNext(())
        }
        .disposed(by: disposeBag)
        
        refreshControlAction.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.repo.refreshControlAction.onNext(())
        }
        .disposed(by: disposeBag)
        
        repo.dataObservable.subscribe(onNext: {[weak self] (photoArray) in
            guard let self = self else {return}
            self.items.accept(photoArray)
        }).disposed(by: disposeBag)
        
        repo.showErrorObservable.subscribe(onNext: {[weak self] (message) in
            guard let self = self else {return}
            self.showErrorSubject.onNext(message)
        }).disposed(by: disposeBag)
        
        repo.loadingObservable.subscribe(onNext: {[weak self] (bool) in
            guard let self = self else {return}
            self.loadingsubject.onNext(bool)
        }).disposed(by: disposeBag)
        
        repo.isLoadingSpinnerAvaliable.subscribe(onNext: {[weak self] (bool) in
            guard let self = self else {return}
            self.isLoadingSpinnerAvaliable.onNext(bool)
        }).disposed(by: disposeBag)
        
        repo.refreshControlCompelted.subscribe(onNext: {[weak self] (_) in
            guard let self = self else {return}
            self.refreshControlCompelted.onNext(())
        }).disposed(by: disposeBag)
    }

}
