# KBTQuickDispatch Rails API

A comprehensive dispatch management system API built with Ruby on Rails 8.0. This API provides authentication, user management, driver management, and vehicle management capabilities for quick dispatch operations.

## Current Status: **Phase 4 Complete - Call Management System Development Starting** 🚀

**Last Updated**: July 6, 2025  
**API Progress**: 65% Complete  
**Current Phase**: Phase 5 - Call Management System

## 🚀 Features

### ✅ Implemented Features
- **JWT Authentication** - Secure user authentication with Devise and JWT tokens
- **Role-based Access Control** - Multiple user roles (user, driver, dispatcher, manager, owner, admin)
- **User Management** - Complete CRUD operations for user profiles and preferences
- **Driver Management** - Comprehensive driver registration and management system
- **Vehicle Management** - Fleet management with vehicle tracking and assignments
- **RESTful API** - Clean, well-documented API endpoints with versioning
- **Cross-Origin Support** - CORS enabled for frontend integration
- **Data Validation** - Comprehensive backend validation for all entities

### 🚧 In Development
- **Call Management System** - Real-time call dispatch and tracking
- **WebSocket Integration** - Action Cable for real-time updates
- **Advanced Analytics** - Performance metrics and reporting

### 📋 Planned Features
- **Call Management System** - Real-time call dispatch and tracking
- **Shift Management** - Driver shift scheduling and tracking
- **Payment Tracking** - Payment status and fare tracking (no processing)
- **Reporting Suite** - Comprehensive analytics and KPI tracking
- **Scheduling System** - Advanced driver scheduling and optimization

## 📋 Prerequisites

- **Ruby version**: 3.1.0 or higher
- **Rails version**: 8.0.1
- **Database**: MySQL 5.7+
- **Node.js**: For asset compilation (if needed)

## 🛠 System Dependencies

- **mysql2** - Database adapter
- **devise** - Authentication framework
- **devise-jwt** - JWT token authentication
- **puma** - Web server
- **solid_cache** - Database-backed caching
- **solid_queue** - Database-backed job queuing
- **solid_cable** - Database-backed Action Cable

## ⚙️ Configuration

### Environment Variables

Create a `.env` file in the root directory with the following variables:

```bash
DATABASE_HOST=localhost
DATABASE_PORT=3306
BACKEND_DATABASE_USER=your_db_user
BACKEND_DATABASE_PASSWORD=your_db_password
RAILS_MAX_THREADS=5
```

### Database Configuration

The application uses MySQL as the primary database. Update `config/database.yml` with your database credentials.

## 🚦 Installation & Setup

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd KBTQuickDispatch_RAILS_API
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Database setup**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server**
   ```bash
   rails server
   # or use the provided script
   ./server.sh
   ```

The API will be available at `http://localhost:3000`

## 🏗 Database Schema

### Core Models

- **User** - Authentication and user profiles
- **Driver** - Driver information and assignments
- **Vehicle** - Fleet vehicle management
- **Shift** - Driver shift scheduling

### User Roles

- `user` (0) - Basic user access
- `driver` (1) - Driver-specific functionality
- `dispatcher` (2) - Dispatch operations
- `manager` (4) - Management capabilities
- `owner` (8) - Owner-level access
- `admin` (16) - Full administrative access

## 📡 API Endpoints

### Authentication
- `POST /signup` - User registration
- `POST /login` - User login
- `DELETE /logout` - User logout
- `GET /current_user` - Get current user info

### User Management
- `GET /api/v1/users/getUsers` - List all users
- `PUT /api/v1/users/profile` - Update user profile
- `PUT /api/v1/users/preferences` - Update user preferences
- `PUT /api/v1/users/change_password` - Change password
- `POST /api/v1/users/update_roles` - Update user roles
- `PUT /api/v1/users/update_user/:id` - Update user
- `DELETE /api/v1/users/delete_user/:id` - Delete user

### Driver Management
- `GET /api/v1/drivers/getDrivers` - List all drivers
- `POST /api/v1/drivers/create_driver` - Create new driver
- `PUT /api/v1/drivers/update_driver/:id` - Update driver
- `DELETE /api/v1/drivers/delete_driver/:id` - Delete driver

