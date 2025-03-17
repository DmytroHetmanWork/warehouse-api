import Vapor

func routes(_ app: Application) throws {
    let warehouseManager = WarehouseManager()

    // MARK: - Warehouses
    
    // Get all warehouses
    app.get("warehouses") { req async throws -> [Warehouse] in
        await warehouseManager.getAllWarehouses()
    }


    // Create a new warehouse
    app.post("warehouses") { req -> HTTPStatus in
        struct CreateWarehouseRequest: Content {
            let name: String
            let location: String
        }

        let input = try req.content.decode(CreateWarehouseRequest.self)
        let result = await warehouseManager.createWarehouse(name: input.name, location: input.location)
        
        return result ? .created : .badRequest
    }

    // Get warehouse by ID
    app.get("warehouses", ":warehouseId") { req -> Response in
        guard let warehouseId = req.parameters.get("warehouseId", as: Int.self),
              let warehouse = await warehouseManager.getWarehouse(by: warehouseId) else {
            return Response(status: .notFound)
        }
        return Response(status: .ok, body: .init(data: try JSONEncoder().encode(warehouse)))
    }

    // Update warehouse by ID
    app.put("warehouses", ":warehouseId") { req -> HTTPStatus in
        struct UpdateWarehouseRequest: Content {
            let name: String
            let location: String
        }

        guard let warehouseId = req.parameters.get("warehouseId", as: Int.self),
              let input = try? req.content.decode(UpdateWarehouseRequest.self) else {
            return .badRequest
        }

        let result = await warehouseManager.updateWarehouse(id: warehouseId, name: input.name, location: input.location)
        return result ? .ok : .notFound
    }
    
    // Partial update warehouse by ID
    app.patch("warehouses", ":warehouseId") { req -> HTTPStatus in
        struct PatchWarehouseRequest: Content {
            let name: String?
            let location: String?
        }

        guard let warehouseId = req.parameters.get("warehouseId", as: Int.self),
              let input = try? req.content.decode(PatchWarehouseRequest.self) else {
            return .badRequest
        }

        let result = await warehouseManager.partialUpdateWarehouse(id: warehouseId, name: input.name, location: input.location)
        return result ? .ok : .notFound
    }

    // Delete warehouse by ID
    app.delete("warehouses", ":warehouseId") { req -> HTTPStatus in
        guard let warehouseId = req.parameters.get("warehouseId", as: Int.self) else {
            return .badRequest
        }

        let result = await warehouseManager.deleteWarehouse(id: warehouseId)
        return result ? .noContent : .notFound
    }

    // MARK: - Products within Warehouses
    
    // Get all products in a warehouse
    app.get("warehouses", ":warehouseId", "products") { req -> Response in
        guard let warehouseId = req.parameters.get("warehouseId", as: Int.self),
              let products = await warehouseManager.getProducts(in: warehouseId) else {
            return Response(status: .notFound)
        }
        return Response(status: .ok, body: .init(data: try JSONEncoder().encode(products)))
    }

    // Add a new product to a warehouse
    app.post("warehouses", ":warehouseId", "products") { req -> HTTPStatus in
        struct CreateProductRequest: Content {
            let name: String
            let quantity: Int
        }

        guard let warehouseId = req.parameters.get("warehouseId", as: Int.self),
              let input = try? req.content.decode(CreateProductRequest.self) else {
            return .badRequest
        }

        let result = await warehouseManager.addProduct(to: warehouseId, name: input.name, quantity: input.quantity)
        return result ? .created : .notFound
    }
}

