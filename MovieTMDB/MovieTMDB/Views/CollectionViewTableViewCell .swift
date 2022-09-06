//
//  CollectionViewTVC.swift
//  MovieTMDB
//
//  Created by Dmitriy Stepanov on 23.08.2022.
//

import UIKit
import CoreData

protocol CollectionViewTableViewCellDelegate : AnyObject {
    func CollectionViewTableViewCellDidTapCell(withCell: CollectionViewTableViewCell, viewModel: DetailPreviewViewModel)
}

class CollectionViewTableViewCell : UITableViewCell {

    weak var delegate: CollectionViewTableViewCellDelegate?
    static let identifire = "CollectionViewTVC"
    private var titles = [Title]()
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemPink
        configureCollectionView()
        setTableDelegate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifire)
    }
    
    func setTableDelegate(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    public func configureTitle(with: [Title]) {
        self.titles = with
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func downloadTitleAt(indexPath: IndexPath) {

        DataPersistenceManager.shared.downloadRirleWith(model: titles[indexPath.row]) { result in
            switch result {
            case .success():
                print("download seccess")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifire, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        guard let model = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configureImage(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_title else { return }
        
        APICaller.shared.getYoutubeMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElemet):
                
                let viewModel = DetailPreviewViewModel(title: titleName, youTubeVideo: videoElemet, description: title.overview ?? "No description")
                guard let strongSelf = self else {return}
                self?.delegate?.CollectionViewTableViewCellDidTapCell(withCell: strongSelf, viewModel: viewModel)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let configure = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
        }
        return configure
    }
    
}
