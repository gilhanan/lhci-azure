export function formatMs(ms) {
  return Math.round((ms / 1000) * 100) / 100;
}

export const headings = [
  {
    key: "origin",
    valueType: "text",
    granularity: 1,
    label: "Origin",
  },
  { key: "duration", valueType: "ms", granularity: 1, label: "Duration" },
];
