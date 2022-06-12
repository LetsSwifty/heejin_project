//
//  ViewController.swift
//  InfiniteGalleryView
//
//  Created by 김희진 on 2022/06/05.
//

//UICollectionView, AF, infinite scroll + paging, GCD, pull to refresh, keychain

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {

    private var imageURLArr: [String] = []
    let refresher = UIRefreshControl()
    var currentPage: Int = 1
    
    var isLoading: Bool = false
     

    var galleryCollectionViewCell: UICollectionViewCell = GalleryCollectionViewCell()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var uiview: UIView =  {
        let view = UIView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavigation()
        addUI()
        fetch()
        
        refresher.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refresher
        
    }
    
    func addNavigation(){
        navigationItem.title = "MyGallery"
    }

    @objc func refreshData() {

        
        collectionView.refreshControl?.beginRefreshing()

        imageURLArr = []
        currentPage = Int.random(in: 2...30)

        fetch()
        collectionView.refreshControl?.endRefreshing()
    }
    
    func addUI(){
        view.backgroundColor = .white
        [collectionView].forEach{ view.addSubview($0) }
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func fetch() {
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept": "application/json"
        ]
        
        self.currentPage = self.currentPage + 1
        
        let url = "https://api.unsplash.com/photos?page=\(self.currentPage)&per_page=30&client_id="
        

        AF.request(url,
                   method: .get,
                   parameters: nil,
                   headers: headers)
        .validate(statusCode: 200..<300)
        .responseDecodable(of: [ImageModel].self) { response in
            
            switch response.result {
            case .success(let value):
                    
                for i in value {
                    self.imageURLArr.append(i.urls.thumb)
                }

                self.collectionView.reloadData()
                
                self.isLoading = false

            case .failure(let error):
                print("네트워크 에러: ", error.localizedDescription)
            }
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLArr.count + 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as? GalleryCollectionViewCell else { return UICollectionViewCell() }

        if indexPath.row == imageURLArr.count && imageURLArr.count > 0 {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.backgroundColor = .white
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: cell.bounds.width, height: cell.bounds.height)
            cell.addSubview(spinner)
        }else {
            if !imageURLArr.isEmpty {
                cell.reloadImage(url: imageURLArr[indexPath.row])
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("SDf")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath){
        print("SDDD")
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize.height > scrollView.bounds.height else { return }
        
        if scrollView.contentSize.height - scrollView.bounds.height <= scrollView.contentOffset.y + 30 {
            if isLoading {
                return
            }
            isLoading = true
            fetch()
        }
    }
    
}

extension ViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        if indexPath.row == imageURLArr.count {
            return CGSize(width: collectionViewWidth, height: 50)
        }else {
            return CGSize(width: collectionViewWidth/3, height: collectionViewWidth/3)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
