# AML Banking Capstone Project

## Project Overview
This project demonstrates end-to-end data analysis for Anti-Money Laundering (AML) in a banking context, using realistic data models and SQL-driven analytics. The goal is to identify suspicious activity, generate actionable insights, and support AML compliance. All EDA and analysis are performed using SQL only.

## Business Problem
Money laundering poses significant risks to banks, including regulatory penalties and reputational damage. The project simulates real-world AML scenarios such as structuring, layering, dormant account reactivation, and KYC failures.

## Project Structure
- `/docs`: Business context, ERD, and process flows
- `/sample_data`: Python script for generating mock data
- `/setup_scripts`: DDL, DML scripts (schema, data loading, drop tables)
- `/analysis_sql`: All SQL-based EDA and AML analysis scripts

## How to Use This Project
1. **Set up the database**
   - Run `setup_scripts/aml_core_schema.sql` in SQL Server Management Studio (SSMS) to create the schema and tables in the `AML_Banking_Capstone` database.
2. **Load sample data**
   - Run the generated DML script (`sample_data/aml_mock_data_inserts.sql`) to populate the tables with mock data in the `AML_Banking_Capstone` database.
   Use the provided SQL scripts in `/analysis_sql` for EDA and AML pattern detection (structuring, layering, etc.). All analysis is SQL-based.
   - Use the provided SQL scripts in `/eda_scripts` for EDA and AML pattern detection (structuring, layering, etc.). All analysis is SQL-based.
   
## Key Files
- `setup_scripts/aml_core_schema.sql` — Create database & tables
- `sample_data/generate_mock_dml.py` — Generate mock data
- `analysis_sql/` — All SQL-based EDA & AML analysis
- `docs/` — Business context, ERD, and process flows

## Next Steps
- Add SQL scripts for EDA and AML pattern detection in `/analysis_sql`

## Example SQL Analysis Questions
- Which customers have unusually high transaction volumes?
- Are there accounts with frequent transactions just below reporting thresholds?
- Which accounts show rapid in-and-out movement of funds?
- Are there transactions involving high-risk countries?
- Who are the top branches by suspicious activity?
- Add SQL scripts for EDA and AML pattern detection in `/eda_scripts`

## Future Scope
- Build a Power BI dashboard for business insights

---

_This project is designed for portfolio demonstration and learning. All data is synthetic._
