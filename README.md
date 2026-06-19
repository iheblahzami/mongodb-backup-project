
https://roadmap.sh/projects/automated-backups


# 🚀 Automated MongoDB Backups with Cloudflare R2

> A DevOps project that automates MongoDB backups using Bash scripting, Cron Jobs, and Cloudflare R2 object storage for secure off-site backup and disaster recovery.





\

---

## 📖 Overview

Managing reliable database backups is a critical part of any production environment. This project demonstrates how to automate MongoDB backups on a Linux server and securely store them in Cloudflare R2.

The workflow:

✅ Creates MongoDB backups using `mongodump`
✅ Compresses backups into `.tar.gz` archives
✅ Uploads backups to Cloudflare R2
✅ Runs automatically every 12 hours using Cron
✅ Supports disaster recovery through automated restore procedures

---

## ✨ Features

* 🔄 Automated MongoDB backups
* 📦 Compressed backup archives
* ☁️ Cloudflare R2 integration
* ⏰ Scheduled execution with Cron
* 📝 Logging and monitoring
* 🔐 Secure off-site storage
* ♻️ Disaster recovery support
* 🐧 Linux-based automation

---

## 🏗️ Architecture

```text
+------------------+
| Ubuntu Server    |
+------------------+
         |
         v
+------------------+
| MongoDB Database |
+------------------+
         |
         v
+------------------+
| mongodump        |
+------------------+
         |
         v
+------------------+
| tar.gz Archive   |
+------------------+
         |
         v
+------------------+
| Cloudflare R2    |
+------------------+

Scheduled every 12 hours using Cron
```

---

## 🛠️ Tech Stack

| Technology    | Purpose                   |
| ------------- | ------------------------- |
| Ubuntu Linux  | Hosting Environment       |
| MongoDB       | Database                  |
| Bash          | Automation Scripts        |
| Cron          | Scheduling                |
| AWS CLI       | Cloudflare R2 Integration |
| Cloudflare R2 | Object Storage            |
| GitHub        | Version Control           |

---

## 📂 Project Structure

```text
automated-db-backups/
│
├── scripts/
│   ├── mongo-backup.sh
│   └── restore.sh
│
├── docs/
│   └── architecture.png
│
├── logs/
│   └── backup.log
│
└── README.md
```

---

## ✅ Prerequisites

Before getting started, ensure you have:

* Ubuntu Server
* MongoDB installed
* AWS CLI installed
* Cloudflare account
* Cloudflare R2 bucket
* Internet connectivity

---

# 🚀 Setup Guide

## 1️⃣ Install MongoDB

Update packages:

```bash
sudo apt update
```

Install MongoDB:

```bash
sudo apt install -y mongodb
```

Enable and start the service:

```bash
sudo systemctl enable mongodb
sudo systemctl start mongodb
```

Verify installation:

```bash
sudo systemctl status mongodb
```

---

## 2️⃣ Create a Sample Database

Open Mongo Shell:

```bash
mongosh
```

Create a database:

```javascript
use companydb
```

Insert sample data:

```javascript
db.employees.insertMany([
  {
    name: "Ahmed",
    role: "DevOps Engineer"
  },
  {
    name: "Sara",
    role: "Software Developer"
  }
])
```

Verify:

```javascript
db.employees.find()
```

---

## 3️⃣ Configure Cloudflare R2

Create a bucket:

```text
mongodb-backups
```

Generate API credentials:

* Access Key ID
* Secret Access Key
* Account ID

Store these credentials securely.

---

## 4️⃣ Install AWS CLI

Install:

```bash
sudo apt install -y awscli
```

Verify:

```bash
aws --version
```

Configure:

```bash
aws configure
```

Example:

```text
AWS Access Key ID: ********
AWS Secret Access Key: ********
Region: auto
Output Format: json
```

---

## 5️⃣ Create the Backup Script

Create the script:

```bash
nano mongo-backup.sh
```

