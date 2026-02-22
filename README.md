# Social Restaurant Booking API

REST API for finding restaurants that fit a group's dietary restrictions and creating reservations.

## Requirements

- Ruby 3.2.2
- PostgreSQL
- Rails 8.1

## Setup

```bash
bin/setup
bin/rails db:seed
```

## Run

```bash
bin/rails server
```

## Tests

```bash
bin/rails test
```

## API Endpoints

### Search available restaurants

```
GET /api/v1/restaurants/search
```

Finds restaurants with an available table for a group of diners at a specific time, matching all dietary restrictions.

**Parameters:**

| Param | Type | Description |
|---|---|---|
| `diner_ids[]` | array of integers | IDs of the diners in the group |
| `reservation_time` | string (ISO 8601) | Desired reservation time |

**Example:**

```
GET /api/v1/restaurants/search?diner_ids[]=1&diner_ids[]=2&diner_ids[]=3&reservation_time=2026-02-24T19:30:00Z
```

**Response 200:**

```json
{
  "data": [
    {
      "id": "1",
      "type": "restaurant",
      "attributes": {
        "name": "Green Garden",
        "endorsements": ["Vegan-friendly", "Vegetarian-friendly"]
      },
      "relationships": {
        "available_tables": {
          "data": [{ "id": "2", "type": "table" }]
        }
      }
    }
  ],
  "included": [
    { "id": "2", "type": "table", "attributes": { "capacity": 4 } }
  ]
}
```

### Create a reservation

```
POST /api/v1/reservations
```

Creates a reservation for a group of diners at a specific table and time. Reservations last 2 hours.

**Body (JSON):**

| Field | Type | Description |
|---|---|---|
| `table_id` | integer | ID of the table to reserve |
| `diner_ids` | array of integers | IDs of the diners |
| `reservation_time` | string (ISO 8601) | Reservation start time |

**Example:**

```json
{
  "table_id": 2,
  "diner_ids": [1, 2, 3],
  "reservation_time": "2026-02-24T19:30:00Z"
}
```

**Response 201:**

```json
{
  "data": {
    "id": "1",
    "type": "reservation",
    "attributes": {
      "reservation_time": "2026-02-24T19:30:00Z"
    },
    "relationships": {
      "table": { "data": { "id": "2", "type": "table" } },
      "diners": {
        "data": [
          { "id": "1", "type": "diner" },
          { "id": "2", "type": "diner" }
        ]
      }
    }
  },
  "included": [
    { "id": "2", "type": "table", "attributes": { "capacity": 4 } },
    { "id": "1", "type": "diner", "attributes": { "name": "Jack" } },
    { "id": "2", "type": "diner", "attributes": { "name": "Jill" } }
  ]
}
```

## Postman

Import `postman_collection.json` from the project root to test the API with pre-built requests.
