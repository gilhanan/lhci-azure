const { createServer } = require("node:http");
const { createReadStream } = require("node:fs");
const { pipeline } = require("node:stream");

const { PORT = 3000 } = process.env;

const router = {
  "/robots.txt": {
    headers: { "Content-Type": "text/plain" },
    file: "robots.txt",
  },
};

const index = {
  headers: {
    "Content-Type": "text/html",
    "Content-Security-Policy": "default-src 'none'",
  },
  file: "index.html",
};

createServer((request, response) => {
  const { headers, file } = router[request.url] || index;
  response.writeHead(200, headers);
  pipeline(createReadStream(file), response, () => {});
}).listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}/`);
});
