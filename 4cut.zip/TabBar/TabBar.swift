//
//  TabBar.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/25/24.
//

import UIKit

enum TabBar: String, CaseIterable {
    case collection
    case suggestion = "추천"
    case profile

    var image: UIImage? {
        switch self {
        case .collection:
            return UIImage(systemName: "photo.on.rectangle.angled")
        case .suggestion:
            return UIImage(systemName: "cursorarrow.rays")
        case .profile:
            return UIImage(systemName: "person.crop.square")
        }
    }

    var controller: UIViewController {
        switch self {
        case .collection:
            return CollectionViewController()
        case .suggestion:
            return SuggestionViewController()
        case .profile:
            return ProfileViewController()
        }
    }

}
