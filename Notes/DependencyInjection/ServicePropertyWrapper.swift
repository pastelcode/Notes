//
//  ServicePropertyWrapper.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/24/23.
//

import Foundation

@propertyWrapper struct Service<Service> {
    private var service: Service
    
    var wrappedValue: Service {
        get { service }
        mutating set { service = newValue }
    }
    
    init(_ resolveType: ServiceContainer.ResolveType = .singleton) {
        guard let service = ServiceContainer.resolve(type: Service.self, as: resolveType) else {
            let serviceName = String(describing: Service.self)
            fatalError("No service of type \(serviceName) registered.")
        }
        self.service = service
    }
}
