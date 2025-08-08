# KBTQuickDispatch Rails API

A comprehensive dispatch management system API built with Ruby on Rails 8.0. This API provides authentication, user management, driver management, and vehicle management capabilities for quick dispatch operations.

## Current Status: **Phase 5 - Call Management System Development** 🚀

**Last Updated**: August 8, 2025  
**API Progress**: 80% Complete  
**Current Phase**: Phase 5 - Call Management System (In Progress)

## 🚀 Features

### ✅ Implemented Features
- **JWT Authentication** - Secure user authentication with Devise and JWT tokens
- **Role-based Access Control** - Multiple user roles (user, driver, dispatcher, manager, owner, admin)
- **User Management** - Complete CRUD operations for user profiles and preferences
- **Driver Management** - Comprehensive driver registration and management system
- **Vehicle Management** - Fleet management with vehicle tracking and assignments
- **Call Management System** - Real-time call dispatch and tracking with WebSocket support
- **Shift Management System** - Driver shift scheduling and tracking with real-time updates
- **Location Tracking** - Driver location history and real-time GPS tracking
- **WebSocket Integration** - Action Cable for real-time updates across all core features
- **Chat System** - Real-time messaging functionality
- **RESTful API** - Clean, well-documented API endpoints with versioning
- **Cross-Origin Support** - CORS enabled for frontend integration
- **Data Validation** - Comprehensive backend validation for all entities

### 🚧 In Development
- **Advanced Call Features** - Lineup grouping and GPS address integration
- **Voice Messaging** - Audio message support for chat system
- **Advanced Analytics** - Performance metrics and reporting

### 📋 Planned Features
## 🎯 Project TODO List

### WebSocket Implementation (Action Cable) ✅ **IMPLEMENTED**
- [x] **Calls CRUD** - Real-time call operations via WebSocket ✅
- [x] **Shift CRUD** - Real-time shift operations via WebSocket ✅
- [x] **Driver Location (Req, Rec)** - Driver location requests and reception ✅
- [x] **Message Rooms** - Chat room functionality ✅
	- [ ] **Support Voice Messages (REQUIRED)** - Voice message recording and playback 🚧
		- [ ] **Transcription** - Optional voice-to-text transcription
	- [x] **DM P-2-P** - Person-to-person direct messaging ✅
	- [x] **Dispatchers Chat** - Dispatcher team communication ✅
	- [x] **Drivers Chat** - Driver team communication ✅
	- [x] **Driver Shift Chat** - Shift-specific driver communication ✅

### HTTP API Extensions ✅ **LARGELY IMPLEMENTED**
- [x] **Calls CRUD** - Complete call management API ✅
	- [x] **Call Methods** - Core call-related functionality ✅
		- [ ] Lineup grouping functionality 🚧
		- [ ] GPS integration for addresses 🚧
		- [ ] Automatic distance calculation 🚧
- [x] **Shifts CRUD** - Complete shift management API ✅
- [x] **Shift Methods** - Core shift-related functionality ✅
	- [ ] Till management integration 🚧
	- [ ] Earnings calculation 🚧
	- [ ] Driver performance metrics 🚧
	- [ ] Till management integration
	- [ ] Earnings calculation
	- [ ] Driver performance metrics

### Legacy Planned Features
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

- **User** - Authentication and user profiles ✅
- **Driver** - Driver information and assignments ✅
- **Vehicle** - Fleet vehicle management ✅
- **Call** - Call dispatch and tracking ✅
- **Shift** - Driver shift scheduling ✅
- **LocationHistory** - GPS tracking and location history ✅

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

### Call Management ✅ **IMPLEMENTED**
- `GET /api/v1/calls/get_calls` - List calls with various filters
- `GET /api/v1/calls/get_call/:id` - Get specific call details
- `POST /api/v1/calls/pickup_call/:id` - Mark call as picked up
- `POST /api/v1/calls/dropoff_call/:id` - Mark call as completed
- `POST /api/v1/calls/cancel_call/:id` - Cancel a call
- `POST /api/v1/calls/create_call` - Create new call
- `PUT /api/v1/calls/update_call/:id` - Update call details

