//
//  ServiceContainer.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/24/23.
//

import Foundation

final class ServiceContainer {
  enum ResolveType {
    case singleton
    case new
  }

  private static var servicesFactories: [String: () -> Any] = [:]
  private static var cachedServices: [String: Any] = [:]

  static func register<Service>(
    type: Service.Type,
    using factory: @autoclosure @escaping () -> Service
  ) {
    let serviceName = String(describing: type.self)
    servicesFactories[serviceName] = factory
    print("Service '\(serviceName)' registered.")
  }

  static func resolve<Service>(type: Service.Type, as resolveType: ResolveType) -> Service? {
    let serviceName = String(describing: type.self)

    switch resolveType {
    case .singleton:
      if let service = cachedServices[serviceName] as? Service {
        print("\(serviceName) resolved from cache.")
        return service
      }
      if let service = servicesFactories[serviceName]?() as? Service {
        cachedServices[serviceName] = service
        print("\(serviceName) resolved from factory.")
        return service
      }
      return nil
    case .new:
      return servicesFactories[serviceName]?() as? Service
    }
  }

  static func clear() {
    cachedServices.removeAll()
    servicesFactories.removeAll()
  }
}
