/// `Configurable` provides a setter function for each of its values properties.
/// The result of the setter function is the value with the new property applies.
@dynamicMemberLookup
public struct Configurable<T> {
  let value: T

  /// Returns a setter closure via the name of the member that the closure will change.
  /// ```
  /// let titanRefit = Starship.titan/
  ///   .commandingOfficer("Liam Shaw")
  /// ```
  public subscript<V>(dynamicMember keyPath: WritableKeyPath<T, V>) -> (V) -> T {
    { propertyValue in
      var mutatableValue = value
      mutatableValue[keyPath: keyPath] = propertyValue
      return mutatableValue
    }
  }

  /// Returns a mapping closure via the name of the member that the closure will change.
  /// ```
  /// let titanRefit = Starship.titan/.registry({ $0.appending("-A") })
  /// ```
  public subscript<V>(dynamicMember keyPath: WritableKeyPath<T, V>) -> ((V) -> V) -> T {
    { propertyMapping in
      var mutatableValue = value
      mutatableValue[keyPath: keyPath] = propertyMapping(mutatableValue[keyPath: keyPath])
      return mutatableValue
    }
  }

  /// Mutates a configurable value via the provided closure.
  /// ```
  /// let titanRefit = Starship.titan/ {
  ///   $0.commandingOfficer = "Liam Shaw"
  ///   $0.registry = "NCC-80102-A"
  ///   $0.isActive = true
  /// }
  /// ```
  public func callAsFunction(_ transform: (_ value: inout T) -> Void) -> T {
    var mutatableValue = value
    transform(&mutatableValue)
    return mutatableValue
  }


  /// Mutates a configurable value via the provided closure.
  /// Like call as function, but can look better when mixed with the dynamic member lookup.
  /// ```
  /// let titanRefit = Starship.titan/
  ///   .commandingOfficer("Liam Shaw")/
  ///   .configure({ $0.isActive = year >= 2396 })/
  ///   .registry("NCC-80102-A")
  /// ```
  public func configure(_ transform: (_ value: inout T) -> Void) -> T {
    var mutatableValue = value
    transform(&mutatableValue)
    return mutatableValue
  }
}


/// An operator that makes the value it is applied to `Configurable`.
postfix operator /
public postfix func /<T>(_ value: T) -> Configurable<T> {
  return Configurable(value: value)
}
