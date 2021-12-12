
import RxCocoa
import RxSwift
import UIKit

final class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel!
    private var disposeBag: DisposeBag!
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var activityInd:UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height: 100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rgisterCell()
        viewModel = HomeViewModel()
        disposeBag = DisposeBag()
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        bind()
        layout()
    }
    
    private func rgisterCell(){
        let photoNibCell = UINib(nibName: String(describing: HomeCollectionViewCell.self), bundle: nil)
        collectionView.register(photoNibCell, forCellWithReuseIdentifier: Constant.HomeCollectionViewCell)
    }
    
    private func layout() {
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constant.Logout , style:.plain, target: self, action: #selector(handleLogOut))
    }
    @objc private func refreshControlTriggered() {
        viewModel.refreshControlAction.onNext(())
    }
    
    private func bind() {
        viewModel.loadingObservable.subscribe(onNext: {[weak self] (status) in
            guard let self = self else{return}
            switch status{
            case true:
                self.showLoading()
            case false:
                self.hideLoading()
            }
        }).disposed(by: disposeBag)
        
        viewModel.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else { return }
            if(isAvaliable){
                self.showLoading()
            }else{
                self.hideLoading()
            }
        }
        .disposed(by: disposeBag)
        
        viewModel.refreshControlCompelted.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }
        .disposed(by: disposeBag)
        
        viewModel.showErrorObservable.subscribe(onNext: { [weak self] (msg) in
            guard let self = self else{return}
            self.showAlert(message: msg)
        }).disposed(by: disposeBag)
        
        viewModel.items.bind(to: collectionView.rx.items) { collectionView, row, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.HomeCollectionViewCell, for: IndexPath(index: row)) as! HomeCollectionViewCell
            cell.photoItem = item
            return cell
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(PhotoModel.self).subscribe{(value) in
            if value.element?.url == "" {
                return
            }else{
                let PhotoDetailsViewController = self.storyboard?.instantiateViewController(identifier: Constant.PhotoDetailsViewController) as! PhotoDetailsViewController
                PhotoDetailsViewController.modalPresentationStyle = .fullScreen
                PhotoDetailsViewController.photoModel = value.element
                self.present(PhotoDetailsViewController, animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
        
        collectionView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.collectionView.contentOffset.y
            let contentHeight = self.collectionView.contentSize.height
            
            if offSetY > (contentHeight - self.collectionView.frame.size.height - 20) {
                self.viewModel.fetchMoreDatas.onNext(())
            }
        }.disposed(by: disposeBag)
        
    }
    
    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: Constant.logOutMsg, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: Constant.Logout, style: .destructive, handler: { (_) in
            
            let vc = self.storyboard?.instantiateViewController(identifier: Constant.LoginViewController) as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alertController.addAction(UIAlertAction(title: Constant.cancel, style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showLoading() {
        activityInd.center = self.view.center
        self.view.addSubview(activityInd)
        activityInd.startAnimating()
    }
    
    func hideLoading() {
        activityInd.stopAnimating()
    }
    
}

//MARK: - collectionViewDelegate

extension HomeViewController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.width - 10) / 2)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


