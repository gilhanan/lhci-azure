import * as LH from "lighthouse";

const auditRefs = [
  { id: "page-load-time-response-start", weight: 0.25 },
  { id: "page-load-time-response-end", weight: 0.25 },
  { id: "page-load-time-assets-loaded", weight: 0.25 },
  { id: "page-load-time-app-rendered", weight: 0.25 },
];

/** @type {LH.Config} */
const config = {
  extends: "lighthouse:default",
  settings: {
    formFactor: "desktop",
    onlyAudits: auditRefs.map(({ id }) => id),
    onlyCategories: ["performance", "pageLoadTime"],
    throttlingMethod: "devtools",
    throttling: {
      requestLatencyMs: 150,
      downloadThroughputKbps: 5000,
      uploadThroughputKbps: 5000,
      cpuSlowdownMultiplier: 0,
    },
    screenEmulation: {
      width: 1366,
      height: 768,
      deviceScaleFactor: 1,
      mobile: false,
      disabled: false,
    },
  },
  artifacts: [
    { id: "PageLoadTime", gatherer: "./page-load-time/page-load-time" },
  ],
  audits: auditRefs.map(({ id }) => `./page-load-time/audits/${id}`),
  categories: {
    pageLoadTime: {
      title: "Page Load Time",
      description: "Drilled-down page load time metrics",
      auditRefs,
    },
  },
};

export default config;
