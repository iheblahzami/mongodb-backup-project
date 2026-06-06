# mongodb-backup-project
# Automated MongoDB Backups with Cloudflare R2

## Project Overview

This project demonstrates how to automate MongoDB database backups using Linux shell scripting, cron jobs, and Cloudflare R2 object storage.

The solution creates a compressed backup of a MongoDB database every 12 hours and uploads it to Cloudflare R2 for secure off-site storage. It also includes a disaster recovery procedure to restore the database from the latest backup.

This project simulates a real-world DevOps backup and recovery workflow and covers:

* Linux Administration
* MongoDB Backup & Restore
* Bash Scripting
* Scheduled Automation (Cron)
* Object Storage Integration
* Disaster Recovery
* Monitoring and Logging

---

## Architecture

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

## Technologies Used

| Technology    | Purpose             |
| ------------- | ------------------- |
| Ubuntu Linux  | Hosting environment |
| MongoDB       | Database            |
| Bash          | Backup automation   |
| Cron          | Scheduled execution |
| AWS CLI       | Upload files to R2  |
| Cloudflare R2 | Backup storage      |
| GitHub        | Version control     |

---

## Prerequisites

Before starting, ensure you have:

* Ubuntu Server
* MongoDB installed
* Cloudflare account
* Cloudflare R2 bucket
* AWS CLI installed
* Internet connectivity

---

## Project Structure

```text
automated-db-backups/
│
├── ├── mongo-backup.sh
│   └── restore.sh
│
├── ── architecture.png
│
├── backup.log
│
└── README.md
```

---

## Step 1 - Install MongoDB

Update packages:

```bash
sudo apt update
```

Install MongoDB:

```bash
sudo apt install -y mongodb
```

Enable service:

```bash
sudo systemctl enable mongodb
sudo systemctl start mongodb
```

Verify:

```bash
sudo systemctl status mongodb
```

---

## Step 2 - Create Sample Database

Open Mongo Shell:

```bash
mongosh
```

Create database:

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

## Step 3 - Configure Cloudflare R2

Create a bucket:

```text
mongodb-backups
```

Generate API credentials:

* Access Key ID
* Secret Access Key
* Account ID

Store them securely.

---

## Step 4 - Install AWS CLI

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

## Step 5 - Backup Script

Create:

```bash
nano mongo-backup.sh
```


Grant permissions:

```bash
chmod +x mongo-backup.sh
```

---

## Step 6 - Test Backup

Run manually:

```bash
./mongo-backup.sh
```

Expected output:

```text
upload: mongodb-2026-06-06-12-00.tar.gz
```

Verify the file appears in your R2 bucket.

---

## Step 7 - Automate Using Cron

Open crontab:

```bash
crontab -e
```

Add:

```bash
0 */12 * * * /home/ubuntu/mongo-backup.sh >> /home/ubuntu/backup.log 2>&1
```

Meaning:

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

## Step 8 - Monitoring

Check logs:

```bash
cat ~/backup.log
```

Check cron execution:

```bash
grep CRON /var/log/syslog
```

Monitor storage:

```bash
aws s3 ls s3://mongodb-backups \
--endpoint-url https://ACCOUNT_ID.r2.cloudflarestorage.com
```

---

## Database Restore Procedure

Create:

```bash
nano restore.sh
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

## Backup Verification

Verify backups regularly:

```bash
aws s3 ls s3://mongodb-backups \
--endpoint-url https://ACCOUNT_ID.r2.cloudflarestorage.com
```

Verify database contents:

```bash
mongosh
```

```javascript
use companydb
db.employees.find()
```

---

## Security Improvements

For production environments:

* Use MongoDB authentication.
* Encrypt backup files before uploading.
* Store credentials in environment variables.
* Restrict bucket permissions.
* Enable lifecycle policies.
* Implement backup retention.
* Monitor backup failures with alerts.

---

## Future Enhancements

* GitHub Actions scheduled backups
* Backup encryption using GPG
* Slack notifications
* Email alerts
* Backup retention policies
* Multi-region storage replication
* Kubernetes CronJob implementation
* Terraform deployment automation

---

## Learning Outcomes

After completing this project, you will gain practical experience with:

* MongoDB Administration
* Backup and Recovery Strategies
* Linux Automation
* Bash Scripting
* Cron Scheduling
* Cloud Storage Integration
* Disaster Recovery Planning
* DevOps Best Practices

---

## Author

**Mohamed Iheb**
DevOps & Cloud Engineer

### Skills Demonstrated

* Linux
* MongoDB
* Bash
* Cloudflare R2
* AWS CLI
* Automation
* Disaster Recovery
* DevOps Practices