### Vehicle Management
- `GET /api/v1/vehicles/getVehicles` - List all vehicles
- `POST /api/v1/vehicles/create_vehicle` - Create new vehicle
- `PUT /api/v1/vehicles/update_vehicle/:id` - Update vehicle
- `DELETE /api/v1/vehicles/delete_vehicle/:id` - Delete vehicle

For detailed API documentation, see [API_ENDPOINTS_MAP.md](API_ENDPOINTS_MAP.md)

## 🧪 Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/controllers/users_controller_spec.rb

# Run with coverage
bundle exec rspec --format documentation
```

## 🔍 Code Quality & Security

```bash
# Run security analysis
bundle exec brakeman

# Run code style checks
bundle exec rubocop

# Auto-fix style issues
bundle exec rubocop -a
```

## 🐳 Docker Deployment

The application includes Docker support for easy deployment:

```bash
# Build the image
docker build -t kbt-quickdispatch-api .

# Run the container
docker run -p 3000:3000 kbt-quickdispatch-api
```

## 📊 Services

- **Job Queues**: Solid Queue for background job processing
- **Cache**: Solid Cache for database-backed caching
- **WebSockets**: Solid Cable for real-time features

## 🚀 Deployment

### Using Kamal (included)

```bash
# Setup deployment
kamal setup

