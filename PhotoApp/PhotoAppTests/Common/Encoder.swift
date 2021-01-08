//
//  Encoder.swift
//  PhotoAppTests
//
//  Created by 신한섭 on 2021/01/08.
//

@testable import PhotoApp
import Foundation

struct ModelEncoder<T: Encodable> {
    private let encoder: JSONEncoder
    
    init(encoder: JSONEncoder = JSONEncoder()) {
        self.encoder = encoder
    }
    
    func encode(with model: T) -> Data? {
        do {
           return try encoder.encode(model)
        } catch {
            return nil
        }
    }
}
