//
//  Coordinator.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/26/24.
//

import UIKit

enum Coordinator {

    static func moveRoot(vc: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let rootVC = vc
        sceneDelegate?.window?.rootViewController = rootVC
        sceneDelegate?.window?.makeKeyAndVisible()
    }

}
