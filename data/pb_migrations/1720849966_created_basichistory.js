/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "nf52aey6p64t3pk",
    "created": "2024-07-13 05:52:46.094Z",
    "updated": "2024-07-13 05:52:46.094Z",
    "name": "basichistory",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "u8e4pbat",
        "name": "fhirId",
        "type": "text",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "fgkkqdlb",
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
        "id": "zrhyijgx",
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
  const collection = dao.findCollectionByNameOrId("nf52aey6p64t3pk");

  return dao.deleteCollection(collection);
})
