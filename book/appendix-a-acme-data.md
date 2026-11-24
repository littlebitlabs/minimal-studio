# Appendix A. The Acme data

Every example in this book reads the same database: the HR system of Acme Corporation, a fictional company. It is the database of the Book of Minimal, so a reader of both books meets the same rows. This appendix prints its schema, the facts the chapters check against it, and where to get the rows.

## Load it

The rows come in one file, `acme-database.sql`, from the Book of Minimal's download page. It holds the schema below and over 22,000 rows, and every value in it is fixed: load it twice and you get the same rows both times.

Give Acme a database and a login of its own, never the login of the Core's own store, then load the file as that login, all or nothing:

```bash
psql -U postgres -c "CREATE ROLE acme_app LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE"
psql -U postgres -c "\password acme_app"
psql -U postgres -c "CREATE DATABASE acme OWNER acme_app"
psql -h localhost -U acme_app -d acme -v ON_ERROR_STOP=1 -1 -f acme-database.sql
```

The book's copy runs in its own Postgres on the same Mac as the Core, on port 5434.

## The schema

Eight tables, two views and one materialized view.

```sql
CREATE TABLE department (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(60) NOT NULL,
    cost_centre VARCHAR(12) NOT NULL,
    head_email  VARCHAR(120),          -- NULL for one department
    created_at  TIMESTAMP NOT NULL
);

CREATE TABLE employee (
    id            SERIAL PRIMARY KEY,
    full_name     VARCHAR(120) NOT NULL,
    email         VARCHAR(160) NOT NULL,
    department_id INTEGER NOT NULL,
    manager_id    INTEGER,             -- NULL for the one employee with no manager
    title         VARCHAR(80) NOT NULL,
    hired_on      DATE NOT NULL,
    left_on       DATE,                -- NULL while employed
    phone         VARCHAR(32),
    is_active     BOOLEAN NOT NULL
);

CREATE TABLE salary (
    id           SERIAL PRIMARY KEY,
    employee_id  INTEGER NOT NULL,
    amount       NUMERIC(12,2) NOT NULL,
    currency     VARCHAR(3) NOT NULL,
    effective_on DATE NOT NULL
);

CREATE TABLE hike (
    id           SERIAL PRIMARY KEY,
    employee_id  INTEGER NOT NULL,
    pct          NUMERIC(12,2) NOT NULL,
    reason       VARCHAR(40) NOT NULL,
    effective_on DATE NOT NULL
);

CREATE TABLE holiday (
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(60) NOT NULL,
    region   VARCHAR(4) NOT NULL,
    observed DATE NOT NULL
);

CREATE TABLE leave_request (
    id          SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    kind        VARCHAR(16) NOT NULL,
    status      VARCHAR(10) NOT NULL,
    start_on    DATE NOT NULL,
    end_on      DATE NOT NULL,
    days        INTEGER NOT NULL,
    note        VARCHAR(200)           -- free text, may be NULL
);

CREATE TABLE attendance (
    id          SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    on_date     DATE NOT NULL,
    hours       NUMERIC(12,2) NOT NULL,
    source      VARCHAR(12) NOT NULL
);

CREATE TABLE audit_note (
    id          SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    author      VARCHAR(120) NOT NULL,
    body        TEXT NOT NULL,
    written_at  TIMESTAMP NOT NULL
);

CREATE INDEX idx_employee_department ON employee (department_id);
CREATE INDEX idx_employee_manager    ON employee (manager_id);
CREATE INDEX idx_salary_employee     ON salary (employee_id, effective_on);
CREATE INDEX idx_hike_employee       ON hike (employee_id, effective_on);
CREATE INDEX idx_leave_employee      ON leave_request (employee_id, start_on);
CREATE INDEX idx_leave_status        ON leave_request (status);
CREATE INDEX idx_attendance_employee ON attendance (employee_id, on_date);
CREATE INDEX idx_holiday_observed    ON holiday (region, observed);

CREATE VIEW v_employee_directory AS
SELECT e.id,
       e.full_name,
       e.email,
       e.title,
       d.name        AS department,
       d.cost_centre AS cost_centre,
       m.full_name   AS manager_name
FROM employee e
JOIN department d ON d.id = e.department_id
LEFT JOIN employee m ON m.id = e.manager_id
WHERE e.is_active = TRUE;

CREATE VIEW v_leave_balance AS
SELECT e.id AS employee_id,
       e.full_name,
       COUNT(l.id) AS requests,
       SUM(CASE WHEN l.status = 'approved' THEN l.days ELSE 0 END) AS days_taken
FROM employee e
LEFT JOIN leave_request l ON l.employee_id = e.id
GROUP BY e.id, e.full_name;

CREATE MATERIALIZED VIEW mv_headcount_by_department AS
SELECT d.id AS department_id,
       d.name,
       d.cost_centre,
       COUNT(e.id) AS headcount,
       SUM(CASE WHEN e.is_active = TRUE THEN 1 ELSE 0 END) AS active_headcount
FROM department d
LEFT JOIN employee e ON e.department_id = d.id
GROUP BY d.id, d.name, d.cost_centre;

CREATE UNIQUE INDEX idx_mv_headcount_department ON mv_headcount_by_department (department_id);
```

