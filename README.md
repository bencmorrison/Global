# Global

There have been just a small few instances where I'd like to be able to use `SwiftUI`'s `@Environment` in non-`SwiftUI`
areas of some applications that are a mix of `SwiftUI` and `UIKit`. Why? I guess because I find the idea better than
using a singleton.

So I created `Global` which behaves like `@Environment`. It even has a similar setup as `@Environment`.

## Usage

There are two ways you can use `Global`. 

1. The first way is the non-macro way. This way gives you full control over everything when it comes to using `Global`. There is a great property wrapper `@Global` to help access global in structures.

2. Using macros to create and gain access to the values. These can be used in combination with the proprety wapper for full effect. There is `@Item`, `@Accessor`, and `#Global` macros to help use `Global` in a lot of various situations.

### The non-macro way

This example shows you how to enable a type, in this case an Enum, to be used as a `Global`. This is the typical way one would set it up, as if they were using `@Environment` from `SwiftUI`. It is a bit wordy but not too wordy.

#### Example Setup

```swift
import Global

// This is the enum we want at a global scope
enum SomeGlobalState {
    case unknown, loading, loaded(Data)
}

// We are going to extend out enum by conforming to `GlobalKey`
extension SomeGlobalState: GlobalKey {
    static let defaultValue: Self = .unknown
}

// Then we extend `GlobalValues` to give us a key path to use.
extension GlobalValues {
    // This is the key path we are going to use.
    // We will need to create the setter and getter for the value.
    var state: SomeGlobalState {
        get { self[SomeGlobalState.self] }
        set { self[SomeGlobalState.self] = newValue }
    }
}
```

#### Example Property Wrapper Usage

```swift
import Global

// Then you use the property wrapper in some type.
final class SomeRandomClass {
    /// This will allow us access to the `SomeGlobalState` stored in `GlobalValues`
    //If you want this to be Read and Write use @GlobalRW
    @Global(\.state) var state
}
```

### Using `Global`'s macros

There are various macros that are in `GlobalMacros` to help you with using `Global` in general. The macro framework provides helpers for creating a `GlobalKey` in `GlobalValues` and accessors for when using the property wrapper may not be advantagous.

The various macros are:

1. [`@Item`](#the-item-macro)
2. [`@Accessor`](#the-accessor-macro)
3. [`#Global`](#the-global-macro)

#### The `@Item` macro

The `@Item` macro works like the `@Entry` macro for SwiftUI's `@Environment`. Like the entry macro, you do not need to make your object confrom to `GlobalKey` and then define it yourself in `GlobalValues` you can use the macro to provide conformance.

##### Requirements: 

- You must use the macro in an extension of `GlobalValues`
- At this type your variables are required to have type annotation.
- The variable must be initalized _unless_ it is optional.

##### `@Item` has some arguments

| Argument | Type | Description |
| -------- | ---- | ----------- |
| accessors | `AccessorType` | By default this macro will create a getter and setter for the value in `GlobalValues`. You can set this to `.getter` if you'd like to only have a getter created. It will ignore `.setter` do default behaviour. |
| propertyType | `PropertyType` | The macro allows you to control if the wrapper class that provides conformance creates a constant default or a property wrapper constant. By default it is `.constant` |

##### Usage:

```swift
import Global
import GlobalMacros

extension GlobalValues {
    // Using @Item here, will create an item in the
    // GlobalValues with the getter and setters
    // that an be used across the app.
    @Item var userState: UserState = .unknown
}
```

#### The `@Accessor` macro

`@Accessor` allows you to create a property in an extension so you can access the value in `GlobalValues`. This is useful when you want to access the value in an extension and you can't add the property wrapper to the main object.

##### Requirements: 

- Currently `@Accessor` only works in extensions.
- Variables are required to have type annotation.

##### `@Item` has some arguments

| Argument | Type | Description |
| -------- | ---- | ----------- |
| keypath | `KeyPath<GlobalValues, Value>` | The keypath of the value in the `GlobalValues` |
| type | `AccessorType` | This allows you to control if you'd like to create the getter and setter or getter only for the property. It will by default only provide the getter. If you attempt to set to setter only, default behaviour will be followed. |

##### Usage:

```swift
import Global
import GlobalMacros

extension SomeRandomThing {
    @Accessor(\.userState) var userState: UserState
}
```

#### The `#Global` macro

The `#Global` allows for even more fine grained usage of `Global` and it's values. There are two variations of this macro, a getter, and a setter.

##### `#Global` has some arguments

| Argument | Type | Description |
| -------- | ---- | ----------- |
| keypath | `KeyPath<GlobalValues, Value>` | The keypath of the value in the `GlobalValues`. When this is the only argument, the `Value` is returned. |
| newValue | Value? | This is optional, when used the value in `GlobalValues` will be set to the provided value. |

##### Usage:

```swift
import Global
import GlobalMacros

struct SomethingCool {
    func somethingReallyRealyCool() {
        // Grabs the value from `GlobalValues`
        let state = #Global(\.userState)
        switch state {
            // DO STUFF
        }
    }

    func userStateChangedForSomeReason() {
        // Set the userState to .unknown in `GlobalValues`
        #Global(\.userState, setTo: .unknown)
    }
}
```

## Adding `Global` as a depenancy

To use the `Global` library in a SwiftPM project, add the following line to the dependencies in your Package.swift file:

```swift
.package(url: "https://github.com/bencmorrison/swift-global.git", from: "<RELEASE_NUMBER>"),
```

include `Global` and `GlobalMacros` (only if you plan to use the macro way) as dependancies for your executable targets

```swift
.target(name: "<target>", dependencies: [
    .product(name: "Global", package: "swift-global"),
    .product(name: "GlobalMacros", package: "swift-global"),
]),
```

Finally, add `import Global` and `import GlobalMacros` to your source code as needed.

## Contributing

If you would like to contribute to this at all that is awesome. Though I do reserve the right to say no to changes.

Please feel free to file issues as well.
