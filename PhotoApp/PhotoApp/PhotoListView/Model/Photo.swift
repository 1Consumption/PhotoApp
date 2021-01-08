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

let dummyPhotos: [Photo] = [
    Photo(id: "1",
          width: 3456,
          height: 5184,
          urls: URLs(
            full: "https://images.unsplash.com/photo-1610024647197-92edef8b9cb2?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwxfHx8fHx8Mnw&ixlib=rb-1.2.1&q=85",
            regular: "https://images.unsplash.com/photo-1610024647197-92edef8b9cb2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwxfHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"
          ),
          user: User(name: "Björn Grochla")),
    Photo(id: "2",
          width: 5100,
          height: 3300,
          urls: URLs(
            full:             "https://images.unsplash.com/photo-1610014205112-051396496937?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwzfHx8fHx8Mnw&ixlib=rb-1.2.1&q=85",
            regular: "https://images.unsplash.com/photo-1610014205112-051396496937?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwzfHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"
          ),
          user: User(name: "aevus")),
    Photo(id: "3",
          width: 5897,
          height: 3937,
          urls: URLs(
            full: "https://images.unsplash.com/photo-1571915096107-c6606c216058?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHw0fHx8fHx8Mnw&ixlib=rb-1.2.1&q=85",
            regular: "https://images.unsplash.com/photo-1571915096107-c6606c216058?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHw0fHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"
          ),
          user: User(name: "Lore Schodts")),
    Photo(id: "4",
          width: 3456,
          height: 5184,
          urls: URLs(
            full: "https://images.unsplash.com/photo-1610046170493-30d9aeb40367?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHw1fHx8fHx8Mnw&ixlib=rb-1.2.1&q=85",
            regular: "https://images.unsplash.com/photo-1610046170493-30d9aeb40367?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHw1fHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"
          ),
          user: User(name: "Diogo Fagundes")),
    Photo(id: "5",
          width: 3840,
          height: 5760,
          urls: URLs(
            full: "https://images.unsplash.com/photo-1610049435527-f35df6297359?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHw2fHx8fHx8Mnw&ixlib=rb-1.2.1&q=85",
            regular: "https://images.unsplash.com/photo-1610049435527-f35df6297359?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHw2fHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"
          ),
          user: User(name: "Kristina Delp")),
    Photo(id: "1",
          width: 3456,
          height: 5184,
          urls: URLs(
            full: "https://images.unsplash.com/photo-1610024647197-92edef8b9cb2?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwxfHx8fHx8Mnw&ixlib=rb-1.2.1&q=85",
            regular: "https://images.unsplash.com/photo-1610024647197-92edef8b9cb2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwxfHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"
          ),
          user: User(name: "Björn Grochla")),
    Photo(id: "2",
          width: 5100,
          height: 3300,
          urls: URLs(
            full:             "https://images.unsplash.com/photo-1610014205112-051396496937?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwzfHx8fHx8Mnw&ixlib=rb-1.2.1&q=85",
            regular: "https://images.unsplash.com/photo-1610014205112-051396496937?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHwzfHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"
          ),
          user: User(name: "aevus")),
    Photo(id: "3",
          width: 5897,
          height: 3937,
          urls: URLs(
            full: "https://images.unsplash.com/photo-1571915096107-c6606c216058?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHw0fHx8fHx8Mnw&ixlib=rb-1.2.1&q=85",
            regular: "https://images.unsplash.com/photo-1571915096107-c6606c216058?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHw0fHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"
          ),
          user: User(name: "Lore Schodts")),
    Photo(id: "4",
          width: 3456,
          height: 5184,
          urls: URLs(
            full: "https://images.unsplash.com/photo-1610046170493-30d9aeb40367?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHw1fHx8fHx8Mnw&ixlib=rb-1.2.1&q=85",
            regular: "https://images.unsplash.com/photo-1610046170493-30d9aeb40367?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHw1fHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"
          ),
          user: User(name: "Diogo Fagundes")),
    Photo(id: "5",
          width: 3840,
          height: 5760,
          urls: URLs(
            full: "https://images.unsplash.com/photo-1610049435527-f35df6297359?crop=entropy&cs=srgb&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHw2fHx8fHx8Mnw&ixlib=rb-1.2.1&q=85",
            regular: "https://images.unsplash.com/photo-1610049435527-f35df6297359?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwxOTY1NTR8MHwxfGFsbHw2fHx8fHx8Mnw&ixlib=rb-1.2.1&q=80&w=1080"
          ),
          user: User(name: "Kristina Delp"))
]