### Shift Management ✅ **IMPLEMENTED**
- `GET /api/v1/shifts/get_shifts` - List all shifts
- `GET /api/v1/shifts/get_shift/:id` - Get specific shift details
- `POST /api/v1/shifts/create` - Create new shift
- `PUT /api/v1/shifts/update/:id` - Update shift details

### Real-time WebSocket Channels ✅ **IMPLEMENTED**
- `CallsChannel` - Real-time call updates and operations
- `ShiftsChannel` - Real-time shift updates
- `ChatChannel` - General messaging functionality
- `LocationChannel` - Driver location tracking
- `StatusChannel` - System status updates
- `AuthChannel` - Authentication events

### Vehicle Management ✅ **IMPLEMENTED**
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

#### Phase 5: Call Management System ✅
**Completed**: August 2025 (85% Complete - Core Features)
- [x] **Call CRUD API** - Complete call record management
- [x] **Call Status Management** - Status transitions and lifecycle tracking
- [x] **Real-time Call Updates** - WebSocket integration for live call updates
- [x] **Driver Assignment Logic** - Call assignment and reassignment system
- [x] **Call Broadcasting** - Live updates to dashboard and mobile clients
- [x] **Location History Integration** - Driver location tracking system
- [x] **WebSocket Channels** - Complete Action Cable integration

#### Phase 6: Shift Management System 🚧 
**In Progress**: August 2025 (80% Complete - Core Features)
- [x] **Shift CRUD API** - Complete shift record management
- [x] **Real-time Shift Updates** - WebSocket integration for live shift updates
- [x] **Driver-Shift Association** - Automatic driver assignment to shifts
- [x] **Shift Status Tracking** - Active shift monitoring and history
- [x] **Basic Financial Tracking** - Foundation for earnings and expense tracking

### 🚧 Next Development Phases

#### Phase 5: Call Management System ✅ **LARGELY COMPLETE** (August 2025)
**Priority: Critical** - Core dispatch operations

##### 5.1 Call Data Model & API ✅ **IMPLEMENTED**
- [x] **Call Model** - Database schema for call records ✅
  - Call creation timestamps and status tracking ✅
  - Origin and destination address management ✅
  - Customer information and contact details ✅
  - Fare calculation and payment status tracking ✅
  - Driver assignment and call history ✅
- [x] **Call CRUD Operations** - Complete call lifecycle management ✅
- [x] **Call Status Management** - Status transitions (pickup, in-progress, completed, cancelled) ✅
- [x] **Call Assignment API** - Driver assignment and reassignment logic ✅
- [ ] **Lineup Grouping Feature** - Group related calls for efficient dispatching 🚧
- [ ] **GPS Address Integration** - Link addresses to GPS coordinates 🚧
- [ ] **Auto Distance Calculation** - Automatic distance calculation between locations 🚧

##### 5.2 Real-time Infrastructure ✅ **MOSTLY IMPLEMENTED**
- [x] **Action Cable Setup** - WebSocket integration for real-time updates ✅
- [x] **Call Broadcasting** - Live call status updates to dashboard ✅
- [x] **Driver Location Updates** - Real-time driver position tracking ✅
- [x] **Notification System** - Push notifications for call assignments ✅
- [x] **Message Rooms Implementation** - Complete chat system ✅
	- [ ] **Voice Message Support (REQUIRED)** - Voice recording/playback 🚧
	- [ ] **Message Transcription** - Voice-to-text conversion (optional) 📋
	- [x] **P2P Direct Messaging** - Person-to-person chat ✅
	- [x] **Group Chat Rooms** - Dispatcher, driver, and shift-specific chats ✅

