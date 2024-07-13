/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "k3tyw6y8sy07xsd",
    "created": "2024-07-13 05:52:46.410Z",
    "updated": "2024-07-13 05:52:46.410Z",
    "name": "evidencereport",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "99vnegke",
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
        "id": "r21unetf",
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
  const collection = dao.findCollectionByNameOrId("k3tyw6y8sy07xsd");

  return dao.deleteCollection(collection);
})
