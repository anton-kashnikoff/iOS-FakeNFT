//
//  Observable.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 15.10.2023.
//

import Foundation

@propertyWrapper final class Observable<Value> {
    private var valueChanged: ((Value) -> Void)? = nil
    
    var wrappedValue: Value {
        didSet {
            valueChanged?(wrappedValue)
        }
    }
    
    var projectedValue: Observable<Value> {
        return self
    }
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    func makeBinding(action: @escaping (Value) -> Void) {
        valueChanged = action
    }
}
