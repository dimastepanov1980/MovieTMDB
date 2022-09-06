//
//  SearchViewController.swift
//  MovieTMDB
//
//  Created by Dmitriy Stepanov on 26.08.2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapItems (_ viewModel: DetailPreviewViewModel)
}

class SearchResultsViewController: UIViewController {

    public var titles = [Title]()
    public weak var delegate : SearchResultsViewControllerDelegate?
    public var searchResultCollectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10 , height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifire)
        return collectionView
        
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
        
        APICaller.shared.getYoutubeMovie(with: titleName ) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    self?.delegate?.searchResultsViewControllerDidTapItems(DetailPreviewViewModel(title: titleName + "trailer", youTubeVideo: videoElement, description: title.overview ?? "" ))
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifire, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        let title = titles[indexPath.row]
        cell.configureImage(with: title.poster_path ?? "")
        return cell
    }
    
    
    
}
