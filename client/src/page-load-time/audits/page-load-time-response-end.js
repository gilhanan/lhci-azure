import * as LH from "lighthouse";
import { formatMs, headings } from "./utils.js";

class ResponseEnd extends LH.Audit {
  static get meta() {
    return {
      id: "page-load-time-response-end",
      title: "Response end",
      failureTitle: "Response end time is too slow",
      description: "Audit for measuring Response end",
      requiredArtifacts: ["PageLoadTime"],
    };
  }

  /**
   * @param {LH.Artifacts} artifacts
   * @param {LH.Audit.Context} context
   * @return {Promise}
   */
  static audit({ PageLoadTime }) {
    const { responseStart, responseEnd: numericValue } = PageLoadTime;

    const score = LH.Audit.computeLogNormalScore(
      {
        median: 600,
        p10: 200,
      },
      numericValue
    );

    const displayValue = `Response ends after ${formatMs(numericValue)}s`;

    const results = [
      {
        origin: "Response Start",
        duration: responseStart,
      },
      {
        origin: "Response End",
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

export default ResponseEnd;
