# API Reference

## Configuration

| Environment | Base URL |
|---|---|
| **Test** | `https://testcityzenapi.csn.edu.pk/api/` |
| **Production** | `https://cityzenapi.csn.edu.pk/api/` |

Currently active: **Test** (configured in `lib/utils/app_constants.dart`)

## Common Headers

```json
{
  "Content-Type": "application/json; charset=UTF-8",
  "Accept": "application/json",
  "Authorization": "Bearer <tokenId>"
}
```

## HTTP Client

All requests go through `ApiBaseHelper` (`lib/network/api_base_helper.dart`).

### Error Handling

| HTTP Status | Exception Type |
|---|---|
| 200 | Success (return JSON) |
| 400 | `BadRequestException` |
| 401 | `InvalidInputException` |
| 403 | `UnAuthorizedException` |
| 404 | `FetchDataException` |
| 500+ | `FetchDataException` |

### Network Errors

| Error | Exception |
|---|---|
| `SocketException` | "No Internet Connection..." |
| `FormatException` | "Bad Response Format" |
| `TimeoutException` | "Slow Internet, Please Try Again" |

## Known Endpoints

> **Note**: Add endpoints here as you discover them from logs and service files.

### Authentication

| Endpoint | Method | Body | Response |
|---|---|---|---|
| Login | POST | `{username, password, userType}` | `LoginResponse` |
| Logout | POST | `{tokenId}` | `ResponseMessage` |

### Attendance

| Endpoint | Method | Body | Response |
|---|---|---|---|
| `GetSubjectsByStudentId` | POST | `{"id":"230935","isDairy":false}` | `{subjectsDtos: [...]}` |
| `GetMonthlyAttendance` | POST | `{"StudentId":"230935","SubjectId":165,"TokenId":"...","PMonth":"202605"}` | `{MonthlyAttandanceDto: [...]}` |

### Add more endpoints as discovered

*Use `[log]` debug output in the console to capture endpoint URLs, request bodies, and response shapes.*

## Service Layer Pattern

Each service is a static class:

```dart
class SomeService {
  static Future<SomeResponse> someRequest({
    required String param1,
    required int param2,
  }) async {
    Map<String, dynamic> response = await ApiBaseHelper.httpPostRequest(
      'EndpointName',
      body: {'Param1': param1, 'Param2': param2},
    );
    return SomeResponse.fromJson(response);
  }
}
```

## Related Pages

- [[Architecture/Index|Architecture Overview]]
- [[Architecture/Provider Map|Provider Map]]
