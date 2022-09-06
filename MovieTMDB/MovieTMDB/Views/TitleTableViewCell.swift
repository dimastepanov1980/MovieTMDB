//
//  TitleTableViewCell.swift
//  MovieTMDB
//
//  Created by Dmitriy Stepanov on 25.08.2022.
//

import UIKit
import SDWebImage

class TitleTableViewCell: UITableViewCell {

    static let identifire = "TitleTableViewCell"
    
    private let titlePosterImage = UIImageView()
    private let titleLabel = UILabel()
    private let titlePlayButon = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureImage()
        configureTitle()
        configureButton()
        configereConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureImage(){
        contentView.addSubview(titlePosterImage)
        titlePosterImage.contentMode = .scaleAspectFill
        titlePosterImage.clipsToBounds = true
        titlePosterImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureTitle(){
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
    }
    
    func configureButton(){
        contentView.addSubview(titlePlayButon)
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        titlePlayButon.tintColor = .white
        titlePlayButon.setImage(image, for: .normal)
        titlePlayButon.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configereConstraints(){
        NSLayoutConstraint.activate([
            titlePosterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlePosterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlePosterImage.widthAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: titlePosterImage.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -100),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            titlePlayButon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -20),
            titlePlayButon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    public func configure(with model:TitleViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else { return }
        titlePosterImage.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
    }
    
}
