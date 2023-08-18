const { readFileSync } = require("fs");

function getDashedHost({ host }) {
  return host.replace("https://", "").replace(/\./g, "-");
}

function urlFrom({ host, pathname = "", params = {} } = {}) {
  const search = new URLSearchParams(params).toString();

  return Object.assign(new URL(host), {
    pathname,
    search,
  }).toString();
}

function readJson({ path }) {
  return JSON.parse(readFileSync(path));
}

function getCurrentProject({ host, projects }) {
  return projects.find(({ hostPattern }) => host.match(hostPattern)?.length);
}

function getUrls({ urlsPaths, host }) {
  return urlsPaths.map(({ pathname, params }) =>
    urlFrom({ host, pathname, params })
  );
}

module.exports = {
  readJson,
  getCurrentProject,
  getDashedHost,
  getUrls,
};
