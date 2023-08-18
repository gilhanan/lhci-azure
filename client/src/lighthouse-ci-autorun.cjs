const { readJson, getCurrentProject, getUrls } = require("./utils.cjs");

const CONFIG_PATH = "./config/config-autorun.json";
const TOKENS_PATH = "./config/tokens.json";

function getConfig() {
  const { HOST: host } = process.env;

  if (!host) {
    throw new Error("HOST environment variable is required");
  }

  console.log(`Using host: ${host}`);

  const config = readJson({ path: CONFIG_PATH });
  const tokens = readJson({ path: TOKENS_PATH }); // TODO: process.env

  const {
    common: {
      collect: { numberOfRuns, urlsPaths },
      upload: { serverBaseUrl },
    },
    projects,
  } = config;

  const url = getUrls({ urlsPaths, host });

  if (!url.length) {
    throw new Error("Couldn't generate any URLs from config");
  }

  const currentProject = getCurrentProject({ host, projects });

  if (!currentProject) {
    throw new Error("Couldn't match host to any project");
  }

  const { uploadTokenKey } = currentProject;
  const token = tokens[uploadTokenKey];

  if (!token) {
    throw new Error(`Couldn't find token for ${uploadTokenKey}`);
  }

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
      upload: {
        target: "lhci",
        serverBaseUrl,
        token,
      },
    },
  };

  console.log(JSON.stringify(ciConfig, null, 2));

  return ciConfig;
}

module.exports = getConfig();
