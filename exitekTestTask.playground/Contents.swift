// Implement mobile phone storage protocol
// Requirements:
// - Mobiles must be unique (IMEI is an unique number)
// - Mobiles must be stored in memory

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei: String) -> Mobile?
    func save(_ mobile: Mobile) throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}

struct Mobile: Hashable {
    let imei: String
    let model: String
}

enum ErrorType: Error {
    case notUniqueImei
    case productNotExist
}

class MobileStore: MobileStorage {
    private var mobileStorage = [String:Mobile]()

    func getAll() -> Set<Mobile> {
        return Set(mobileStorage.values)
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        return mobileStorage[imei]
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        guard !exists(mobile) else {
            throw ErrorType.notUniqueImei
        }
        mobileStorage[mobile.imei] = mobile
        return mobile
    }
    
    func delete(_ product: Mobile) throws {
        guard mobileStorage.removeValue(forKey: product.imei) != nil else {
            throw ErrorType.productNotExist
        }
    }
    
    func exists(_ product: Mobile) -> Bool {
        return mobileStorage.keys.contains(product.imei)
    }
    
}

func test(mobStorage: MobileStorage) {
    let mob1 = Mobile(imei: "1234", model: "Nokia3310")
    let mob2 = Mobile(imei: "2234", model: "Nokia3250")
    let mob3 = Mobile(imei: "3234", model: "Nokia3310")
    let mob4 = Mobile(imei: "1234", model: "SamsungA50")
    
    [mob1, mob2, mob3, mob4].forEach { mob in
        do {
            try mobStorage.save(mob)
            print("\(mob) saved")
        } catch {
            print("Error, \(mob) \(error)")
        }
    }
    
    [mob1, mob2, mob4].forEach { mob in
        do {
            try mobStorage.delete(mob)
            print("\(mob) deleted")
        } catch {
            print("Error, \(mob) \(error)")
        }
    }
    
    [mob1, mob2, mob3, mob4].forEach { mob in
        print("\(mobStorage.findByImei(mob.imei)?.model ?? "nil") found by Imei")
    }
    
    mobStorage.getAll()
    
    assert(!mobStorage.exists(mob1))
    assert(!mobStorage.exists(mob2))
    assert(!mobStorage.exists(mob4))
    assert(mobStorage.exists(mob3))
}

test(mobStorage: MobileStore())
