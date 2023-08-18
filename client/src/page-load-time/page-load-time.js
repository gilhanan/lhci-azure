import * as LH from "lighthouse";

class PageLoadTime extends LH.Gatherer {
  meta = {
    supportedModes: ["navigation"],
  };

  async getArtifact({ driver }) {
    const pageLoadTime = await driver.executionContext.evaluateAsync(
      "window.pageLoadTime"
    );

    if (!pageLoadTime) {
      throw new Error("Unable to find PageLoadTime");
    }

    return pageLoadTime;
  }
}

export default PageLoadTime;
