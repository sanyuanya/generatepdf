**简体中文** | [**English**](./README_EN.md)

## 网页转 PDF 接口文档

该服务提供一个 RESTful API，可将指定网页生成 PDF 文件，并以 Base64 编码的形式返回。

## Docker 部署

```bash
docker run -itd -p 3000:3000 hj212223/generatepdf:latest
```

## 请求方式

- **方法**：`POST`
- **接口地址**：`/generatepdf`

## 请求头

```
Content-Type: application/json
```

## 请求体示例

```json
{
    "url": "https://pkg.go.dev/strings"
}
```

## 成功响应

```json
{
    "message": "ok",
    "code": "success",
    "data": "JVBERi0xLj4..."
}
```

- `message`：成功信息
- `code`：成功状态码，固定为 `"success"`
- `data`：以 Base64 编码的 PDF 文件数据

---

## 异常响应

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

- `message`：异常信息，包含错误类型和描述
- `code`：失败状态码，固定为 `"failure"`
- `data`：失败时为空字符串

---

## 验证失败响应

```json
{
    "type": "validation",
    "on": "body",
    "found": {}
}
```

- `type`：错误类型，表示验证失败
- `on`：表示验证出错的位置，例如 `body`
- `found`：包含错误的详细信息

---

## 示例代码

以下是一个使用 `curl` 命令的示例：

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"url":"https://pkg.go.dev/strings"}' \
  http://localhost:3000/generatepdf
```

返回的 Base64 数据可使用以下命令转换回 PDF 文件：

```bash
echo "JVBERi0xLj4..." | base64 --decode > output.pdf
```
## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=hj21222/generatepdf&type=Timeline)](https://www.star-history.com/#hj21222/generatepdf&Timeline)
