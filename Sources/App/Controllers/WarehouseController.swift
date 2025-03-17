import Vapor
import Fluent

//struct WarehouseController: RouteCollection {
//    
//    func boot(routes: RoutesBuilder) throws {
//        let warehouses = routes.grouped("warehouses")
//        warehouses.get(use: index)
//        warehouses.post(use: create)
//        warehouses.get(":warehouseID", use: show)
//        warehouses.put(":warehouseID", use: update)
//        warehouses.delete(":warehouseID", use: delete)
//    }
//    
//    func index(req: Request) async throws -> [Warehouse] {
//        try await Warehouse.query(on: req.db).all()
//    }
//    
//    func create(req: Request) async throws -> HTTPStatus {
//        let warehouse = try req.content.decode(Warehouse.self)
//        try await warehouse.save(on: req.db)
//        return .created
//    }
//    
//    func show(req: Request) async throws -> Warehouse {
//        guard let id = req.parameters.get("warehouseID", as: UUID.self),
//              let warehouse = try await Warehouse.find(id, on: req.db) else {
//            throw Abort(.notFound)
//        }
//        return warehouse
//    }
//    
//    func update(req: Request) async throws -> HTTPStatus {
//        guard let id = req.parameters.get("warehouseID", as: UUID.self),
//              let existingWarehouse = try await Warehouse.find(id, on: req.db) else {
//            throw Abort(.notFound)
//        }
//        
//        let updatedWarehouse = try req.content.decode(Warehouse.self)
//        existingWarehouse.name = updatedWarehouse.name
//        existingWarehouse.location = updatedWarehouse.location
//        
//        try await existingWarehouse.update(on: req.db)
//        return .ok
//    }
//    
//    func delete(req: Request) async throws -> HTTPStatus {
//        guard let id = req.parameters.get("warehouseID", as: UUID.self),
//              let warehouse = try await Warehouse.find(id, on: req.db) else {
//            throw Abort(.notFound)
//        }
//        
//        try await warehouse.delete(on: req.db)
//        return .noContent
//    }
//}
