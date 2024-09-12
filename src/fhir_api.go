package main

import (
	"encoding/json"
	"net/http"

	"github.com/labstack/echo/v5"
	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/models"
	"github.com/pocketbase/pocketbase/tools/types"
)

// Fetch a FHIR resource by ID
func getFHIRResource(c echo.Context, app *pocketbase.PocketBase) error {
	resourceType := c.PathParam("resourceType") // e.g., "Patient"
	id := c.PathParam("id")

	// Find the collection by resource type
	collection, err := app.Dao().FindCollectionByNameOrId(resourceType)
	if err != nil {
		return c.JSON(http.StatusNotFound, map[string]string{"error": "Collection not found"})
	}

	// Fetch the resource by ID
	resource, err := app.Dao().FindRecordById(collection.Id, id)
	if err != nil {
		return c.JSON(http.StatusNotFound, map[string]string{"error": "Resource not found"})
	}

	// Return the fetched resource
	return c.JSON(http.StatusOK, map[string]interface{}{
		"id":       resource.Id,
		"resource": resource.Get("resource"),
	})
}

// Create or update a FHIR resource
func createOrUpdateFHIRResource(c echo.Context, app *pocketbase.PocketBase) error {
	resourceType := c.PathParam("resourceType") // e.g., "Patient"

	// Parse the request body (FHIR resource)
	var resourceData map[string]interface{}
	if err := c.Bind(&resourceData); err != nil {
		return c.JSON(http.StatusBadRequest, map[string]string{"error": "Invalid JSON data"})
	}

	// Get the collection by resource type
	collection, err := app.Dao().FindCollectionByNameOrId(resourceType)
	if err != nil {
		return c.JSON(http.StatusNotFound, map[string]string{"error": "Collection not found"})
	}

	// Check if resource ID is provided in the request body for an update
	id, ok := resourceData["id"].(string)
	var record *models.Record

	if ok && id != "" {
		// Update existing record
		record, err = app.Dao().FindRecordById(collection.Id, id)
		if err != nil {
			return c.JSON(http.StatusNotFound, map[string]string{"error": "Resource not found"})
		}
	} else {
		// Create a new record
		record = models.NewRecord(collection)
	}

	// Set the resource data
	resourceJSON, err := json.Marshal(resourceData)
	if err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": "Failed to process resource data"})
	}
	record.Set("resource", types.JsonRaw(resourceJSON))

	// Save the record
	if err := app.Dao().SaveRecord(record); err != nil {
		return c.JSON(http.StatusInternalServerError, map[string]string{"error": "Failed to save resource"})
	}

	// Return the created or updated resource
	return c.JSON(http.StatusOK, map[string]interface{}{
		"id":       record.Id,
		"resource": record.Get("resource"),
	})
}

func registerFHIRRoutes(app *pocketbase.PocketBase) {
	app.OnBeforeServe().Add(func(e *core.ServeEvent) error {
		e.Router.GET("/api/fhir/:resourceType/:id", func(c echo.Context) error {
			return getFHIRResource(c, app)
		})

		e.Router.POST("/api/fhir/:resourceType", func(c echo.Context) error {
			return createOrUpdateFHIRResource(c, app)
		})

		return nil
	})
}