Paste:

```bash
#!/bin/bash

DATE=$(date +"%Y-%m-%d-%H-%M")

BACKUP_DIR=/tmp/mongodb-backup-$DATE

mkdir -p $BACKUP_DIR

mongodump \
  --db companydb \
  --out $BACKUP_DIR

tar -czf mongodb-$DATE.tar.gz $BACKUP_DIR

aws s3 cp \
mongodb-$DATE.tar.gz \
s3://mongodb-backups/ \
--endpoint-url https://ACCOUNT_ID.r2.cloudflarestorage.com

rm -rf $BACKUP_DIR
rm mongodb-$DATE.tar.gz
```

Make executable:

```bash
chmod +x mongo-backup.sh
```

---

## 6️⃣ Test the Backup

Run manually:

```bash
./mongo-backup.sh
```

Expected output:

```text
upload: mongodb-2026-06-06-12-00.tar.gz
```

Verify that the backup appears in your Cloudflare R2 bucket.

---

## 7️⃣ Automate Backups with Cron

Open crontab:

```bash
crontab -e
```

Add:

```bash
0 */12 * * * /home/ubuntu/mongo-backup.sh >> /home/ubuntu/backup.log 2>&1
```

### Cron Schedule

```text
Minute: 0
Hour: Every 12 hours
Day: Every day
Month: Every month
Weekday: Every day
```

Verify:

```bash
crontab -l
```

---

## 📊 Monitoring & Logs

View backup logs:

```bash
cat ~/backup.log
```

Check Cron execution:

```bash
grep CRON /var/log/syslog
```

List backups stored in R2:

```bash
aws s3 ls s3://mongodb-backups \
--endpoint-url https://ACCOUNT_ID.r2.cloudflarestorage.com
```

---

# ♻️ Disaster Recovery

## Restore Database from Latest Backup

Create:

```bash
nano restore.sh
```

Paste:

```bash
#!/bin/bash

LATEST=$(aws s3 ls \
s3://mongodb-backups \
--endpoint-url https://ACCOUNT_ID.r2.cloudflarestorage.com \
| sort \
| tail -n 1 \
| awk '{print $4}')

aws s3 cp \
s3://mongodb-backups/$LATEST \
. \
--endpoint-url https://ACCOUNT_ID.r2.cloudflarestorage.com

tar -xzf $LATEST

mongorestore mongodb-backup-*/
```

Make executable:

```bash
chmod +x restore.sh
```

Run:

```bash
./restore.sh
```

---

## ✅ Backup Verification

Verify backups exist:

```bash
aws s3 ls s3://mongodb-backups \
--endpoint-url https://ACCOUNT_ID.r2.cloudflarestorage.com
```

Verify restored data:

```bash
mongosh
```

```javascript
use companydb
db.employees.find()
```

---

## 🔒 Security Best Practices

For production environments, consider implementing:

* MongoDB authentication
* Backup encryption (GPG/OpenSSL)
* Environment variables for secrets
* IAM-style access restrictions
* Lifecycle management policies
* Backup retention strategies
* Monitoring and alerting
* Multi-region backup replication

---

## 🚀 Future Improvements

* GitHub Actions scheduled backups
* Backup encryption using GPG
* Slack notifications
* Email alerts
* Backup retention policies
* Multi-region replication
* Kubernetes CronJobs
* Terraform automation
* Monitoring dashboards
* Backup health checks

---

## 🎯 Learning Outcomes

This project demonstrates practical experience with:

* MongoDB Administration
* Backup & Recovery Strategies
* Linux System Administration
* Bash Scripting
* Cron Scheduling
* Cloud Storage Integration
* Disaster Recovery Planning
* DevOps Best Practices

---

## 📸 Screenshots (Optional)

Add screenshots to make the project more attractive:

* MongoDB database creation
* Successful backup execution
* Cloudflare R2 bucket contents
* Cron configuration
* Restore process
* Backup logs

---




