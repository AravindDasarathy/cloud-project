import app from './app.js';
import { initDb } from './db.js';
import { APP_PORT } from './configs.js';

await initDb();

app.listen(APP_PORT, console.log(`Server running on port ${APP_PORT}`));