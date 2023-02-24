# SlashConfig

SlashConfig provides a convenient way to mutate value properties and return a mutated copy. Here is a small usage example:

```swift
import UIKit
import SlashConfig

class MyView: UIView {
  let subview = UIView()/.backgroundColor(.red)
  // ...
}
```

## Motivation

Consider this as your given type:

```swift
struct Starship {
  var commandingOfficer: String
  var registry: String
  var isActive: Bool
}

extension Starship {
  static let titan = Starship(
    commandingOfficer: "William T. Riker",
    registry: "NCC-80102",
    isActive: false
  )
}
```

Creating a new version of `Starship.titan` requires you to use a `var`.

```swift
var titanRefit = Starship.titan
titanRefit.commandingOfficer = "Liam Shaw"
titanRefit.registry = "NCC-80102-A"
titanRefit.isActive = true
```

This way has some disadvantages. For example you are not protected for unintentionally further mutate `titanRefit` as it stays mutable for the rest of the scope. In other cases it is just a lot of ceremony to just change one property of one provided value.

But more importantly: This syntax does not work in all places. For example it is not possible to configure properties of members of a class at the location where you define them. In this case you need to make sure the member is mutable and the first place you can mutate them is inside `init()`.

```swift
class TVShow {
  var starship = Starship.titan
  
  init() {
    starship.commandingOfficer = "Liam Shaw"
    starship.registry = "NCC-80102-A"
    starship.isActive = true
  } 
}

// or (if you want keep using `let`)

class TVShow {
  let starship: Starship
  
  init() {
    var starship = Starship.titan
    starship.commandingOfficer = "Liam Shaw"
    starship.registry = "NCC-80102-A"
    starship.isActive = true
    self.starship = starship 
  } 
}

```

## With SlashConfig
   
With SlashConfig you can mutate all properties of a value wherever you can access or define it and you can even keep it non-mutating. 


```swift
import SlashConfig

class TVShow {
  let starship = Starship.titan/
    .commandingOfficer("Liam Shaw")/
    .registry("NCC-80102-A")/
    .isActive(true)
  
  init() { }
}

// or

class TVShow {
  let starship = Starship.titan/ {
    $0.commandingOfficer = "Liam Shaw"
    $0.registry = "NCC-80102-A"
    $0.isActive = true
  }
  
  init() { }
}

```
