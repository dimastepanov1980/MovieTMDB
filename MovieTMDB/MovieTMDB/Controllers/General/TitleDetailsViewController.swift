//
//  TitleDetailsViewController.swift
//  MovieTMDB
//
//  Created by Dmitriy Stepanov on 27.08.2022.
//

import UIKit
import WebKit

class TitleDetailsViewController: UIViewController {
    private let titleLeble = UILabel()
    private let descriptionLable = UILabel()
    private let downloadButton = UIButton()
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        configButton()
        configWebView()
        configTitleLable()
        configDescriptionLable()
        configConstrains()
    }
    
    func configWebView(){
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func configButton(){
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.setTitleColor(.white, for: .normal)
        downloadButton.backgroundColor = .red
        downloadButton.layer.cornerRadius = 15
        view.addSubview(downloadButton)
    }

    func configTitleLable(){
        titleLeble.translatesAutoresizingMaskIntoConstraints = false
        titleLeble.font = .systemFont(ofSize: 22, weight: .semibold)
        titleLeble.numberOfLines = 0
        view.addSubview(titleLeble)
    }
    
    func configDescriptionLable(){
        descriptionLable.translatesAutoresizingMaskIntoConstraints = false
        descriptionLable.font = .systemFont(ofSize: 18, weight: .regular)
        descriptionLable.numberOfLines = 0
        view.addSubview(descriptionLable)
    }
    
    func configConstrains(){
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),

            titleLeble.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLeble.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            
            descriptionLable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionLable.topAnchor.constraint(equalTo: titleLeble.bottomAnchor, constant: 5),
            
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: descriptionLable.bottomAnchor, constant: 50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    func configure(with model: DetailPreviewViewModel){
        titleLeble.text = model.title
        descriptionLable.text = model.description
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youTubeVideo.id.videoId)") else { return }
        webView.load(URLRequest(url: url))
    }
}
