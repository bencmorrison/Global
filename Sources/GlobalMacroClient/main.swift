// Copyright © 2025 Ben Morrison. All rights reserved.

import Foundation
import Global
import GlobalMacros

enum GlobalState: String {
    case happy, sad, whoKnows
}

struct Thing {
    let name: String
}

extension GlobalValues {
    @Item(accessors: .getterAndSetter, propertyType: .computed) var state: GlobalState = .whoKnows
    @Item(accessors: .getter) var defaultInteger: Int = 1234567890
    @Item var test: String = "Hello, World!"
}

final class Client: CustomStringConvertible {
    @GlobalRW(\.state) private var state: GlobalState
    
    func changeState(to: GlobalState) {
        state = to
    }
    
    func getState() -> GlobalState {
        return state
    }
    
    var description: String { "Client       state: \(state)" }
}

struct ClientViewer: CustomStringConvertible {
    @Global(\.state) var globalState: GlobalState
    
    var description: String { "ClientViewer State: \(globalState)" }
}

extension Int {
    @Accessor(\.defaultInteger, type: .getter) var `default`: Int
}

let client = Client()
let viewer = ClientViewer()

print(client)
print(viewer)
client.changeState(to: .happy)
print(client)
print(viewer)
client.changeState(to: .sad)
print(client)
print(viewer)
print(Int.max.default)

var freestanding = #Global(\.test)
print(freestanding)
#Global(\.test, setTo: "LOOOOL")
freestanding = #Global(\.test)
print(freestanding)
