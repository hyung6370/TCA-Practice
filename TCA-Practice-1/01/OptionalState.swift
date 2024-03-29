//
//  OptionalState.swift
//  TCA-Practice-1
//
//  Created by KIM Hyung Jun on 3/29/24.
//

import SwiftUI
import ComposableArchitecture

private let readMe = """
  This screen demonstrates how to show and hide views based on the presence of some optional child \
  state.

  The parent state holds a `Counter.State?` value. When it is `nil` we will default to a plain \
  text view. But when it is non-`nil` we will show a view fragment for a counter that operates on \
  the non-optional counter state.

  Tapping "Toggle counter state" will flip between the `nil` and non-`nil` counter states.
  
  
  이 코드는 스유와 TCA를 사용하여 선택적 상태 관리의 예를 보여주는 프로그램이다.
  여기서 optional state란 어떤 값이 있을 수도 있고, 없을 수도 있는 상태를 의미한다.
  이 예제는 사용자가 UI의 버튼을 통해 특정 상태(여기서는 카운터)의 존재 여부를 토글할 수 있게 하며,
  상태의 존재 여부에 따라 다른 뷰를 보여주는 방식으로 선택적 상태를 활용한다.
  """

@Reducer
struct OptionalBasics {
    @ObservableState
    struct State: Equatable {
        var optionalCounter: Counter.State? // optional State를 관리
    }
    
    enum Action {
        case optionalCounter(Counter.Action)
        case toggleCounterButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .toggleCounterButtonTapped:
                state.optionalCounter = state.optionalCounter == nil ? Counter.State() : nil
                return .none
            case .optionalCounter:
                return .none
            }
        }
        .ifLet(\.optionalCounter, action: \.optionalCounter) {
            Counter()
        }
        // ifLet 연산자를 사용하여 optionalCounter가 nil이 아닐 때만 Counter 리듀서로 이벤트를 전달한다.
    }
}

struct OptionalBasicsView: View {
    let store: StoreOf<OptionalBasics>
    
    var body: some View {
        Form {
            Section {
                AboutView(readMe: readMe)
            }
            
            Button("Toggle counter state") {
                store.send(.toggleCounterButtonTapped)
            }
            
            // optionalCounter 상태가 nil인지 아닌지에 따라 다른 텍스트 또는 CounterView를 보여준다.
            if let store = store.scope(state: \.optionalCounter, action: \.optionalCounter) {
                Text(template: "`Counter.State` is `nil`")
                CounterView(store: store)
                    .buttonStyle(.borderless)
                    .frame(maxWidth: .infinity)
            }
            else {
                Text(template: "`Counter.State` is `nil`")
            }
        }
        .navigationTitle("Optional state")
    }
}

#Preview {
    NavigationStack {
        OptionalBasicsView(
            store: Store(initialState: OptionalBasics.State()) {
                OptionalBasics()
            }
        )
    }
}

#Preview("Deep-linked") {
    NavigationStack {
        OptionalBasicsView(store: Store(
            initialState: OptionalBasics.State(
                optionalCounter: Counter.State(
                    count: 42
                )
            )
        ) {
            OptionalBasics()
        })
    }
}
