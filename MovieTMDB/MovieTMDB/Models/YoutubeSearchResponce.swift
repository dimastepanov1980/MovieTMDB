//
//  YotubeSearchResponce.swift
//  MovieTMDB
//
//  Created by Dmitriy Stepanov on 27.08.2022.
//

import Foundation

struct YoutubeSearchResponce: Codable {
    let items: [VideoElemet]
}


struct VideoElemet: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
