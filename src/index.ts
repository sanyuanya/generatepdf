import { Elysia,t} from "elysia";
import puppeteer from "puppeteer";

const app = new Elysia().onError(({ code, error }) => {

  if (code === "VALIDATION") {
    return {message: JSON.stringify(error), code: "vaildation", data: ""}
  }

}).post("/generatepdf", async ({body}) => {

  const browser = await puppeteer.launch({
    args: [
      "--ignore-certificate-errors",
      "--disable-web-security", // 仅用于调试，不建议在生产环境中使用
      "--allow-insecure-localhost",
      "--no-sandbox", 
      "--disable-setuid-sandbox",
    ],
  });
  const page = await browser.newPage();

  try {
    await page.goto(body.url, {
      waitUntil: "networkidle2",
    });

    const pdfUint8Array = await page.pdf({
      format: "A4",
      scale: 0.5,
      printBackground: true,
      margin: { top: 50, left: 40, right: 40,},
    });

    const screenshotbase64 = page.screenshot({
      encoding: "base64"
    });

    return {
      message: "ok", 
      code : "success", 
      data: screenshotbase64,
      // data: Buffer.from(pdfUint8Array).toString("base64"),
    }
  } catch (error) {
    return { 
      message: JSON.stringify(error), code: "failure", data: "",
    }
  } finally {
    if (browser) {
      await browser.close();
    }
  }
}, {
  body: t.Object({
    url:t.String({
      error: "需要一个URL地址"
    }),
  })
})
//.listen(3000);

export default app.fetch;

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
