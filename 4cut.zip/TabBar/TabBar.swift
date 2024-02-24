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
    case post = "새로운 글 작성"
    case shopping = "쇼핑"
    case profile

    var image: UIImage? {
        switch self {
        case .collection:
            return UIImage(systemName: "photo.on.rectangle.angled")
        case .suggestion:
            return UIImage(systemName: "cursorarrow.rays")
        case .profile:
            return UIImage(systemName: "person.crop.square")
        case .post:
            return UIImage(systemName: "square.and.pencil")
        case .shopping:
            return UIImage(systemName: "handbag")
        }
    }

    var title: String {
        switch self {
        case .collection:
            return "모아보기"
        case .suggestion:
            return "추천"
        case .profile:
            return "프로필"
        case .post:
            return "포스트 작성"
        case .shopping:
            return "쇼핑"
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
        case .post:
            return PostViewController()
        case .shopping:
            return ShoppingViewController()
        }
    }

}