# Deploy
kamal deploy
```

### Manual Deployment

1. Set production environment variables
2. Precompile assets: `rails assets:precompile`
3. Run migrations: `rails db:migrate RAILS_ENV=production`
4. Start server with production configuration

## 🤝 Frontend Integration

This API is designed to work with the KBTQuickDispatch React frontend. The CORS configuration allows cross-origin requests from the frontend application.

## 📝 Development Notes

- JWT tokens are used for stateless authentication
- All API endpoints are versioned under `/api/v1/`
- The application follows Rails conventions and best practices
- Database connections are pooled for optimal performance

## 🔧 Troubleshooting

### Common Issues

1. **Database Connection Issues**
   - Check MySQL service is running
   - Verify database credentials in environment variables

2. **JWT Token Issues**
   - Ensure `master.key` is present for credential decryption
   - Check Devise JWT configuration

3. **CORS Issues**
   - Verify CORS configuration in `config/initializers/cors.rb`

## 📚 Additional Resources

- [Rails Guides](https://guides.rubyonrails.org/)
- [Devise Documentation](https://github.com/heartcombo/devise)
- [JWT Devise Documentation](https://github.com/waiting-for-dev/devise-jwt)

## 📄 License

[Add your license information here]

---

**Project Structure**: This is the backend API for the KBTQuickDispatch system, complemented by a React frontend for the user interface.

## 🗺️ Development Roadmap

### Current Status: **Phase 4 Complete - Call Management System Next** 🚀

**Last Updated**: July 6, 2025  
**Current Progress**: 65% Complete

### ✅ Completed Phases

#### Phase 1: API Foundation & Authentication ✅
**Completed**: June 2025
- [x] **JWT Authentication** - Devise-JWT integration with secure token handling
- [x] **User Model** - Role-based access control (user, driver, dispatcher, manager, owner, admin)
- [x] **JSON Serialization** - User serializer for clean API responses
- [x] **Core API Endpoints** - Authentication endpoints (`/login`, `/logout`, `/signup`)
- [x] **CORS Configuration** - Cross-origin requests enabled for React frontend
- [x] **Database Setup** - MySQL integration with proper migrations

#### Phase 2: User Management System ✅
**Completed**: June 2025
- [x] **User Profile API** - Complete CRUD operations for user details
- [x] **User Preferences API** - Settings management including dark mode support
- [x] **Password Management** - Secure password change functionality with validation
- [x] **Role Management** - Admin/manager role assignment capabilities
- [x] **User CRUD Operations** - Full user lifecycle management
- [x] **Profile Data Management** - Personal information and preferences handling

#### Phase 3: Driver Management System ✅
**Completed**: July 2025
- [x] **Driver CRUD API** - Complete driver record management
- [x] **Driver-User Integration** - Automatic role synchronization system
- [x] **Emergency Contacts** - JSON-based contact management system
- [x] **Status Management** - Active/inactive driver tracking
- [x] **Data Validation** - Comprehensive backend validation
- [x] **Role Synchronization** - Automatic driver role assignment to linked users

#### Phase 4: Vehicle Fleet Management ✅
**Completed**: July 2025
- [x] **Vehicle CRUD API** - Complete vehicle inventory management
- [x] **Vehicle Database** - Comprehensive vehicle tracking with unique constraints
- [x] **Status Tracking** - Active/inactive vehicle management
- [x] **Unique Identifiers** - VIN numbers and license plate validation
- [x] **Fleet Operations** - Manager+ access control for fleet management
- [x] **Vehicle Details** - Make, model, year, color, and specifications

### 🚧 Next Development Phases

#### Phase 5: Call Management System (Weeks 1-3, August 2025)
**Priority: Critical** - Core dispatch operations

##### 5.1 Call Data Model & API
- [ ] **Call Model** - Database schema for call records
  - Call creation timestamps and status tracking
  - Origin and destination address management
  - Customer information and contact details
  - Fare calculation and payment status tracking
  - Driver assignment and call history
- [ ] **Call CRUD Operations** - Complete call lifecycle management
- [ ] **Call Status Management** - Status transitions (pending, assigned, in-progress, completed, cancelled)
- [ ] **Call Assignment API** - Driver assignment and reassignment logic

##### 5.2 Real-time Infrastructure
- [ ] **Action Cable Setup** - WebSocket integration for real-time updates
- [ ] **Call Broadcasting** - Live call status updates to dashboard
- [ ] **Driver Location Updates** - Real-time driver position tracking
- [ ] **Notification System** - Push notifications for call assignments

##### 5.3 Call Management Features
- [ ] **Payment Tracking** - Payment status tracking and fare recording (no processing)
- [ ] **Tip Management** - Tip amount tracking and reporting
- [ ] **Call Notes System** - Driver and dispatcher notes
- [ ] **Call History** - Complete call audit trail
- [ ] **Location Services** - Address validation and geocoding integration

#### Phase 6: Shift Management System (Weeks 4-6, August 2025)
**Priority: High** - Driver workflow management

##### 6.1 Shift Data Model & API
- [ ] **Shift Model** - Database schema for shift tracking
  - Shift start/end timestamps
  - Driver assignment and vehicle allocation
  - Earnings calculation and expense tracking
  - Till entry management
- [ ] **Shift CRUD Operations** - Complete shift lifecycle management
- [ ] **Active Shift Monitoring** - Real-time shift status tracking
- [ ] **Shift History** - Historical shift data and analytics

##### 6.2 Earnings & Financial Tracking
- [ ] **Earnings Tracking** - Fare and tip amount recording
- [ ] **Expense Tracking** - Driver expense management
- [ ] **Till Management** - Cash handling and reconciliation tracking
- [ ] **Financial Reports** - Shift-based financial summaries

#### Phase 7: Advanced Analytics & Reporting (Weeks 7-10, September 2025)
**Priority: Medium** - Business intelligence

##### 7.1 Reporting API
- [ ] **KPI Endpoints** - Key performance indicator calculations
- [ ] **Driver Reports** - Individual driver performance metrics
- [ ] **Fleet Reports** - Vehicle utilization and maintenance tracking
- [ ] **Financial Reports** - Revenue, expenses, and profit analysis
- [ ] **Time-based Reports** - Daily, weekly, monthly, yearly aggregations

##### 7.2 Data Analytics
- [ ] **Performance Metrics** - System performance and usage statistics
- [ ] **Trend Analysis** - Historical data trend calculation
- [ ] **Predictive Analytics** - Demand forecasting and optimization
- [ ] **Export Functionality** - CSV, PDF, and Excel export capabilities

#### Phase 8: Scheduling & Advanced Features (Weeks 11-14, October 2025)
**Priority: Medium** - Operational optimization

##### 8.1 Scheduling System
- [ ] **Schedule Model** - Database schema for driver schedules
- [ ] **Weekly Schedule API** - Schedule management endpoints
- [ ] **Driver Availability** - Availability tracking and management
- [ ] **Schedule Templates** - Recurring schedule patterns
- [ ] **Schedule Optimization** - Automatic schedule optimization algorithms

##### 8.2 Advanced Features
- [ ] **Geofencing** - Location-based features and boundaries
- [ ] **Integration APIs** - Third-party service integrations
- [ ] **Backup & Recovery** - Data backup and disaster recovery
- [ ] **Performance Optimization** - Database indexing and query optimization

### 🏗️ Technical Architecture Roadmap

#### Current API Structure (Implemented)
```
KBTQuickDispatch Rails API v1.0
├── Authentication System ✅
│   ├── JWT token management
│   ├── User registration/login
│   └── Role-based access control
├── User Management ✅
│   ├── Profile management
│   ├── Preferences handling
│   └── Role assignment
├── Driver Management ✅
│   ├── Driver CRUD operations
│   ├── Status management
│   └── Emergency contacts
└── Vehicle Management ✅
    ├── Fleet inventory
    ├── Vehicle tracking
    └── Status management
