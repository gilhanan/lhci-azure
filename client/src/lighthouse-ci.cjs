const { readJson } = require("./utils.cjs");

const CONFIG_PATH = "./config/config.json";

function getConfig() {
  const { HOST: host, PATH_QUERY: pathQuery } = process.env;

  if (!host) {
    throw new Error("HOST environment variable is required");
  }

  if (!pathQuery) {
    throw new Error("PATH_QUERY environment variable is required");
  }

  const url = [host + pathQuery];

  const {
    collect: { numberOfRuns },
  } = readJson({ path: CONFIG_PATH });

  const ciConfig = {
    ci: {
      collect: {
        url,
        numberOfRuns,
        settings: {
          chromeFlags: "--no-sandbox --disable-dev-shm-usage",
          configPath: "./src/lighthouse-cli.js",
        },
      },
    },
  };

  console.log(JSON.stringify(ciConfig, null, 2));

  return ciConfig;
}

module.exports = getConfig();
