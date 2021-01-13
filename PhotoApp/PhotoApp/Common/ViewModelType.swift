//
//  ViewModelType.swift
//  PhotoApp
//
//  Created by 신한섭 on 2021/01/13.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var bag: CancellableBag { get }
    
    func transform(input: Input) -> Output
}
