import Vapor

actor WarehouseManager: Sendable {
    private var warehouses: [Warehouse] = []
    private var products: [Int: [Product]] = [:]
    private let lock = Lock()

    func getAllWarehouses() -> [Warehouse] {
        lock.withLock { warehouses }
    }

    func createWarehouse(name: String, location: String) -> Bool {
        lock.withLock {
            let newWarehouse = Warehouse(id: (warehouses.last?.id ?? 0) + 1, name: name, location: location)
            warehouses.append(newWarehouse)
            return true
        }
    }

    func getWarehouse(by id: Int) -> Warehouse? {
        lock.withLock { warehouses.first { $0.id == id } }
    }

    func updateWarehouse(id: Int, name: String, location: String) -> Bool {
        lock.withLock {
            guard let index = warehouses.firstIndex(where: { $0.id == id }) else { return false }
            warehouses[index] = Warehouse(id: id, name: name, location: location)
            return true
        }
    }
    
    func partialUpdateWarehouse(id: Int, name: String?, location: String?) -> Bool {
        lock.withLock {
            guard let index = warehouses.firstIndex(where: { $0.id == id }) else { return false }
            
            if let name {
                warehouses[index].name = name
            }
            if let location {
                warehouses[index].location = location
            }
            
            return true
        }
    }


    func deleteWarehouse(id: Int) -> Bool {
        lock.withLock {
            guard let index = warehouses.firstIndex(where: { $0.id == id }) else { return false }
            warehouses.remove(at: index)
            return true
        }
    }

    func getProducts(in warehouseId: Int) -> [Product]? {
        lock.withLock { products[warehouseId] }
    }

    func addProduct(to warehouseId: Int, name: String, quantity: Int) -> Bool {
        lock.withLock {
            guard warehouses.contains(where: { $0.id == warehouseId }) else { return false }
            let newProduct = Product(id: UUID(), name: name, quantity: quantity)
            products[warehouseId, default: []].append(newProduct)
            return true
        }
    }
}
