//
//  TwoCounters.swift
//  TCA-Practice-1
//
//  Created by KIM Hyung Jun on 3/6/24.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct TwoCounters {
    @ObservableState
    struct State: Equatable {
        var counter1 = Counter.State()
        var counter2 = Counter.State()
    }
    
    enum Action {
        case counter1(Counter.Action)
        case counter2(Counter.Action)
    }
    
    var body: some Reducer<State, Action> {
        Scope(state: \.counter1, action: \.counter1) {
            Counter()
        }
        Scope(state: \.counter2, action: \.counter2) {
            Counter()
        }
    }
}

struct TwoCounterView: View {
    let store: StoreOf<TwoCounters>
    
    var body: some View {
        Form {
            HStack {
                Text("Counter 1")
                Spacer()
                CounterView(store: store.scope(state: \.counter1, action: \.counter1))
            }
            
            HStack {
                Text("Counter 2")
                Spacer()
                CounterView(store: store.scope(state: \.counter2, action: \.counter2))
            }
        }
        .buttonStyle(.borderless)
        .navigationTitle("Two counters demo")
    }
}

#Preview {
    TwoCounterView(store: Store(initialState: TwoCounters.State()) {
        TwoCounters()
    })
}