## Facts to check against

These are what the chapters and their exercises assert. Each is fixed by the file.

| Table | Rows |
|---|---|
| `department` | 12 |
| `employee` | 120 |
| `salary` | 431 |
| `hike` | 311 |
| `holiday` | 144 |
| `leave_request` | 1515 |
| `attendance` | 19511 |
| `audit_note` | 400 |

- Of the 120 employees, 11 are no longer active.
- Employee 1 is Rafael Delacroix, Chief Executive, the one employee with no manager.
- One department has no head.
- Of the 1,515 leave requests, 955 are `approved`, 303 are `pending` and 257 are `rejected`. Every request lasts from 1 to 10 days.
- All 400 `audit_note` rows have the same author, `hr.system@acme.example`.
- The pending requests by department: Legal 42, Support 39, Field Sales 34, Security 32, People 30, Product 30, Data 28, Design 26, Finance 23, Platform 13, Engineering 6. Research has no employees, so no requests.
- Employee 7, Margaret O'Brien, has 21 leave requests: 15 approved (78 days, 24 of them in requests that start in 2026), 3 pending (ids 91, 99 and 101, of 1, 8 and 7 days, in order of start date) and 3 rejected (27 days).
- Employee 11, Priya Okonkwo, Senior Engineer in Design, has approved 9 requests (53 days), pending 2 (18 days: ids 132 and 145, of 8 and 10 days) and rejected 4 (17 days).
- Employee 1 has no approved leave that starts in 2026, and six pending requests, none longer than 7 days.
- Fourteen of the 120 employees have no phone, employee 1 and employee 5 among them; employees 2, 3 and 4 have phones that end 8653, 4273 and 0635.
- The 120 employees hold eleven different titles, from Analyst to Staff Engineer.

Two parts of the schema matter to the administrator's chapters: `salary` is the table worth hiding, and `employee.email` is the column worth binding to the person who signs in. Chapter 24 binds `audit_note.author`, which holds one value in all 400 rows.

## The definition

The whole of **pending-leave**, as the **Editor** tab of Chapter 9 shows it after its version 1.1 and its attributes are saved. The password is the mask the Core shows in place of the real one, and the documentation is stored encoded, as the editor shows it.

```yaml
config:
    cache_result: false
    coalesce: false
    rollback_version: null
database:
    idle_timeout_secs: 600
    machine:
        - host: host.docker.internal
          port: "5434"
    max_idle_connections: 5
    max_open_connections: 20
    name: acme
    password: '********'
    timeout_secs: 60
    type: postgres
    username: acme_app
http:
    input_type: json
    method: get
    uri: /leave/pending
    version: "1.1"
identifiers:
    feature_id: 01M71FXZBSEPEH3MSWMMFDCFC7
    org_id: 01M71FK9Q22HEWKXCGBQ0YK992
    project_id: 01M71FT36T7RTFSXS40NVZ9MZK
    space_id: 01M71FVQJ2XCB7KAQT8BHW0W1E
    user_id: john.doe
logic:
    - omit: false
      sql: |
        SELECT d.name AS department, COUNT(*) AS pending
        FROM leave_request l
        JOIN employee e ON e.id = l.employee_id
        JOIN department d ON d.id = e.department_id
        WHERE l.status = 'pending'
        GROUP BY d.name
        ORDER BY pending DESC, d.name
metadata:
    documentation: TGVhdmUgcmVxdWVzdHMgYXdhaXRpbmcgYXBwcm92YWwsIGNvdW50ZWQgYnkgZGVwYXJ0bWVudC4=
    tags:
        - leave
        - hr
permission:
    - admin
```
