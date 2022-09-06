//
//  TitleCollectionViewCell.swift
//  MovieTMDB
//
//  Created by Dmitriy Stepanov on 24.08.2022.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "TitleCollectionViewCell"
    
    private let posterImageView : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = bounds
    }
    
    public func configureImage(with model: String){
        
//        print(model)
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
}
