const { createServer } = require("@lhci/server");
const { DefaultAzureCredential } = require("@azure/identity");
const { jwtDecode } = require("jwt-decode");

const { mysqlServerName, mysqlDatabaseName, mysqlUser, port } = process.env;

let serverInstance = null;

async function getAccessToken() {
  console.log("Getting Managed Identity credentials...");

  const credential = new DefaultAzureCredential();
  const { token } = await credential.getToken(
    "https://ossrdbms-aad.database.windows.net/.default"
  );

  console.log("Got Managed Identity credentials.");

  return token;
}

function getTokenExpirationTime({ token }) {
  const { exp } = jwtDecode(token);
  return exp * 1000;
}

async function startServer() {
  console.log("Starting server...");

  const token = await getAccessToken();

  const sqlConnectionUrl = `mysql://${mysqlUser}:${token}@${mysqlServerName}.mysql.database.azure.com:3306/${mysqlDatabaseName}`;

  serverInstance = await createServer({
    port,
    storage: {
      storageMethod: "sql",
      sqlDialect: "mysql",
      sqlConnectionUrl,
      sqlDialectOptions: {
        authPlugins: {
          mysql_clear_password: () => () => Buffer.from(token + "\0"),
        },
      },
    },
  });

  console.log("Server started. listening on port", serverInstance.port);

  const expirationTimeMs = getTokenExpirationTime({ token });

  scheduleServerRestart({ expirationTimeMs });
}

function scheduleServerRestart({ expirationTimeMs }) {
  const bufferTimeMs = 2 * 60 * 1000;
  const restartInMs = expirationTimeMs - Date.now() - bufferTimeMs;

  console.log(
    `Scheduling server restart in ${(restartInMs / 1000 / 60).toFixed(
      2
    )} minutes.`
  );

  setTimeout(async () => {
    console.log("Access token about to expire.");
    await restartServer();
  }, restartInMs);
}

async function closeServer() {
  if (serverInstance) {
    console.log("Closing server...");
    await serverInstance.close();
    console.log("Server closed.");
  }
}

async function restartServer() {
  console.log("Restarting server...");
  await closeServer();
  await startServer();
  console.log("Server restarted.");
}

startServer();
