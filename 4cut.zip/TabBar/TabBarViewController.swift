//
//  TabBarViewController.swift
//  4cut.zip
//
//  Created by Bora Yang on 8/25/24.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTabBar()
        configureAppearance()
    }

    private func configureTabBar() {
        var viewControllers: [UIViewController] = []

        TabBar.allCases.forEach { tabBar in
            let vc = UINavigationController(rootViewController: tabBar.controller)
            vc.tabBarItem = UITabBarItem(title: tabBar.title, image: tabBar.image, tag: 0)
            viewControllers.append(vc)
        }

        setViewControllers(viewControllers, animated: true)
    }

    private func configureAppearance() {
        UITabBar.appearance().backgroundColor = Constant.Color.secondaryPink
        UITabBar.appearance().unselectedItemTintColor = Constant.Color.secondaryLightPink
        UITabBar.appearance().tintColor = Constant.Color.accent
    }

}
