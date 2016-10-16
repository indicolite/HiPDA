//
//  LoginResult.swift
//  HiPDA
//
//  Created by leizh007 on 2016/10/3.
//  Copyright © 2016年 HiPDA. All rights reserved.
//

import Foundation

enum LoginError: Error {
    case nameOrPasswordUnCorrect(timesToRetry: Int)
    case attempCountExceedsLimit
    case unKown(String)
}

extension LoginError: CustomStringConvertible {
    var description: String {
        switch self {
        case .nameOrPasswordUnCorrect(timesToRetry: let count):
            return "登录失败，您还可以尝试 \(count) 次"
        case .attempCountExceedsLimit:
            return "密码错误次数过多，请 15 分钟后重新登录"
        case .unKown(let value):
            return value
        }
    }
}

typealias LoginResult = Result<Bool, LoginError>