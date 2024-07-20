/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "lvfpsa5vkxx4h8v",
    "created": "2024-07-20 23:16:51.461Z",
    "updated": "2024-07-20 23:16:51.461Z",
    "name": "chargeitemdefinition",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "pkuvfxq5",
        "name": "versionId",
        "type": "number",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "noDecimal": false
        }
      },
      {
        "system": false,
        "id": "lm2zyc9i",
        "name": "resource",
        "type": "json",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "maxSize": 5242880
        }
      }
    ],
    "indexes": [],
    "listRule": "@request.auth.id != ''",
    "viewRule": "@request.auth.id != ''",
    "createRule": "@request.auth.id != ''",
    "updateRule": "@request.auth.id != ''",
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("lvfpsa5vkxx4h8v");

  return dao.deleteCollection(collection);
})
