//
//  AppRouter.swift
//  PocketBankKids
//
//  Created by Nazaret, Claiton Milton Augusto on 25/11/26.
//

import SwiftUI
import Observation

enum AppRoute: Hashable {
    case history
    case missions
    case familyRanking
    case goalDetail(SavingsGoal)
}

@Observable final class AppRouter {
    var path = NavigationPath()
    var isPresentingAddModal = false
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
