# LeadBreak Backend API

A FastAPI-based backend system for lead management and real-time sales call processing with AI-powered transcript analysis and SIP calling integration.

## 🚀 Features

- **User Authentication & Registration** - JWT-based auth system
- **SIP Calling Integration** - Twilio-powered calling system
- **Real-time Speech Recognition** - VOSK ASR for Hindi and English
- **AI-Powered Lead Analysis** - Google Gemini for transcript processing
- **MongoDB Integration** - Async database operations
- **WebSocket Support** - Real-time audio streaming

## 📋 Table of Contents

- [Installation](#installation)
- [Configuration](#configuration)
- [API Endpoints](#api-endpoints)
- [Architecture](#architecture)
- [Usage](#usage)
- [Environment Variables](#environment-variables)
- [Database Schema](#database-schema)
- [Known Issues](#known-issues)
- [Contributing](#contributing)

## 🛠 Installation

### Prerequisites

- Python 3.8+
- MongoDB
- VOSK Models (Hindi & English)
- Twilio Account
- Google Gemini API Key

### Setup

1. **Clone the repository**
```bash
git clone <repository-url>
cd LeadBreak/backend
```

2. **Install dependencies**
```bash
pip install -r requirements.txt
```

3. **Download VOSK Models**
```bash
# Download required models
wget https://alphacephei.com/vosk/models/vosk-model-en-in-0.5.zip
wget https://alphacephei.com/vosk/models/vosk-model-hi-0.22.zip
# Extract to appropriate directories
```

4. **Setup MongoDB**
```bash
# Start MongoDB service
sudo systemctl start mongod
```

5. **Configure environment variables**
```bash
cp .env.example .env
# Edit .env with your credentials
```

## ⚙️ Configuration

### 1. Environment Variables (.env)
```env
GEMINI_API_KEY=your_gemini_api_key_here
```

### 2. Application Configuration (app.json)
```json
{
    "admininfo": {
        "username": "your_admin_username",
        "password": "your_admin_password"
    },
    "token_details": {
        "secret_key": "your_jwt_secret",
        "sample_code": "HS256",
        "expiry_time": 15
    },
    "Databases": {
        "Appdb": {
            "collections": {
                "usersdata": "UserCollection",
                "sipuserdata": "SIPUserCollection",
                "sipcalldata": "CallsCollection"
            }
        }
    }
}
```

### 3. Twilio Configuration
Update the following in `app/api/sip_calling/endpoints.py`:
```python
account_sid = "your_twilio_account_sid"
auth_token = "your_twilio_auth_token"
twilio_number = "your_twilio_phone_number"
```

## 🔌 API Endpoints

### Authentication Endpoints

#### POST `/register/register`
Register a new user
```json
{
    "username": "john_doe",
    "email": "john@gmail.com",
    "phone_number": 1234567890,
    "password": "secure_password",
    "role": "user"
}
```

#### POST `/register/login`
User login with credentials
```json
{
    "username": "john_doe",
    "password": "secure_password"
}
```

#### GET `/register/protectedtoken`
Validate JWT token (requires Bearer token)

### SIP Calling Endpoints

#### POST `/sip/calling_data`
Initiate a SIP call session
```json
{
    "username": "john_doe",
    "phone_number": 1234567890,
    "requested_phone_number": 9876543210,
    "role": "agent"
}
```

#### GET `/sip/generate_twiml`
Generate TwiML response for Twilio webhook

#### POST `/sip/voip_user_data`
Initiate VOIP call (Form data)
- `username`: User identifier
- `password`: User password
- `number`: User phone number
- `client_number`: Target phone number

#### POST `/sip/get_recording`
Process call recordings and extract insights
- `recording_url`: Twilio recording URL
- `account_sid`: Twilio account SID
- `auth_token`: Twilio auth token
- `call_sid`: Call session ID

## 🏗 Architecture

```
LeadBreak Backend
├── app/
│   ├── main.py                 # FastAPI application entry point
│   ├── api/
│   │   ├── login/              # Authentication endpoints
│   │   └── sip_calling/        # SIP calling endpoints
│   ├── models/                 # Pydantic data models
│   ├── services/               # Business logic services
│   └── utils/                  # Utility functions and ASR servers
├── requirements.txt            # Python dependencies
├── app.json                   # Application configuration
└── .env                       # Environment variables
```

### Key Components

1. **FastAPI Application** (`main.py`)
   - Main application with router inclusions
   - CORS and middleware configuration

2. **Authentication Service** (`services/register_login_service.py`)
   - JWT token generation and validation
   - User registration and login logic
   - MongoDB user management

3. **SIP Calling Service** (`services/sip_server.py`)
   - Twilio integration for call management
   - Recording processing and storage
   - ASR model integration

4. **ASR Servers** (`utils/`)
   - VOSK-based speech recognition
   - Support for Hindi and English
   - WebSocket-based real-time processing

5. **AI Analysis** (`utils/predict_tags.py`)
   - Google Gemini integration
   - Sales call transcript analysis
   - Lead information extraction

## 🚀 Usage

### 1. Start the Application
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

### 2. Start ASR Servers
```bash
# Hindi ASR Server
python3 app/utils/hindi_asr_server.py

# English ASR Server
python3 app/utils/english_asr_server.py
```

### 3. API Documentation
Access interactive API documentation at:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## 💾 Database Schema

### Users Collection
```json
{
    "id": "uuid4_string",
    "username": "string",
    "email": "string",
    "phone_number": "integer",
    "password": "string",
    "role": "string"
}
```

### SIP Calls Collection
```json
{
    "call_id": "uuid4_string",
    "username": "string",
    "phone_number": "integer",
    "requested_phone_number": "integer",
    "role": "string"
}
```

## ⚠️ Known Issues & Technical Debt

### Current Issues
1. **Hardcoded File Paths** - Multiple hardcoded paths need to be configurable
2. **Missing Error Handling** - Incomplete error handling in several endpoints
3. **Authentication Flow** - User validation logic needs improvement
4. **Code Duplication** - Repeated configuration loading across modules
5. **Incomplete Features** - Several placeholder functions need implementation

### Security Concerns
- Hardcoded credentials in code (should use environment variables)
- Missing input validation on some endpoints
- No rate limiting implemented

### Performance Issues
- Synchronous file operations in async contexts
- No connection pooling for external services
- Missing caching mechanisms

## 🔧 Recommended Improvements

1. **Configuration Management**
   - Move all hardcoded paths to environment variables
   - Implement proper configuration management

2. **Error Handling**
   - Add comprehensive error handling
   - Implement proper logging

3. **Code Refactoring**
   - Extract common functionality
   - Implement proper dependency injection
   - Add type hints consistently

4. **Security Enhancements**
   - Implement proper input validation
   - Add rate limiting
   - Secure credential management

5. **Testing**
   - Add unit tests
   - Implement integration tests
   - Add API endpoint testing

## 🔐 Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `GEMINI_API_KEY` | Google Gemini API key for AI analysis | Yes |
| `MONGODB_URL` | MongoDB connection string | No (defaults to localhost) |
| `JWT_SECRET_KEY` | Secret key for JWT tokens | No (uses app.json) |
| `TWILIO_ACCOUNT_SID` | Twilio account identifier | Yes |
| `TWILIO_AUTH_TOKEN` | Twilio authentication token | Yes |
| `VOSK_MODEL_PATH_HI` | Path to Hindi VOSK model | Yes |
| `VOSK_MODEL_PATH_EN` | Path to English VOSK model | Yes |

## 📝 API Response Examples

### Successful Registration
```json
{
    "status_code": 200,
    "message": "User is successfully registered"
}
```

### Successful Login
```json
{
    "StatusCode": 200,
    "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
    "token_type": "bearer"
}
```

### Call Analysis Result
```json
{
    "StatusCode": 200,
    "Transcript": ["transcript lines..."],
    "Entities": {
        "amenities": "garage, swimming pool",
        "budget": "6 crores",
        "location": "Delhi, Noida, Gurgaon",
        "property_type": "residential",
        "size": "2 BHK, 500 sq ft"
    }
}
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Implement changes with proper error handling
4. Add tests for new functionality
5. Update documentation
6. Submit a pull request

## 📞 Support

For technical support or questions:
- Create an issue in the repository
- Contact the development team

---

**Note**: This is a development version with known technical debt. Please review the [Known Issues](#known-issues) section before deployment to production.
