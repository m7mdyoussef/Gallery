

import RxCocoa
import RxSwift
import UIKit

final class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
        layout()
        bind()
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.viewModel.fetchMoreDatas.onNext(())
        }
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
    }
    
    private func layout() {
        self.navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style:.plain, target: self, action: #selector(handleLogOut))
        collectionView.backgroundColor = .clear
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        let photoNibCell = UINib(nibName: String(describing: HomeCollectionViewCell.self), bundle: nil)
        collectionView.register(photoNibCell, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        collectionView.refreshControl = refreshControl
        
        
        // collectionView.tableFooterView = UIView(frame: .zero)
    }
    
    private func bind() {
        
        collectionViewBind()
        
        viewModel.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            //   guard let isAvaliable = isAvaliable.element,
            //   let self = self else { return }
            // self.collectionView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
        }
        .disposed(by: disposeBag)
        
        viewModel.refreshControlCompelted.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
        }
        .disposed(by: disposeBag)
        
        viewModel.showErrorObservable.subscribe(onNext: { msg in
            self.showAlert(message: msg)
            }).disposed(by: disposeBag)
    }
    
    private func collectionViewBind() {
        
        viewModel.items.bind(to: collectionView.rx.items(cellIdentifier: "HomeCollectionViewCell")){ row, item, cell in
            let cell = cell as! HomeCollectionViewCell
            cell.cellConfig(photo: item)
            
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(PhotoModel.self).subscribe{(value) in
            if value.element?.url == "" {
                return
            }else{
                let PhotoDetailsViewController = self.storyboard?.instantiateViewController(identifier: "PhotoDetailsViewController") as! PhotoDetailsViewController
                PhotoDetailsViewController.modalPresentationStyle = .fullScreen
                PhotoDetailsViewController.photoModel = value.element
                self.present(PhotoDetailsViewController, animated: true, completion: nil)
            }
//            if AppCommon.shared.checkConnectivity() == true{
//                // self.controlViews(flag: true)
//                self.collectionViewModel.getProductElement(idProduct: String(value.element?.id ?? 0))
//                let detailsViewController = self.storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
//                detailsViewController.modalPresentationStyle = .fullScreen
//                detailsViewController.idProduct = String(value.element?.id ?? 0)
//                self.present(detailsViewController, animated: true, completion: nil)
//            }
            
        }.disposed(by: disposeBag)
        
        collectionView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.collectionView.contentOffset.y
            let contentHeight = self.collectionView.contentSize.height
            
            if offSetY > (contentHeight - self.collectionView.frame.size.height - 100) {
                self.viewModel.fetchMoreDatas.onNext(())
            }
        }.disposed(by: disposeBag)
    }
    
    @objc private func refreshControlTriggered() {
        print("spin")
        viewModel.refreshControlAction.onNext(())
    }

    @objc func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: "Are you sure that you want to logout?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            let vc = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - collectionViewDelegate

extension HomeViewController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.frame.width - 2) / 2)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}


