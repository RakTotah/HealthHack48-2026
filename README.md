# Symptom Tracker Application

## Table of Contents

- [Background](#background)
- [Install](#install)
- [Usage](#usage)
- [API](#api)
- [Known Issues](#known-issues)
- [Contributing](#contributing)
- [License](#license)

## Background

JohnKompot is a personal health symptom tracker built for HealthHack48 2026.

Appointments are short, and patients often struggle to remember what happened and when: how bad a headache was, how long it lasted, what came before it. Doctors rely on exactly those details to spot patterns and decide what to investigate. JohnKompot gives patients a simple way to build that record as symptoms happen, so they can bring an accurate history to a consultation instead of relying on memory.

A user logs each symptom with a severity rating, duration and free-text notes. The notes are where the context goes: triggers, what they were doing, anything else they noticed, or whatever else they think a doctor might want to know. Entries can then be reviewed on a calendar by date range or by symptom name, making it easy to see how a symptom changes over time and how often it recurs.

JohnKompot is a tool for recording and reviewing symptoms. It does not diagnose conditions or give medical advice.

The project is split into two parts:

A Spring Boot REST API in Java, persisting to JSON files on disk rather than a database, to keep the setup dependency-free for a hackathon.
A Flutter client in Dart, using Provider for state management and table_calendar for the calendar view.

Storing to flat JSON was a deliberate trade-off: no database to install or configure, at the cost of scalability and crash safety. The repository layer is isolated so it can be swapped for Spring Data JPA later without touching the services above it.



### Backend structure

The backend lives in the `com.john.healthhack482026` package:

| Package      | Contents                                                              |
| ------------ | --------------------------------------------------------------------- |
| `controller` | `LoginController`, `SymptomController`, `GlobalExceptionController`   |
| `service`    | `LoginService`, `SymptomService` (validation and business logic)      |
| `repository` | `LoginInfoRepository`, `SymptomLogRepository` (JSON file persistence) |
| `model`      | `Symptom`, `User`, `Summary` and the request records                  |
| `mapper`     | `RequestMapper` (turns a username/password into an authenticated `User`) |
| `Exceptions` | Custom exceptions mapped to error responses                           |
| `dto`        | `ErrorResponse`                                                       |

## Install

Requirements:

- JDK 21 or later
- Maven (or the bundled `./mvnw` wrapper)
- Flutter SDK 3.x

```sh
git clone <repository-url>
cd <repository>
```

Install the dependencies for each part:

```sh
# Backend
cd <backend-directory>
./mvnw clean install

# Client
cd <client-directory>
flutter pub get
```

## Usage

Start the backend first, then the client.

```sh
# Backend (from <backend-directory>)
./mvnw spring-boot:run

# Client (from <client-directory>)
flutter run
```

The API listens on Spring Boot's default port (`8080`) unless configured
otherwise.

The backend stores its data as JSON files in a `data/` folder relative to the
directory it is run from:

- `./data/logins.json` — registered users
- `./data/symptoms.json` — logged symptoms

Both files are created automatically on first run. Delete them to reset the
app to a clean state.

### Quick example

```sh
# Register a user
curl -X POST http://localhost:8080/register \
  -H "Content-Type: application/json" \
  -d '{"username": "alice", "password": "secret"}'

# Log a symptom (1 hour 30 minutes, severity 6)
curl -X POST http://localhost:8080/symptoms \
  -H "Content-Type: application/json" \
  -d '{"username": "alice", "password": "secret", "name": "Headache",
       "severity": 6, "notes": "After screen time",
       "hourDuration": 1, "minuteDuration": 30}'

# List all of alice's symptoms
curl -X GET http://localhost:8080/symptoms \
  -H "Content-Type: application/json" \
  -d '{"username": "alice", "password": "secret"}'
```

## API

There are no sessions or tokens. Every request carries the user's `username`
and `password`, which are checked on each call. For all endpoints except
`POST /symptoms`, the credentials are sent as a JSON body:

```json
{ "username": "alice", "password": "secret" }
```

### Endpoints

| Method   | Endpoint                | Body                | Description                                  | Success          |
| -------- | ----------------------- | ------------------- | -------------------------------------------- | ---------------- |
| `POST`   | `/register`             | credentials         | Register a new user                          | `201` + user     |
| `GET`    | `/login`                | credentials         | Check a username and password                | `202` + `true`   |
| `GET`    | `/symptoms`             | credentials         | List all symptoms for the user               | `200` + list     |
| `GET`    | `/symptoms/{id}`        | credentials         | Get one symptom by its ID                    | `200` + symptom  |
| `GET`    | `/symptoms/date/{date}` | credentials         | List symptoms for a date                     | `200` + list     |
| `POST`   | `/symptoms`             | symptom + credentials | Log a new symptom                          | `201` + symptom  |
| `DELETE` | `/symptoms/{symptomID}` | credentials         | Delete a symptom                             | `204`            |

### Log a symptom

`POST /symptoms` takes the credentials and the symptom fields in one body:

```json
{
  "username": "alice",
  "password": "secret",
  "name": "Headache",
  "severity": 6,
  "notes": "After screen time",
  "hourDuration": 1,
  "minuteDuration": 30
}
```

Validation rules:

- `name` is required and must not be blank
- `severity` must be between 1 and 10
- `hourDuration` and `minuteDuration` must not be negative
- `minuteDuration` must be 59 or less

### Symptom object

| Field            | Type            | Description                                      |
| ---------------- | --------------- | ------------------------------------------------ |
| `name`           | string          | Name of the symptom                              |
| `severity`       | integer (1–10)  | Severity rating                                  |
| `time`           | ISO-8601 instant | When the symptom was logged (set by the server) |
| `notes`          | string          | Free-text notes                                  |
| `hourDuration`   | integer         | Hours the symptom lasted                         |
| `minuteDuration` | integer         | Minutes the symptom lasted                       |
| `symptomId`      | UUID            | Unique ID of the entry                           |
| `userID`         | UUID            | ID of the user who owns the entry                |

### Errors

Errors are returned as JSON:

```json
{ "code": "INVALID_LOGIN_DETAILS", "message": "Incorrect username or password." }
```

| Code                      | HTTP status | Meaning                                  |
| ------------------------- | ----------- | ---------------------------------------- |
| `INVALID_LOGIN_DETAILS`   | 403         | Wrong username or password               |
| `SYMPTOM_NOT_FOUND`       | 403         | No matching symptom                      |
| `USER_NOT_REGISTERED`     | 404         | Username is not registered               |
| `DUPLICATE_ID_FOUND`      | 404         | Username is already taken                |
| `UNEXPECTED_STORAGE_ERROR`| 500         | A JSON file could not be read or written |
| `UNEXPECTED_ERROR`        | 500         | Any other unhandled error                |

## Known Issues

As this project was made in a day, we did not do any in depth testing and as a result we are not aware of any known issues.

## Contributing

This project was built during a hackathon, so it is rough around the edges.


## License

[MIT](LICENSE) © `Gabriel Kieskiewicz, Owen Black and Rakan Totah`