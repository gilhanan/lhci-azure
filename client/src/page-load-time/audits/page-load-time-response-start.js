import * as LH from "lighthouse";
import { formatMs } from "./utils.js";

class ResponseStart extends LH.Audit {
  static get meta() {
    return {
      id: "page-load-time-response-start",
      title: "Response start",
      failureTitle: "Response start time is too slow",
      description: "Audit for measuring Response start",
      requiredArtifacts: ["PageLoadTime"],
    };
  }

  /**
   * @param {LH.Artifacts} artifacts
   * @param {LH.Audit.Context} context
   * @return {Promise}
   */
  static audit({ PageLoadTime }) {
    const { responseStart: numericValue } = PageLoadTime;

    const score = LH.Audit.computeLogNormalScore(
      {
        median: 200,
        p10: 50,
      },
      numericValue
    );

    const displayValue = `Response starts after ${formatMs(numericValue)}s`;

    return {
      score,
      numericValue,
      numericUnit: "millisecond",
      displayValue,
    };
  }
}

export default ResponseStart;
