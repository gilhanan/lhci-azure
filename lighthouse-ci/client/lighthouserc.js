const { URL, LHCI_SERVER, LHCI_TOKEN } = process.env;

module.exports = {
  ci: {
    collect: {
      url: URL,
      settings: {
        chromeFlags: "--no-sandbox --disable-dev-shm-usage",
      },
    },
    upload: {
      target: "lhci",
      serverBaseUrl: LHCI_SERVER,
      token: LHCI_TOKEN,
    },
  },
};
