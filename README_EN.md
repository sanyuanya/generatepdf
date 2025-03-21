**English** | [**简体中文**](./README.md)
# Generate PDF API Documentation

## Overview
This API allows you to generate a PDF file from a given webpage URL. The response will contain a Base64-encoded PDF file.

## Deployment
To deploy the service using Docker, run the following command:

```bash
docker run -itd -p 3000:3000 hj212223/generatepdf:latest
```

## Endpoint
- **Method:** `POST`
- **URL:** `/generatepdf`

## Headers
```http
Content-Type: application/json
```

## Request Body
```json
{
    "url": "https://pkg.go.dev/strings"
}
```

### Parameters
| Parameter | Type   | Required | Description                        |
|------------|--------|-----------|------------------------------------|
| `url`        | string | Yes         | The URL of the webpage to generate as a PDF. |

## Success Response
```json
{
    "message": "ok",
    "code": "success",
    "data": "JVBERi0xLj4..."
}
```

### Success Response Details
| Field     | Type   | Description                             |
|------------|--------|-----------------------------------------|
| `message`  | string | Confirmation message (`ok`).            |
| `code`     | string | Success code (`success`).                |
| `data`     | string | Base64-encoded string of the generated PDF file. |

## Error Responses

### Invalid URL Error
```json
{
    "message": {
        "name": "ProtocolError",
        "message": "Protocol error (Page.navigate): Cannot navigate to invalid URL"
    },
    "code": "failure",
    "data": ""
}
```

### Validation Error
```json
{
    "type": "validation",
    "on": "body",
    "found": {}
}
```

### Error Response Details
| Field       | Type   | Description                                            |
|--------------|--------|--------------------------------------------------------|
| `message`     | object | Error details, including error type and message.       |
| `code`        | string | Failure code (`failure`).                              |
| `data`        | string | Empty string (no PDF data is returned).                 |
| `type`        | string | Error type (e.g., `validation`).                        |
| `on`          | string | Where the error occurred (e.g., `body`).                 |
| `found`       | object | Contains details about the validation failure.            |

## Example Usage
### cURL Request
```bash
curl -X POST -H "Content-Type: application/json" -d '{"url":"https://pkg.go.dev/strings"}' http://localhost:3000/generatepdf
```

### Sample Code (Python)
```python
import requests
import base64

url = "http://localhost:3000/generatepdf"
headers = {"Content-Type": "application/json"}

data = {"url": "https://pkg.go.dev/strings"}
response = requests.post(url, json=data, headers=headers)

if response.status_code == 200:
    pdf_data = response.json().get("data", "")
    with open("output.pdf", "wb") as f:
        f.write(base64.b64decode(pdf_data))
    print("PDF generated successfully.")
else:
    print("Error:", response.json())
```

## Notes
- Ensure the URL provided is valid and accessible.
- Handle Base64 decoding carefully to ensure the generated PDF file is correctly saved.

