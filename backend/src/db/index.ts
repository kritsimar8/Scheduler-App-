import {Pool} from "pg";
import {drizzle} from "drizzle-orm/node-postgres";

const pool = new Pool({
    connectionString: "postgresql://postgres:tiger123@localhost:5432/mydb"
});
export const db = drizzle(pool);