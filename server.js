const { createServer } = require("@lhci/server");
const {
  useIdentityPlugin,
  DefaultAzureCredential,
} = require("@azure/identity");

const {
  IDENTITY_ENDPOINT,
  ENVIRONMENT: environment,
  MYSQL_SERVER_NAME: mysqlServerName,
  MYSQL_DATABASE_NAME: mysqlDatabaseName,
  SQL_DATABASE_PATH: sqlDatabasePath,
  SQL_DIALECT: sqlDialect,
  WEBSITES_PORT: port,
} = process.env;

if (environment === "development") {
  const { vsCodePlugin } = require("@azure/identity-vscode");
  useIdentityPlugin(vsCodePlugin);
}

async function getAccessToken() {
  console.log("Getting Managed Identity credentials...");

  const credential = new DefaultAzureCredential();
  const { token } = await credential.getToken(
    "https://ossrdbms-aad.database.windows.net/.default"
  );

  console.log("Got Managed Identity credentials.");

  return token;
}

function getUser() {
  return IDENTITY_ENDPOINT ? "lhci" : "lhci@gilhanangmail.onmicrosoft.com";
}

async function startServer() {
  console.log("Starting server...");

  const user = getUser();
  const password = await getAccessToken();

  const sqlConnectionUrl = `mysql://${user}:${password}@${mysqlServerName}.mysql.database.azure.com:3306/${mysqlDatabaseName}`;

  await createServer({
    port,
    storage: {
      storageMethod: "sql",
      sqlDialect,
      sqlConnectionUrl,
      sqlDatabasePath,
      sqlDialectOptions: {
        authPlugins: {
          mysql_clear_password: () => () => Buffer.from(password + "\0"),
        },
      },
    },
  });

  console.log("LHCI listening on port", port);
}

startServer();
