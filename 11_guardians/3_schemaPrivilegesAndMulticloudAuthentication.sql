        -- Part 3: Schema Privileges and Multicloud Authentication ✅☁️🔑


--  (i) Meanings, Values, Relations, and Advantages

--      Problem 3.1: Using Schema Privileges
-- The devUser needs to be able to query any table in the operationsData schema, both now and in the future, for development and debugging purposes.

-- Step A (As securityAdmin): Grant the developer the appropriate schema-level privilege.
-- Step B (As devUser): Verify that the user can query the existing SupplyInventory table.
-- Step C (As operationsData): Create a new table in the operationsData schema.
-- Step D (As devUser): Verify that the user can immediately query the new table without any additional grants being issued. This demonstrates the key advantage.
-- PostgreSQL Bridge: This single Oracle command, GRANT SELECT ANY TABLE ON SCHEMA..., is a more direct equivalent to the combination of PostgreSQL's GRANT USAGE ON SCHEMA and ALTER DEFAULT PRIVILEGES. It simplifies granting ongoing access to all of an application's tables.