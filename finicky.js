export default {
  defaultBrowser: "Safari",
  handlers: [
    {
      match: ["github.com/*","dashboard.garnet.ai/*"],
      browser: "Brave Browser"
    },
    {
      match: ["www.linkedin.com/*","app.graphite.dev/*","accounts.google.com/*", "meet.google.com/*"],
      browser: "Zen"
    },
    {  
      match: ["linear.app/*"],
      browser: "Linear"
    }
  ]
}
