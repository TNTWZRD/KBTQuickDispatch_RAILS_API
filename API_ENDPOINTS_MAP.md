# QuickDispatch API Endpoints Map

## Table of Contents
1. [Base URL](#base-url)
2. [Authentication Endpoints](#authentication-endpoints-devise)
3. [Current User Endpoints](#current-user-endpoints)
4. [API v1 Endpoints](#api-v1-endpoints)
5. [User Management Endpoints](#user-management-endpoints)
6. [Driver Management Endpoints](#driver-management-endpoints)
7. [Vehicle Management Endpoints](#vehicle-management-endpoints)
8. [Data Validation & Requirements](#data-validation--requirements)
9. [Role Permissions](#role-permissions)
10. [Error Responses](#error-responses)
11. [Quick Reference](#quick-reference)
12. [Notes](#notes)
13. [Route Map](#route-map)

## Base URL
- Development: `http://localhost:3000` (or your configured Rails server)
- Production: `[Your production URL]`

---

## Authentication Endpoints (Devise)

### User Registration
- **POST** `/signup`
  - **Description**: Register a new user
  - **Controller**: `Users::RegistrationsController#create`
  - **Request Body**: 
    ```json
    {
      "user": {
        "email": "string",
        "password": "string",
        "password_confirmation": "string",
        "name": "string",
        "username": "string",
        "phone_number": "string"
      }
    }
    ```
  - **Response**: User data with status message

### User Login
- **POST** `/login`
  - **Description**: User login/authentication
  - **Controller**: `Users::SessionsController#create`
  - **Request Body**:
    ```json
    {
      "user": {
        "login": "string",
        "password": "string"
      }
    }
    ```
  - **Response**: User data with authentication token

### User Logout
- **DELETE** `/logout`
  - **Description**: User logout
  - **Controller**: `Users::SessionsController#destroy`
  - **Authentication**: Required
  - **Response**: Logout confirmation message

### User Account Deletion
- **DELETE** `/signup`
  - **Description**: Delete user account
  - **Controller**: `Users::RegistrationsController#destroy`
  - **Authentication**: Required
  - **Response**: Account deletion confirmation

---

## Current User Endpoints

### Get Current User
- **GET** `/current_user`
  - **Description**: Get current authenticated user information
  - **Controller**: `CurrentUserController#index`
  - **Authentication**: Required
  - **Response**: Current user data

---

## API v1 Endpoints

### System Status
- **GET** `/api/v1/status`
  - **Description**: Check API status
  - **Controller**: `Api::V1::BaseController#status`
  - **Authentication**: Not required
  - **Response**: 
    ```json
    {
      "status": 200,
      "message": "API Online"
    }
    ```

---

## User Management Endpoints

### Get All Users
- **GET** `/api/v1/users/getUsers`
  - **Description**: Get list of all users
  - **Controller**: `Api::V1::UsersController#getUsers`
  - **Authentication**: Required
  - **Authorization**: Dispatcher, Manager, Owner, or Admin roles
  - **Response**: Array of user objects with selected fields

### Update User Profile
- **PUT** `/api/v1/users/profile`
  - **Description**: Update current user's profile information
  - **Controller**: `Api::V1::UsersController#update_profile`
  - **Authentication**: Required
  - **Request Body**:
    ```json
    {
      "user": {
        "name": "string",
        "email": "string",
        "username": "string",
        "phone_number": "string"
      }
    }
    ```
  - **Response**: Updated user data with status

### Update User Preferences
- **PUT** `/api/v1/users/preferences`
  - **Description**: Update user preferences (e.g., dark mode)
  - **Controller**: `Api::V1::UsersController#update_preferences`
  - **Authentication**: Required
  - **Request Body**:
    ```json
    {
      "user": {
        "darkmode": boolean
      }
    }
    ```
  - **Response**: Updated user data with status

### Change Password
- **PUT** `/api/v1/users/change_password`
  - **Description**: Change user password
  - **Controller**: `Api::V1::UsersController#change_password`
  - **Authentication**: Required
  - **Request Body**:
    ```json
    {
      "user": {
        "current_password": "string",
        "password": "string",
        "password_confirmation": "string"
      }
    }
    ```
  - **Response**: Password change confirmation

### Update User Roles
- **POST** `/api/v1/users/update_roles`
  - **Description**: Update user roles/permissions
  - **Controller**: `Api::V1::UsersController#update_roles`
  - **Authentication**: Required
  - **Authorization**: Role-based (higher roles can modify lower roles)
  - **Request Body**: 
    ```json
    ["user_id", "role_value"]
    ```
  - **Response**: Updated user data with new role
  - **Notes**: 
    - Role values: 1=Driver, 2=Dispatcher, 4=Manager, 8=Owner, 16=Admin
    - Roles can be combined (bitwise)

### Update User (Admin)
- **PUT** `/api/v1/users/update_user/:id`
  - **Description**: Update any user's information (admin function)
  - **Controller**: `Api::V1::UsersController#update_user`
  - **Authentication**: Required
  - **Authorization**: Manager, Owner, or Admin roles
  - **Request Body**:
    ```json
    {
      "user": {
        "name": "string",
        "email": "string",
        "username": "string",
        "phone_number": "string",
        "darkmode": boolean,
        "role": "number"
      }
    }
    ```
  - **Response**: Updated user data

### Delete User (Admin)
- **DELETE** `/api/v1/users/delete_user/:id`
  - **Description**: Delete any user account (admin function)
  - **Controller**: `Api::V1::UsersController#delete_user`
  - **Authentication**: Required
  - **Authorization**: Manager, Owner, or Admin roles
  - **Response**: User deletion confirmation

---

## Driver Management Endpoints

### Get All Drivers
- **GET** `/api/v1/drivers/getDrivers`
  - **Description**: Get list of all drivers
  - **Controller**: `Api::V1::DriversController#getDrivers`
  - **Authentication**: Required
  - **Authorization**: Dispatcher, Manager, Owner, or Admin roles
  - **Response**: Array of driver objects with selected fields (id, name, phone_number, user_id, status, emergency_contact_names, emergency_contact_numbers)

### Create Driver
- **POST** `/api/v1/drivers/create_driver`
  - **Description**: Create a new driver
  - **Controller**: `Api::V1::DriversController#create_driver`
  - **Authentication**: Required
  - **Authorization**: Manager, Owner, or Admin roles
  - **Request Body**:
    ```json
    {
      "driver": {
        "name": "string",
        "phone_number": "string",
        "emergency_contact_names": ["string"],
        "emergency_contact_numbers": ["string"]
      }
    }
    ```
  - **Response**: Created driver data with status
  - **Notes**: Driver status defaults to active (1)

### Update Driver
- **PUT** `/api/v1/drivers/update_driver/:id`
  - **Description**: Update an existing driver's information
  - **Controller**: `Api::V1::DriversController#update_driver`
  - **Authentication**: Required
  - **Authorization**: Manager, Owner, or Admin roles
  - **Request Body**:
    ```json
    {
      "driver": {
        "name": "string",
        "phone_number": "string",
        "status": "number",
        "emergency_contact_names": ["string"],
        "emergency_contact_numbers": ["string"]
      }
    }
    ```
  - **Response**: Updated driver data with status
  - **Notes**: 
    - Status 0 = inactive, 1 = active
    - Updating status also updates associated user's driver role

### Delete Driver
- **DELETE** `/api/v1/drivers/delete_driver/:id`
  - **Description**: Delete a driver (only if no associated user account)
  - **Controller**: `Api::V1::DriversController#delete_driver`
  - **Authentication**: Required
  - **Authorization**: Manager, Owner, or Admin roles
  - **Response**: Driver deletion confirmation
  - **Notes**: Cannot delete drivers with associated user accounts

---

## Vehicle Management Endpoints

### Get All Vehicles
- **GET** `/api/v1/vehicles/getVehicles`
  - **Description**: Get list of all vehicles
  - **Controller**: `Api::V1::VehiclesController#getVehicles`
  - **Authentication**: Required
  - **Authorization**: Dispatcher, Manager, Owner, or Admin roles
  - **Response**: Array of vehicle objects with all fields

### Create Vehicle
- **POST** `/api/v1/vehicles/create_vehicle`
  - **Description**: Create a new vehicle
  - **Controller**: `Api::V1::VehiclesController#create_vehicle`
  - **Authentication**: Required
  - **Authorization**: Manager, Owner, or Admin roles
  - **Request Body**:
    ```json
    {
      "vehicle": {
        "nickname": "string",
        "vin_number": "string",
        "license_plate": "string",
        "make": "string",
        "model": "string",
        "year": "string",
        "color": "string",
        "description": "string",
        "short_notes": "string",
        "status": "number"
      }
    }
    ```
  - **Response**: Created vehicle data with status
  - **Notes**: Vehicle status defaults to active (1)

### Update Vehicle
- **PUT** `/api/v1/vehicles/update_vehicle/:id`
  - **Description**: Update an existing vehicle's information
  - **Controller**: `Api::V1::VehiclesController#update_vehicle`
  - **Authentication**: Required
  - **Authorization**: Manager, Owner, or Admin roles
  - **Request Body**:
    ```json
    {
      "vehicle": {
        "nickname": "string",
        "vin_number": "string",
        "license_plate": "string",
        "make": "string",
        "model": "string",
        "year": "string",
        "color": "string",
        "description": "string",
        "short_notes": "string",
        "status": "number"
      }
    }
    ```
  - **Response**: Updated vehicle data with status

### Delete Vehicle
- **DELETE** `/api/v1/vehicles/delete_vehicle/:id`
  - **Description**: Delete a vehicle
  - **Controller**: `Api::V1::VehiclesController#delete_vehicle`
  - **Authentication**: Required
  - **Authorization**: Manager, Owner, or Admin roles
  - **Response**: Vehicle deletion confirmation

---

## Data Validation & Requirements

### User Model Validations:
- **username**: Required, unique (case-insensitive)
- **email**: Required, unique (case-insensitive)
- **phone_number**: Optional, unique (case-insensitive) if provided
- **password**: Required for registration, minimum length based on Devise settings

### Driver Model Validations:
- **name**: Optional, unique (case-insensitive) if provided
- **phone_number**: Optional, unique (case-insensitive) if provided
- **user_id**: Optional, unique if provided
- **emergency_contact_names**: Array of strings, stored as JSON
- **emergency_contact_numbers**: Array of strings, stored as JSON
- **status**: Integer (0 = inactive, 1 = active)

### Vehicle Model Validations:
- **nickname**: Required, unique (case-insensitive)
- **vin_number**: Optional, unique (case-insensitive) if provided
- **license_plate**: Optional, unique (case-insensitive) if provided
- **make**: Required
- **model**: Required
- **year**: Required
- **color**: Optional
- **description**: Optional
- **short_notes**: Optional
- **status**: Integer (0 = inactive, 1 = active, defaults to 1)

### Authentication Notes:
- Login can be either username or email
- JWT tokens are used for authentication
- JTI (JWT ID) is stored for token revocation

---

## Role Permissions

### Role Hierarchy (Bitwise values):
- **Driver (1)**: Basic driver access
- **Dispatcher (2)**: Can view users and drivers
- **Manager (4)**: Can modify users and roles (up to manager level)
- **Owner (8)**: Can modify roles up to owner level
- **Admin (16)**: Full system access

### Endpoint Access by Role:
- **Driver**: Profile management only
- **Dispatcher+**: Can view users, drivers, and vehicles lists
- **Manager+**: Can create, update, and delete users, drivers, and vehicles (limited by hierarchy)
- **Owner+**: Extended role management capabilities
- **Admin**: Full system access

---

## Error Responses

### Common HTTP Status Codes:
- **200**: OK - Request successful
- **401**: Unauthorized - Authentication required or invalid
- **403**: Forbidden - Insufficient permissions
- **404**: Not Found - Resource doesn't exist
- **422**: Unprocessable Entity - Validation errors
- **500**: Internal Server Error

### Standard Error Response Format:
```json
{
  "status": "error",
  "message": "Error description",
  "errors": ["Detailed error messages"]
}
```

---

## Quick Reference

### Authentication Headers:
```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

### Common Query Parameters:
- Most endpoints don't require query parameters
- ID parameters are passed in the URL path (e.g., `/api/v1/users/update_user/123`)

### Driver Status Codes:
- `0`: Inactive
- `1`: Active (default for new drivers)

### Vehicle Status Codes:
- `0`: Inactive
- `1`: Active (default for new vehicles)

### Emergency Contacts:
- Stored as JSON arrays in the database
- `emergency_contact_names` and `emergency_contact_numbers` should have matching indices
- Example: `["John Doe", "Jane Smith"]` and `["555-0123", "555-0456"]`

---

## Notes

1. All API endpoints except `/api/v1/status` require authentication
2. Role-based authorization is implemented for sensitive operations
3. The system uses Devise for authentication with JWT tokens
4. Driver records are automatically created/updated when user roles change to include driver permissions
5. Passwords are handled securely with validation for current password verification
6. All timestamps and user data follow Rails conventions
7. Emergency contacts are stored as JSON arrays and should be provided as arrays in API requests
8. Driver status updates automatically sync with associated user role permissions
9. Drivers with associated user accounts cannot be deleted directly - delete the user account instead
10. User login accepts either username or email address
11. Vehicle nicknames must be unique across the system for easy identification
12. VIN numbers and license plates are automatically validated for uniqueness when provided
13. Vehicle status updates affect availability for dispatch operations

---

## Route Map

```
QuickDispatch API Routes
├── Authentication (Devise)
│   ├── POST   /signup                     │ Register new user
│   ├── POST   /login                      │ User login
│   ├── DELETE /logout                     │ User logout
│   └── DELETE /signup                     │ Delete account
│
├── Current User
│   └── GET    /current_user               │ Get current user info
│
├── API v1 (/api/v1)
│   ├── GET    /status                     │ Check API status
│   │
│   ├── Users (/users)
│   │   ├── GET    /getUsers               │ List all users
│   │   ├── PUT    /profile                │ Update profile
│   │   ├── PUT    /preferences            │ Update preferences
│   │   ├── PUT    /change_password        │ Change password
│   │   ├── POST   /update_roles           │ Update user roles
│   │   ├── PUT    /update_user/:id        │ Update user (admin)
│   │   └── DELETE /delete_user/:id        │ Delete user (admin)
│   │
│   ├── Drivers (/drivers)
│   │   ├── GET    /getDrivers             │ List all drivers
│   │   ├── POST   /create_driver          │ Create new driver
│   │   ├── PUT    /update_driver/:id      │ Update driver
│   │   └── DELETE /delete_driver/:id      │ Delete driver
│   │
│   └── Vehicles (/vehicles)
│       ├── GET    /getVehicles            │ List all vehicles
│       ├── POST   /create_vehicle         │ Create new vehicle
│       ├── PUT    /update_vehicle/:id     │ Update vehicle
│       └── DELETE /delete_vehicle/:id     │ Delete vehicle
```

### Authorization Matrix

| Endpoint Category | Driver | Dispatcher | Manager | Owner | Admin |
|------------------|--------|------------|---------|-------|-------|
| Authentication   | ✅     | ✅         | ✅      | ✅    | ✅    |
| Profile Mgmt     | ✅     | ✅         | ✅      | ✅    | ✅    |
| View Users       | ❌     | ✅         | ✅      | ✅    | ✅    |
| View Drivers     | ❌     | ✅         | ✅      | ✅    | ✅    |
| View Vehicles    | ❌     | ✅         | ✅      | ✅    | ✅    |
| Manage Users     | ❌     | ❌         | ✅      | ✅    | ✅    |
| Manage Drivers   | ❌     | ❌         | ✅      | ✅    | ✅    |
| Manage Vehicles  | ❌     | ❌         | ✅      | ✅    | ✅    |
| Role Management  | ❌     | ❌         | ✅*     | ✅*   | ✅    |

*Limited by role hierarchy - can only modify roles at or below their level

### HTTP Methods Summary

| Method | Purpose              | Example                    |
|--------|---------------------|----------------------------|
| GET    | Retrieve data       | GET /api/v1/users/getUsers |
| POST   | Create new resource | POST /api/v1/drivers/create_driver |
| PUT    | Update resource     | PUT /api/v1/vehicles/update_vehicle/123 |
| DELETE | Remove resource     | DELETE /api/v1/users/delete_user/456 |
