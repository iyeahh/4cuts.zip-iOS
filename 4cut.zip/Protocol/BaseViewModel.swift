//
//  BaseViewModel.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/23/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol BaseViewModel {

    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output

}