```

#### Planned API Expansion (Phase 5-8)
```
KBTQuickDispatch Rails API v2.0 (Target: October 2025)
├── Call Management System 🚧
│   ├── Call CRUD operations
│   ├── Real-time call updates
│   ├── Driver assignment logic
│   └── Payment status tracking
├── Shift Management System 📋
│   ├── Shift tracking
│   ├── Earnings tracking
│   ├── Till management
│   └── Financial reporting
├── Analytics & Reporting 📊
│   ├── KPI calculations
│   ├── Performance metrics
│   ├── Trend analysis
│   └── Export functionality
└── Advanced Features 🔧
    ├── Scheduling system
    ├── Geofencing
    ├── Third-party integrations
    └── Performance optimization
```

### 📊 Development Metrics & Timeline

#### Current Progress Status
- **Authentication & User Management**: 100% Complete ✅
- **Driver Management**: 100% Complete ✅
- **Vehicle Management**: 100% Complete ✅
- **Call Management**: 0% Complete 🚧
- **Shift Management**: 0% Complete 📋
- **Reporting & Analytics**: 0% Complete 📊
- **Advanced Features**: 0% Complete 🔧

#### Timeline Projections
- **Phase 5 (Call Management)**: August 1-21, 2025 (3 weeks)
- **Phase 6 (Shift Management)**: August 22 - September 11, 2025 (3 weeks)
- **Phase 7 (Analytics)**: September 12 - October 9, 2025 (4 weeks)
- **Phase 8 (Advanced Features)**: October 10 - November 6, 2025 (4 weeks)
- **Beta Release Target**: November 2025
- **Production Release Target**: December 2025

#### Key Milestones Ahead
- 🎯 **August 2025**: Call management system live
- 🎯 **September 2025**: Shift tracking operational
- 🎯 **October 2025**: Full reporting suite
- 🎯 **November 2025**: Advanced features complete
- 🎯 **December 2025**: Production deployment

### 🔧 Technical Debt & Optimization

#### Current Technical Priorities
- [ ] **API Documentation** - Comprehensive OpenAPI/Swagger documentation
- [ ] **Test Coverage** - Expand RSpec test suite to 95%+ coverage
- [ ] **Performance Optimization** - Database query optimization and indexing
- [ ] **Security Audit** - Comprehensive security review and penetration testing
- [ ] **Error Handling** - Standardized error responses and logging
- [ ] **Rate Limiting** - API rate limiting and throttling implementation

#### Future Optimization Goals
- [ ] **Caching Strategy** - Redis integration for improved performance
- [ ] **Background Jobs** - Async processing for heavy operations
- [ ] **Database Scaling** - Read replicas and connection pooling
- [ ] **Monitoring** - Application performance monitoring (APM)
- [ ] **Load Balancing** - Horizontal scaling preparation

### 🤝 Integration Roadmap

#### Frontend Integration Status
- **React Frontend**: 85% API integration complete
- **Mobile App**: 60% API integration complete
- **Real-time Features**: 0% (WebSocket integration pending)

#### Planned External Integrations
- [ ] **Mapping Services** - Google Maps, MapBox integration
- [ ] **SMS/Email Services** - Twilio, SendGrid integration
- [ ] **Push Notifications** - Firebase Cloud Messaging
- [ ] **Analytics Platforms** - Google Analytics, Mixpanel
- [ ] **External Payment Systems** - Integration with third-party payment processors (tracking only)

---

**Roadmap Version**: 2.0  
**Last Updated**: July 6, 2025  
**Next Review**: August 1, 2025
