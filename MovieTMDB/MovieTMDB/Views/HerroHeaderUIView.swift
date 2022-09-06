//
//  HerroHeaderUV.swift
//  MovieTMDB
//
//  Created by Dmitriy Stepanov on 23.08.2022.
//

import UIKit
import SDWebImage

class HerroHeaderUIView: UIView, UIScrollViewDelegate {

    private let scrollView = UIScrollView()
    private var heroImage = UIImageView ()
    private let playButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImage()
        configScrollView()
        addGradient()
        configureButton(title: "Play", constant: 50)
        configureButton(title: "Download", constant: 250)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImage.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    
    
    private func configureButton(title: String, constant: CGFloat){
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            button.widthAnchor.constraint(equalToConstant: 110)

        ])
    }
    
    
    func configureImage(){
        heroImage.contentMode = .scaleAspectFill
        heroImage.clipsToBounds = true
        heroImage.image = UIImage(named:"aquaman")
    }
    
    func configure(with model:TitleViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else { return }
        heroImage.sd_setImage(with: url, completed: nil)
    }
    
    
    func configScrollView() {
        addSubview(heroImage)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
    
}
