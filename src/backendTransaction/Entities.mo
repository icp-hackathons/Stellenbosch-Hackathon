import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Cycles "mo:base/ExperimentalCycles";
import Types "../commons/Types";
import Entity "Entity";

actor Entities {
    type Entity = Entity.Entity;
    stable var entityArray : [Entity] = [];
    var entityBuffer = Buffer.fromArray<Entity>(entityArray);
    stable var entityID = 0;
    
    public func createEntity(name : Text, category : Types.Category) : async Entity {
        let cycles = Cycles.add(200000000000);
        let ent = await Entity.Entity(entityID, name, category);
        incrementID();
        return ent;
    };

    public func incrementID() : () {
        entityID += 1;
    };

    public query func getID() : async Nat {
        return entityID;
    };

    public func resetID() : () {
        entityID := 0;
    };

    public func storeEntity(entity : Entity) : async () {
        entityBuffer.add(entity);
        entityArray := Buffer.toArray<Entity>(entityBuffer);
    };

    public query func getAllEntities() : async [Entity] {
        return entityArray;
    };

    public func getEntityById(id : Nat) : async ?Entity {
        let entityArr = await getAllEntities();
        for (entity in entityArr.vals()) {
            let entityId = await entity.getID();
            if (entityId == id) {
                switch (?entity) {
                    case (null) {};
                    case (entity) { return entity };
                };
            };
        };
        return null;
    };

};
