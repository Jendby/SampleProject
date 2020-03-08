//
//  ServicesAssembler.swift
//  SampleProject
//
//  Created by Eugene Smolyakov on 28/02/2020.
//  Copyright © 2020 ES. All rights reserved.
//


import Foundation

protocol ServiceLocatorModulProtocol {
    func registerServices(serviceLocator: ServicesAssembler)
}

final class ServicesAssembler {
    init() {
        let secrets = Secret()
        registerSingleton(singletonInstance: secrets as SecretServiceProtocol)

        let tm = ThemeManager()
        registerSingleton(singletonInstance: tm as ThemeManagerProtocol)
        registerSingleton(singletonInstance: tm as ThemebleRouting)
        
        let cfgName: String
        cfgName = "network"
        let cfg = NetworkConfig.getConfiguration(name: cfgName)
        let transport = MobileNetTransport(config: cfg, secret: secrets)
        let manager = NetManager(cfg: cfg,
                                 secret: secrets,
                                 transport: transport)
        let net = NetFun(netmanager: manager)
        registerSingleton(singletonInstance: net as NetAuthService)
        registerSingleton(singletonInstance: net as NetPlaceholderJSON)

        let imageFromCamera =  CamConnect()
        registerSingleton(singletonInstance: imageFromCamera as CamConnectService)
        
        let motionTracker = MotionTracker()
        registerSingleton(singletonInstance: motionTracker as MotionTrackerService)
    }

    // MARK: Registration

    public func register<Service>(factory: @escaping () -> Service) {
        let serviceId = ObjectIdentifier(Service.self)
        registry[serviceId] = factory
    }

    public static func register<Service>(factory: @escaping () -> Service) {
        sharedServices.register(factory: factory)
    }

    public func registerSingleton<Service>(singletonInstance: Service) {
        let serviceId = ObjectIdentifier(Service.self)
        registry[serviceId] = singletonInstance
    }

    public static func registerSingleton<Service>(singletonInstance: Service) {
        sharedServices.registerSingleton(singletonInstance: singletonInstance)
    }

    public func registerModules(modules: [ServiceLocatorModulProtocol]) {
        modules.forEach { $0.registerServices(serviceLocator: self) }
    }

    public static func registerModules(modules: [ServiceLocatorModulProtocol]) {
        sharedServices.registerModules(modules: modules)
    }

    // MARK: Injection

    public static func inject<Service>() -> Service {
        return sharedServices.inject()
    }

    // MARK: private

    private func inject<Service>() -> Service {
        let serviceId = ObjectIdentifier(Service.self)
        if let factory = registry[serviceId] as? () -> Service {
            return factory()
        } else if let singletonInstance = registry[serviceId] as? Service {
            return singletonInstance
        } else {
            fatalError("No registered entry for \(Service.self)")
        }
    }

    private var registry = [ObjectIdentifier:Any]()
    private static var sharedServices: ServicesAssembler = {
        let shared = ServicesAssembler()
        return shared
    }()
}
