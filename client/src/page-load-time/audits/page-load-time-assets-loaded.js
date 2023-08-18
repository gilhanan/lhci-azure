import * as LH from "lighthouse";
import { formatMs, headings } from "./utils.js";

class AssetsLoaded extends LH.Audit {
  static get meta() {
    return {
      id: "page-load-time-assets-loaded",
      title: "Assets loaded",
      failureTitle: "Assets loading time is too slow",
      description:
        "Audit for measuring Assets loading end. Calculates the slowest asset to load.",
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
      slowestAssetDuration: numericValue,
    } = PageLoadTime;

    const score = LH.Audit.computeLogNormalScore(
      {
        median: 4000,
        p10: 2000,
      },
      numericValue
    );

    const displayValue = `Assets loaded after ${formatMs(numericValue)}s`;

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

export default AssetsLoaded;
