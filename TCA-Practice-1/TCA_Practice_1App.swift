//
//  TCA_Practice_1App.swift
//  TCA-Practice-1
//
//  Created by KIM Hyung Jun on 3/5/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_Practice_1App: App {
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: Store(initialState: Counter.State()) {
                    Counter()
                }
            )
        }
    }
}
