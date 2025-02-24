// Copyright © 2025 Ben Morrison. All rights reserved.

import Foundation

/// The `Global` framework uses `GlobalValues` to expose a collection of singleton
/// like values to your application. Use the `Global` property wrapper and specify
/// the value's key path. Ensure your value conforms to `GlobalKey`.
public struct GlobalValues: @unchecked Sendable {
    // MARK: - Static
    nonisolated(unsafe)
    static var shared: GlobalValues = .init()
    
    public static func get<V>(_ keyPath: KeyPath<GlobalValues, V>) -> V { shared[keyPath: keyPath] }
    public static func set<V>(_ keyPath: WritableKeyPath<GlobalValues, V>, to newValue: V) { shared[keyPath: keyPath] = newValue }
    
    // MARK: - Instance
    
    fileprivate var queue: DispatchQueue = .init(label: "co.bcm.Global.GlobalValues", qos: .userInteractive)
    fileprivate var storage: [ObjectIdentifier: Any] = [:]
    
    public subscript<K: GlobalKey>(_ key: K.Type) -> K.Value {
        get { queue.sync {
            self.storage[ObjectIdentifier(key)] as? K.Value ?? K.defaultValue
        } }
        set { queue.sync(flags: .barrier) {
            self.storage[ObjectIdentifier(key)] = newValue
        } }
    }
}

#if DEBUG
extension GlobalValues {
    mutating func wipeStorage() { storage.removeAll() }
    static func setSharedStorage(_ storage: GlobalValues) { shared = storage }
    static func testStorage() -> GlobalValues { .init() }
}

extension GlobalValues: CustomDebugStringConvertible {
    public var debugDescription: String {
        """
        GlobalValues: { \n"
            \(storage.map { "\t[\($0): \($1)],\n" })
        }
        """
    }
}
#endif
