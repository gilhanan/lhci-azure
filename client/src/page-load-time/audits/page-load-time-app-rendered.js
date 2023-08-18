import * as LH from "lighthouse";
import { formatMs, headings } from "./utils.js";

class AppRendered extends LH.Audit {
  static get meta() {
    return {
      id: "page-load-time-app-rendered",
      title: "Application rendered",
      failureTitle: "Application rendering time is too slow",
      description:
        "Audit for measuring Application rendering end. Calculates the slowest asset to load.",
      requiredArtifacts: ["PageLoadTime"],
    };
  }

  /**
   * @param {LH.Artifacts} artifacts
   * @param {LH.Audit.Context} context
   * @return {Promise}
   */
  static audit({ PageLoadTime }) {
    const {
      responseStart,
      responseEnd,
      slowestAssetDuration,
      duration: numericValue,
    } = PageLoadTime;

    const score = LH.Audit.computeLogNormalScore(
      {
        median: 5500,
        p10: 4000,
      },
      numericValue
    );

    const displayValue = `Application rendered after ${formatMs(
      numericValue
    )}s`;

    const results = [
      {
        origin: "Response Start",
        duration: responseStart,
      },
      {
        origin: "Response End",
        duration: responseEnd,
      },
      {
        origin: "Assets Loaded",
        duration: slowestAssetDuration,
      },
      {
        origin: "Application Rendered",
        duration: numericValue,
      },
    ];

    const details = LH.Audit.makeTableDetails(headings, results);

    return {
      score,
      numericValue,
      numericUnit: "millisecond",
      displayValue,
      details,
    };
  }
}

export default AppRendered;
