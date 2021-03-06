//
//  SettingsRouter.swift
//  HiPDA
//
//  Created by leizh007 on 2016/11/9.
//  Copyright © 2016年 HiPDA. All rights reserved.
//

import UIKit
import Perform
import RxSwift
import RxCocoa

fileprivate let kUnMatchedCase = "Unmatched case!"

/// 设置路由
struct SettingsRouter {
    /// viewController
    fileprivate weak var viewController: SettingsViewController?
    
    init(viewController: SettingsViewController) {
        self.viewController = viewController
    }
    
    /// 处理item选择
    ///
    /// - Parameter indexPath: 选择的下标
    func handleSelection(for indexPath: IndexPath) {
        guard let settingsSegue = try? SettingsSegue(indexPath: indexPath) else { return }
        switch settingsSegue {
        case .accountManagement:
            showAccountManagementViewController(with: settingsSegue)
        case .userBlock:
            fallthrough
        case .threadBlock:
            showEditWordsViewController(with: settingsSegue)
        case .pmDoNotDisturb:
            showPmDoNotDisturbViewController(with: settingsSegue)
        case .activeForumNameList:
            showActiveForumNameListViewController(with: settingsSegue)
        case .userRemark:
            showUserRemarkViewController(with: settingsSegue)
        }
    }
}

// MARK: - AccountManagement

extension SettingsRouter {
    /// 跳转到账户管理页面
    ///
    /// - Parameter settingsSegue: 页面类型
    fileprivate func showAccountManagementViewController(with settingsSegue: SettingsSegue) {
        guard case .accountManagement = settingsSegue else {
            assertionFailure(kUnMatchedCase)
            return
        }
        guard let viewController = self.viewController else { return }
        
        viewController.perform(.accountManagement) { accountManagementViewController in
            accountManagementViewController.title = settingsSegue.rawValue
        }
    }
}

// MARK: - EditWords

extension SettingsRouter {
    /// 跳转到编辑词组页面
    ///
    /// - Parameter settingsSegue: 页面类型
    fileprivate func showEditWordsViewController(with settingsSegue: SettingsSegue) {
        guard let viewController = self.viewController else { return }
        let words: [String]
        switch settingsSegue {
        case .userBlock:
            words = viewController.viewModel.userBlockList
        case .threadBlock:
            words = viewController.viewModel.threadBlockWordList
        default:
            assertionFailure(kUnMatchedCase)
            words = []
        }
        
        viewController.perform(.editWords) { editWordsViewController in
            editWordsViewController.title = settingsSegue.rawValue
            editWordsViewController.words = words
            editWordsViewController.completion = { words in
                switch settingsSegue {
                case .userBlock:
                    self.viewController?.viewModel.userBlockList = words
                case .threadBlock:
                    self.viewController?.viewModel.threadBlockWordList = words
                default:
                    break
                }
            }
        }
    }
}

// MARK: - PmDoNotDisturb

extension SettingsRouter {
    /// 跳转到编辑消息免打扰的的界面
    ///
    /// - Parameter setttingsSegue: 页面类型
    fileprivate func showPmDoNotDisturbViewController(with setttingsSegue: SettingsSegue) {
        guard case .pmDoNotDisturb = setttingsSegue else {
            assertionFailure(kUnMatchedCase)
            return
        }
        
        guard let viewController = self.viewController else { return }
        
// http://stackoverflow.com/questions/31862935/uitableviewcell-very-slow-response-on-select
//        DispatchQueue.main.async {
        viewController.perform(.pmDoNotDisturb) { pmDoNotDisturbVC in
            pmDoNotDisturbVC.title = setttingsSegue.rawValue
            pmDoNotDisturbVC.fromTime = viewController.viewModel.pmDoNotDisturbFromTime
            pmDoNotDisturbVC.toTime = viewController.viewModel.pmDoNotDisturbToTime
            pmDoNotDisturbVC.completion = { (fromTime, toTime) in
                viewController.viewModel.pmDoNotDisturbFromTime = fromTime
                viewController.viewModel.pmDoNotDisturbToTime = toTime
            }
        }
//        }
    }
}

// MARK: - UserRemark

extension SettingsRouter {
    /// 跳转到编辑用户备注界面
    ///
    /// - Parameter setttingsSegue: 页面类型
    fileprivate func showUserRemarkViewController(with setttingsSegue: SettingsSegue) {
        guard case .userRemark = setttingsSegue else {
            assertionFailure(kUnMatchedCase)
            return
        }
        guard let viewController = self.viewController else { return }
        
        viewController.perform(.userRemark) { userRemarkViewController in
            userRemarkViewController.title = setttingsSegue.rawValue
            userRemarkViewController.userRemarkDictionary = viewController.viewModel.userRemarkDictionary
            userRemarkViewController.complation = { userRemarkDictionary in
                viewController.viewModel.userRemarkDictionary = userRemarkDictionary
            }
        }
    }
}

extension SettingsRouter {
    /// 跳转到版块列表界面
    ///
    /// - Parameter setttingsSegue: 页面类型
    fileprivate func showActiveForumNameListViewController(with settingsSegue: SettingsSegue) {
        guard case .activeForumNameList = settingsSegue else {
            assertionFailure(kUnMatchedCase)
            return
        }
        guard let viewController = self.viewController else { return }
        
        viewController.perform(.activeForumNameList) { activeForumNameListViewController in
            activeForumNameListViewController.title = settingsSegue.rawValue
            activeForumNameListViewController.activeForumNameList = viewController.viewModel.activeForumNameList
            activeForumNameListViewController.completion = { activeForumNames in
                viewController.viewModel.activeForumNameList = activeForumNames.count == 0 ? ForumManager.defalutForumNameList : activeForumNames
            }
        }
    }
}
