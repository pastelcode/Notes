//
//  ServiceContainer.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/24/23.
//

import Foundation

final class ServiceContainer {
    enum ServiceType {
        case singleton
        case new
    }
    
    private static var servicesFactories: [String: () -> Any] = [:]
    private static var cachedServices: [String: Any] = [:]
    
    static func register<Service>(_ type: Service.Type, _ factory: @autoclosure @escaping () -> Service) {
        servicesFactories[String(describing: type.self)] = factory
    }
    
    static func resolve<Service>(_ resolveType: ServiceType = .singleton, _ type: Service.Type) -> Service? {
        let serviceName = String(describing: type.self)
        
        switch resolveType {
        case .singleton:
            if let service = cachedServices[serviceName] as? Service {
                return service
            }
            if let service = servicesFactories[serviceName]?() as? Service {
                cachedServices[serviceName] = service
                return service
            }
            return nil
        case .new:
            return servicesFactories[serviceName]?() as? Service
        }
    }
}

@propertyWrapper struct Service<Service> {
    var wrappedValue: Service {
        get {
            self.service
        }
        
        mutating set {
            service = newValue
        }
    }
    
    var service: Service
    
    init(_ type: ServiceContainer.ServiceType = .singleton) {
        guard let service = ServiceContainer.resolve(type, Service.self) else {
            let serviceName = String(describing: Service.self)
            fatalError("No service of type \(serviceName) registered.")
        }
        self.service = service
    }
}
