//
//  Observable.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 15.10.2023.
//

@propertyWrapper
final class ObservableWrapper<Value> {
    private var valueChanged: ((Value) -> Void)?
    
    var wrappedValue: Value {
        didSet {
            valueChanged?(wrappedValue)
        }
    }
    
    var projectedValue: ObservableWrapper<Value> {
        self
    }
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    func makeBinding(action: @escaping (Value) -> Void) {
        valueChanged = action
    }
}
