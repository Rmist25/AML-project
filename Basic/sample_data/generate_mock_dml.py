# Python Script: Generate Mock DML Scripts for AML Banking Project

"""
This script generates SQL INSERT statements with mock data for the AML banking schema.
- customers: 1000
- branches: 50
- accounts: 2000
- countries: 20
- transactions: 10000
- alerts: 500
- kyc_updates: 1000

Output: DML scripts saved in /sample_data as .sql files.
"""


import random
import faker
from datetime import datetime, timedelta, date

fake = faker.Faker()
random.seed(42)
faker.Faker.seed(42)

NUM_CUSTOMERS = 1000
NUM_BRANCHES = 50
NUM_ACCOUNTS = 2000
NUM_COUNTRIES = 20
NUM_TRANSACTIONS = 10000
NUM_ALERTS = 500
NUM_KYC_UPDATES = 1000

# Helper functions
def random_date(start, end):
    return fake.date_time_between(start_date=start, end_date=end)

def random_risk():
    return random.choice(['low', 'medium', 'high'])

def random_status():
    return random.choice(['active', 'closed', 'frozen'])

def random_account_type():
    return random.choice(['savings', 'current', 'loan'])

def random_channel():
    return random.choice(['ATM', 'branch', 'online', 'mobile'])

def random_transaction_type():
    return random.choice(['credit', 'debit'])

def random_kyc_status():
    return random.choice(['pending', 'verified', 'failed'])

# Generate countries
countries = []
for i in range(NUM_COUNTRIES):
    code = fake.country_code()
    name = fake.country()
    is_high_risk = random.choice([0, 1])
    countries.append((code, name, is_high_risk))

# Generate branches
branches = []
for i in range(1, NUM_BRANCHES+1):
    branches.append((i, fake.company(), fake.city(), random.choice(countries)[0]))

# Generate customers
customers = []
for i in range(1, NUM_CUSTOMERS+1):
    customers.append((i, fake.name(), fake.date_of_birth(minimum_age=18, maximum_age=80), fake.address().replace("'", ""), random_kyc_status(), random_risk(), fake.job(), random.choice(countries)[0]))

# Generate accounts
accounts = []
for i in range(1, NUM_ACCOUNTS+1):
    cust_id = random.randint(1, NUM_CUSTOMERS)
    branch_id = random.randint(1, NUM_BRANCHES)
    open_date = fake.date_between(start_date='-10y', end_date='-1y')
    close_date = open_date + timedelta(days=random.randint(0, 3650)) if random.random() < 0.2 else None
    accounts.append((i, cust_id, random_account_type(), open_date, close_date, random_status(), branch_id))

# Generate transactions
transactions = []
for i in range(1, NUM_TRANSACTIONS+1):
    acc_id = random.randint(1, NUM_ACCOUNTS)
    t_date = fake.date_time_between(start_date='-2y', end_date='now')
    amount = round(random.uniform(10, 50000), 2)
    t_type = random_transaction_type()
    channel = random_channel()
    counterparty_account = str(random.randint(10000000, 99999999))
    counterparty_bank = fake.company()
    currency = random.choice(['USD', 'EUR', 'INR', 'GBP'])
    description = fake.sentence(nb_words=6)
    transactions.append((i, acc_id, t_date, amount, t_type, channel, counterparty_account, counterparty_bank, currency, description))

# Generate alerts
alerts = []
for i in range(1, NUM_ALERTS+1):
    cust_id = random.randint(1, NUM_CUSTOMERS)
    acc_id = random.randint(1, NUM_ACCOUNTS)
    t_id = random.randint(1, NUM_TRANSACTIONS)
    alert_date = fake.date_time_between(start_date='-1y', end_date='now')
    alert_type = random.choice(['structuring', 'layering', 'high_value', 'dormant', 'kyc_failure'])
    status = random.choice(['open', 'closed', 'investigating'])
    investigator = fake.name()
    alerts.append((i, cust_id, acc_id, t_id, alert_date, alert_type, status, investigator))

# Generate kyc_updates
kyc_updates = []
for i in range(1, NUM_KYC_UPDATES+1):
    cust_id = random.randint(1, NUM_CUSTOMERS)
    update_date = fake.date_time_between(start_date='-3y', end_date='now')
    kyc_status = random_kyc_status()
    updated_by = fake.name()
    kyc_updates.append((i, cust_id, update_date, kyc_status, updated_by))

# Write DML scripts
def write_multirow_inserts(filename, batch_size=500):
    with open(filename, 'w', encoding='utf-8') as f:
        f.write('BEGIN TRANSACTION;\n')
        def write(table, columns, data):
            for i in range(0, len(data), batch_size):
                batch = data[i:i+batch_size]
                values_list = []
                for row in batch:
                    values = []
                    for v in row:
                        if v is None:
                            values.append('NULL')
                        elif isinstance(v, str):
                            values.append(f"'{v.replace("'", "''")}'")
                        elif isinstance(v, datetime):
                            values.append(f"'{v.strftime('%Y-%m-%d %H:%M:%S')}'")
                        elif isinstance(v, date):
                            values.append(f"'{v.strftime('%Y-%m-%d')}'")
                        else:
                            values.append(str(v))
                    values_list.append(f"({', '.join(values)})")
                f.write(f"INSERT INTO {table} ({', '.join(columns)}) VALUES\n  {',\n  '.join(values_list)};\n\n")
        write('countries', ['country_code','country_name','is_high_risk'], countries)
        write('branches', ['branch_id','branch_name','city','country_code'], branches)
        write('customers', ['customer_id','name','dob','address','kyc_status','risk_rating','occupation','country_code'], customers)
        write('accounts', ['account_id','customer_id','account_type','open_date','close_date','status','branch_id'], accounts)
        write('transactions', ['transaction_id','account_id','transaction_date','amount','transaction_type','channel','counterparty_account','counterparty_bank','currency','description'], transactions)
        write('alerts', ['alert_id','customer_id','account_id','transaction_id','alert_date','alert_type','status','investigator'], alerts)
        write('kyc_updates', ['kyc_update_id','customer_id','update_date','kyc_status','updated_by'], kyc_updates)
        f.write('COMMIT;\n')
        f.write('-- If any error occurs, you can use ROLLBACK; to undo all inserts.\n')

write_multirow_inserts('sample_data/aml_mock_data_inserts.sql')

print('Multi-row DML script generated: /sample_data/aml_mock_data_inserts.sql')