##### 5.3 Call Management Features
- [ ] **Payment Tracking** - Payment status tracking and fare recording (no processing)
- [ ] **Tip Management** - Tip amount tracking and reporting
- [ ] **Call Notes System** - Driver and dispatcher notes
- [ ] **Call History** - Complete call audit trail
- [ ] **Location Services** - Address validation and geocoding integration

#### Phase 6: Shift Management System ✅ **LARGELY COMPLETE** (September 2025)
**Priority: High** - Driver workflow management

##### 6.1 Shift Data Model & API ✅ **IMPLEMENTED**
- [x] **Shift Model** - Database schema for shift tracking ✅
  - Shift start/end timestamps ✅
  - Driver assignment and vehicle allocation ✅
  - Earnings calculation and expense tracking (basic) ✅
  - Till entry management (basic) 🚧
- [x] **Shift CRUD Operations** - Complete shift lifecycle management via WebSocket ✅
- [x] **Active Shift Monitoring** - Real-time shift status tracking ✅
- [x] **Shift History** - Historical shift data and analytics ✅
- [ ] **Advanced Till Integration** - Enhanced cash handling and reconciliation system 🚧

##### 6.2 Earnings & Financial Tracking 🚧 **IN PROGRESS**
- [ ] **Advanced Earnings Tracking** - Enhanced fare and tip amount recording 🚧
- [ ] **Expense Tracking** - Driver expense management 🚧
- [ ] **Till Management** - Advanced cash handling and reconciliation tracking 🚧
- [ ] **Financial Reports** - Shift-based financial summaries 🚧

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
KBTQuickDispatch Rails API v1.5 ✅
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
├── Vehicle Management ✅
│   ├── Fleet inventory
│   ├── Vehicle tracking
│   └── Status management
├── Call Management System ✅ (85% Complete)
│   ├── Call CRUD operations
│   ├── Real-time call updates
│   ├── Status transitions (pickup, dropoff, cancel)
│   └── Driver assignment logic
├── Shift Management System ✅ (80% Complete)
│   ├── Shift tracking
│   ├── Real-time shift updates
│   └── Driver-shift associations
├── Location Tracking System ✅
│   ├── GPS location history
│   ├── Real-time location updates
│   └── Location-based services
└── WebSocket Infrastructure ✅ (90% Complete)
    ├── CallsChannel - Real-time call operations
    ├── ShiftsChannel - Real-time shift updates
    ├── ChatChannel - Messaging system
    ├── LocationChannel - GPS tracking
    ├── StatusChannel - System updates
    └── AuthChannel - Authentication events
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
- **Call Management**: 85% Complete ✅ (Core features implemented, advanced features in progress)
- **Shift Management**: 80% Complete ✅ (Core features implemented, advanced features in progress)
- **WebSocket Integration**: 90% Complete ✅ (All channels implemented, voice messaging pending)
- **Location Tracking**: 100% Complete ✅
- **Real-time Chat System**: 85% Complete ✅ (Basic chat implemented, voice messages pending)
- **Reporting & Analytics**: 0% Complete �
- **Advanced Features**: 10% Complete 🔧

#### Timeline Projections
- **Phase 5 (Call Management)**: August 2025 (4 weeks)
- **Phase 6 (Shift Management)**: September 2025 (4 weeks)
- **Phase 7 (Analytics)**: October 2025 (4 weeks)
- **Phase 8 (Advanced Features)**: November 2025 (4 weeks)
- **Beta Release Target**: December 2025
- **Production Release Target**: January 2026

#### Key Milestones Ahead
- 🎯 **August 2025**: Call management system with lineup grouping
- 🎯 **August 2025**: WebSocket implementation with voice messaging
- 🎯 **September 2025**: Shift tracking with till management
- 🎯 **October 2025**: Full reporting suite
- 🎯 **November 2025**: Advanced features complete
- 🎯 **December 2025**: Beta release
- 🎯 **January 2026**: Production deployment

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

**Roadmap Version**: 2.1  
**Last Updated**: August 8, 2025  
**Next Review**: September 1, 2025
