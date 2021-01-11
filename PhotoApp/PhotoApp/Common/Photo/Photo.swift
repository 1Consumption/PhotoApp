//
//  Photo.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/08.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let width: Double
    let height: Double
    let urls: URLs
    let user: User
}

struct URLs: Decodable {
    let full: String
    let regular: String
}

struct User: Decodable {
    let name: String
}
